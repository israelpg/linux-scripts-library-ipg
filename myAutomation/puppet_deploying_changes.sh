#!/bin/bash
# date: 29/06/2017 - developed by Israel Palomino Garcia
# Summary: Automate deploying puppet policies into selected agents - version 1.0
# Recommendatios: implement ssh auto-login with authorized_keys in server

serverHostname=$1

echo "List of manifest(s) to be implemented or checked for revision in $1:"
ls -lah /etc/puppetlabs/code/environments/production/manifests

token=0
while [ $token -eq 0 ]
do
	read -p "Do you want to check and/or deploy manifest(s) in host $1 ? Y/N?  " promptInput
	if [ $promptInput == 'Y' ]
	then
		echo "Right, you want to deploy manifest(s) in host $1"
		let token++
		# you may probably want to check if puppet.service is enabled&active: systemctl -H user@host "status puppet.service", checking what returns
		ssh -t root@$1 '/opt/puppetlabs/bin/puppet agent --test'
	elif [ $promptInput == 'N' ]
	then
		echo "Manifest(s) not deployed in $1"
		let token++
	else
		echo "Please, type Y or N"
	fi
done
