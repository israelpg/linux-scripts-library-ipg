#!/bin/bash

set -o errexit
set -o nounset

timestamp=$(date +"%d-%m-%y")

# program requests for prompt input from user:
# first it displays a list of active hosts which are not recorded in database/file, user selects which one to record/deploy

#activeHosts=$(fping -a -g 10.57.121.0/24 2>/dev/null) --> this is the real production code line
activeHosts=$(fping 10.136.137.95 | awk '{ print $1 }') # temp solution to apply in only client machine used for testing purposes

# our file with hostnames recorded in the server: If recorded, no further installation is pushed
recordedHosts=recordedHosts/recordedHosts.txt
hostsToDeploy=toDeploy/$timestamp.newHosts.txt

if [[ ! -f $hostsToDeploy ]]
then
	touch $hostsToDeploy
fi

arrayDeployedHosts=()
indexArrayDepl=0
echo "$timestamp - Checking for new Hosts in the Network"

for host in $activeHosts
do
       	# getting just hostname removing last character .
        hostnameChecking=$(nslookup $host | awk '{print $4}' | tr -d '\n' | rev | cut -c 2- | rev)
	# cross-check the hostname with our file acting as a db for hostnames recorded in the server
        counterCheck=$(cat $recordedHosts | grep $hostnameChecking | wc -l)
	# if not recorded, then is added in the list of candidates hostsToDeploy
	if [[ $counterCheck -eq 0 ]]
        then
               	indexHosts=$(cat $hostsToDeploy | wc -l)
               	indexHosts=$(echo "$indexHosts+1" | bc)
            	echo "$indexHosts $host $hostnameChecking" >> $hostsToDeploy
        fi
done

cat $hostsToDeploy
tokenIndex=0
while [[ $tokenIndex -eq 0 ]]
do
        read -p "Please select one host from the above list by typing index number or q to exit: " indexSelected
        validIndex=$(grep "^$indexSelected 10." $hostsToDeploy | wc -l)
       	if [[ $indexSelected == 'q' ]]
	then
		exit 0
	fi;
	if [[ $validIndex -eq 1 ]]
       	then
               	tokenIndex=$(echo "$tokenIndex+1" | bc)
	fi
done

echo "And here more code goes for deploying the selected host in index: $indexSelected"

