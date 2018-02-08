#!/bin/bash

logFile="prueba1.log"
        pathLog=$logFile
	counterCheck=0
        # If hostname is not recorded in our file returns 0 records, then installation of puppet + manifests deployment after cert is signed$
        (if [ $counterCheck -eq 0 ]
        then
                #echo $hostnameChecking >> /recordedHosts/recordedHosts.txt # hostname is now recorded
                #arrayDeployedHosts[indexArrayDepl]=$hostnameChecking
                #let indexArrayDepl++
                # Defining log file for this host:
                #logFile="$hostnameChecking.$timestamp.log"
                #pathLog=logs/$logFile
                #echo "Hostname: $hostnameChecking recorded as new client, therefore we proceed with puppet-agent installation if not install$
                # First the id_rsa.pub server key is sent to the client in order to allow ssh autologin without password to be entered
                echo "Public server key sent to client allowing ssh autologin with root privileges" 
                #scp /root/.ssh/id_rsa.pub root@$host:/root/.ssh/authorized_keys2 
                # Client is recorded in bind9 DNS zone files (db.10 and db.ip14aai.com):
                #recordEntryDNS
                # Client is added in the list of Nagios3 monitored hosts, services defined in common template:
                echo "Host is added in the list of clients to be monitored by Nagios3"
                pepe
                # calling function which starts puppet agent installation && deploy manifests:
                #installPuppetAgent
                #deployingManifests
        fi) 2>&1 | tee $pathLog # stdout in the screen, plus tee redirection to log file
