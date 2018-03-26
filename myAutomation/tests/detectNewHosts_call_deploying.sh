#!/bin/bash

timestamp=$(date +"%d-%m-%y")

function deployHost()
{
        (
       	# Defining log file for this host, which will only created if is a new client to be recorded/deployed
        logFile="$2.$timestamp.log"
        pathLog=logs/$logFile
        # recording the host in the db/file:
        echo $2 >> /recordedHosts/recordedHosts.txt # hostname is now recorded
        echo "Hostname: $2 has been recorded as new client with IP $1, therefore we proceed with puppet-agent installation if not installed yet" >> $pathLog
        # First the id_rsa.pub server key is sent to the client in order to allow ssh autologin without password to be entered
        echo "Public server key sent to client allowing ssh autologin with root privileges"
       # scp /root/.ssh/id_rsa.pub root@$1:/root/.ssh/authorized_keys2
        # Client is recorded in bind9 DNS zone files (db.10 and db.ip14aai.com):
       # recordEntryDNS
        # Client is added in the list of Nagios3 monitored hosts, services defined in common template:
        echo "Host is added in the list of clients to be monitored by Nagios3"
        #hostMonitoring
        # calling function which starts puppet agent installation && deploy manifests:
        #installPuppetAgent
        #deployingManifests
        ) 2>&1 | tee -a $pathLog
}

hostIP2Deploy=$(cat toDeploy/26-03-18.newHosts.txt | awk '{print $2}')
hostname2Deploy=$(cat toDeploy/26-03-18.newHosts.txt | awk '{print $3}')

deployHost $hostIP2Deploy $hostname2Deploy
