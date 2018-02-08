#!/bin/bash

# Title: detectNewHosts.sh
# Version: 1.0
# Date: 19/09/2017 - Author: Israel Palomino Garcia
# Description: This bash shell script detects new hostnames in our network missing puppet installation, then it pushes the installation of
# the puppet client utilities. Once done, certificate request is signed, and manifests are deployed, including openLDAP.
# Assumptions: All client machines have same root password, client hostnames have been assigned and registered in DNS Server.

function deployingManifests()
{
	bash puppet_deploying_changes.sh $hostnameChecking && arrayDeployedHosts[indexArrayDepl] = $hostnameChecking ; let indexArrayDepl++

}

function installPuppetAgent()
{
	echo "Checking if puppet-agent is already installed in $hostnameChecking... "
	ssh -t root@$host "dpkg -l | grep 'puppet' >/tmp/resultQuery.log ; cat /tmp/resultQuery.log"  >/tmp/outputQuery_$$.log

	countQuery=$(cat /tmp/outputQuery_$$.log | wc -w)

	if [[ $countQuery -gt 0 ]] ;
	then
        	echo "puppet-agent package is already installed in this client machine, no further action required other than checking manifests"
	else
        	echo "puppet-agent is not installed, please type root password to confirm installation: "
		echo "Transfering puppetlabs-pc1-xenial.deb package to client machine..."
                rsync -avz /home/ip14aai/Downloads/puppetlabs-release-pc1-xenial.deb root@$host:/usr/share
                echo "File transfered, starting installation..."
		ssh -t root@$host "dpkg -i /usr/share/puppetlabs-release-pc1-xenial.deb && apt-get update && apt-get install puppet-agent && systemctl enable puppet-agent ;
				rm /usr/share/puppetlabs-release-pc1-xenial.deb"
	        echo "Installation of puppet-agent package completed. Enabling and starting puppet service completed.";
		bash puppet_validate_signCerts.sh $hostnameChecking
	fi
}

# Getting list of active hosts in our network:
#activeHosts=$(fping -a -g 10.57.121.0/24 2>/dev/null) --> this is the real production code line
activeHosts=$(fping 10.57.121.192 | awk '{ print $1 }') # temp solution to apply in only client machine used for testing purposes

# our file with hostnames recorded in the server: If recorded, no further installation is pushed
recordedHosts=/recordedHosts/recordedHosts.txt
arrayDeployedHosts=()
indexArrayDepl=0

for host in $activeHosts
do
	nslookup $host > /tmp/hostToCheck_$$.log
	hostnameChecking=$(cat /tmp/hostToCheck_$$.log | awk '{ print $4 }')
	hostnameChecking=$(echo $hostnameChecking | rev | cut -c 2- | rev) # removing last character  .
	# cross-check the hostname with our file acting as a db for hostnames recorded in the server
	counterCheck=$(cat $recordedHosts | grep $hostnameChecking | wc -l)
	# If hostname is not recorded in our file returns 0 records, then installation of puppet + manifests deployment after cert is signed
	if [ $counterCheck -eq 0 ]
	then
		echo $hostnameChecking >> /recordedHosts/recordedHosts.txt # hostname is now recorded
		arrayDeployedHosts[indexArrayDepl]=$hostnameChecking
		let indexArrayDepl++
		echo "Hostname: $hostnameChecking recorded as new client, therefore we proceed with puppet-agent installation if not installed yet"
		# calling function which starts puppet agent installation && deploy manifests:
		installPuppetAgent
		deployingManifests
	fi
done

numberHostsDeployed=${#arrayDeployedHosts[*]}

if [ $numberHostsDeployed -gt 0 ]
then
	echo "The following hosts have been recorded and/or checked for manifest(s) deployment: "
	echo ${arrayDeployedHosts[*]}
else
	echo "Any new hosts have been manifests to be deployed, either all hosts in our network are already deployed either you chose not to deploy."
fi
