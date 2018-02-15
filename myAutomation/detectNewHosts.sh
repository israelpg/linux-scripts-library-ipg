#!/bin/bash

# Title: detectNewHosts.sh
# Version: 1.0
# Date: 19/09/2017 - Author: Israel Palomino Garcia
# Description: This bash shell script detects new hostnames in our network missing puppet installation, then it pushes the installation of
# the puppet client utilities. Once done, certificate request is signed, and manifests are deployed, including openLDAP.
# Assumptions: All client machines have same root password, client hostnames have been assigned and registered in DNS Server.

function recordEntryDNS()
{
	hostAssignedIP=$(awk -F '.' '{print $4}' <<< "$host") # last 8 bits of IP address is kept
	hostnameNoDomain=$(awk -F '.' '{print $1}' <<< "$hostnameChecking")
	echo "$hostAssignedIP	IN	PTR	$hostnameChecking." >>/etc/bind/zones/db.10
	echo "$hostnameNoDomain	IN	A	$host" >>/etc/bind/zones/db.ip14aai.com
}

function hostMonitoring()
{
#
# Nagios, adding host for monitoring: Create file by cp the client_template.cfg file in /etc/nagios3/conf.d
# then, sed -i to substitute the client_hostname, client_IP, and client_alias in the new file by values passed
# as argument in this script :)
#
	mv /etc/nagios3/conf.d/client_template.cfg /etc/nagios3/conf.d/$hostnameChecking.cfg
	hostNoDomain=$(awk -F '.' '{print $1}' <<< $hostnameChecking)
	sed -i "s/client_hostname/$hostNoDomain/" /etc/nagios3/conf.d/$hostnameChecking.cfg
	sed -i "s/client_IP/$host/" /etc/nagios3/conf.d/$hostnameChecking.cfg
	sed -i "s/client_alias/$hostnameChecking/" /etc/nagios3/conf.d/$hostnameChecking.cfg
}

function installPuppetAgent()
{
	echo "Checking if puppet-agent is already installed in $hostnameChecking"
	ssh -t root@$host "dpkg -l | grep 'puppet' >/tmp/resultQuery.log ; cat /tmp/resultQuery.log"  >/tmp/outputQuery_$$.log
	countQuery=$(cat /tmp/outputQuery_$$.log | wc -w)
	if [[ $countQuery -gt 0 ]]
	then
        	echo "puppet-agent package is already installed in this client machine, no further action required other than checking manifests"
	else
        	echo "puppet-agent is not installed in $hostnameChecking ...  installation will begin:"
		echo "Transfering puppetlabs-pc1-xenial.deb package to client machine..."
                rsync -avz /home/ip14aai/Downloads/puppetlabs-release-pc1-xenial.deb root@$host:/usr/share
                echo "File transfered, starting installation..."
		ssh -t root@$host "dpkg -i /usr/share/puppetlabs-release-pc1-xenial.deb && apt-get update && apt-get install puppet-agent && systemctl enable puppet.service ;
				systemctl start puppet.service ; rm /usr/share/puppetlabs-release-pc1-xenial.deb"
	        echo "Installation of puppet-agent package completed. Enabling and starting puppet service completed"
		echo "Certificate request issued by $hostnameChecking will be signed off by puppet-server"
		bash puppet_validate_signCerts.sh $hostnameChecking
	fi

}

function deployingManifests()
{
        bash puppet_deploying_changes.sh $hostnameChecking && arrayDeployedHosts[indexArrayDepl] = $hostnameChecking ; let indexArrayDepl++

}

# starting script..

timestamp=$(date +"%d-%m-%y")

# Getting list of active hosts in our network:
#activeHosts=$(fping -a -g 10.57.121.0/24 2>/dev/null) --> this is the real production code line
activeHosts=$(fping 10.136.137.107 | awk '{ print $1 }') # temp solution to apply in only client machine used for testing purposes

# our file with hostnames recorded in the server: If recorded, no further installation is pushed
recordedHosts=/recordedHosts/recordedHosts.txt
arrayDeployedHosts=()
indexArrayDepl=0

for host in $activeHosts
do
	echo "$timestamp - Checking for new hosts in the network"
	# getting just hostname removing last character .
	hostnameChecking=$(nslookup 10.136.137.107 | awk '{print $4}' | rev | cut -c 2- | rev)
	# Defining log file for this host, which will only created if is a new client to be recorded/deployed
        logFile="$hostnameChecking.$timestamp.log"
        pathLog=logs/$logFile
	# cross-check the hostname with our file acting as a db for hostnames recorded in the server
	counterCheck=$(cat $recordedHosts | grep $hostnameChecking | wc -l)
	# If hostname is not recorded in our file returns 0 records, then installation of puppet + manifests deployment after cert is signed, plus record DNS entry in bind9
	(if [ $counterCheck -eq 0 ]
	then
		echo $hostnameChecking >> /recordedHosts/recordedHosts.txt # hostname is now recorded
		echo "Hostname: $hostnameChecking has been recorded as new client, therefore we proceed with puppet-agent installation if not installed yet" >> $pathLog
		# First the id_rsa.pub server key is sent to the client in order to allow ssh autologin without password to be entered
		echo "Public server key sent to client allowing ssh autologin with root privileges"
		scp /root/.ssh/id_rsa.pub root@$host:/root/.ssh/authorized_keys2
		# Client is recorded in bind9 DNS zone files (db.10 and db.ip14aai.com):
		recordEntryDNS
		# Client is added in the list of Nagios3 monitored hosts, services defined in common template:
		echo "Host is added in the list of clients to be monitored by Nagios3"
		hostMonitoring
		# calling function which starts puppet agent installation && deploy manifests:
		installPuppetAgent
		deployingManifests
	fi) 2>&1 | tee -a $pathLog # stdout in the screen, plus tee redirection to log file
done

numberHostsDeployed=${#arrayDeployedHosts[*]}

if [ $numberHostsDeployed -gt 0 ]
then
	echo "The following hosts have been recorded and/or checked for manifest(s) deployment: "
	echo ${arrayDeployedHosts[*]}
else
	echo "Any new hosts have been manifests to be deployed, either all hosts in our network are already deployed either you chose not to deploy."
fi
