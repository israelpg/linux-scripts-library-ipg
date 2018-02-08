#!/bin/bash
# Name: puppet_validate_signCerts.sh - version 1.1
# date: 21/09/2017 - developed by Israel Palomino Garcia
# Summary: Automate agent certificate request approval when there is a new hostname in our network, this script
# is called by detect detectNewHosts.sh script (hostname is parameter)

echo "Hostname $1 requesting its certificate to be signed"

token=0

while [ $token -eq 0 ]
do
	read -p "Do you want to sign certificate for hostname $1 ? Y/N ? " promptInput
	if [ $promptInput == 'Y' ]
	then
		echo "Right, you want to sign certificate for hostname $1"
		let token++
		sudo /opt/puppetlabs/bin/puppet cert sign $1
		echo "Certificate signed off, the complete list of certificates is now:"
		sudo /opt/puppetlabs/bin/puppet cert list --all
	elif [ $promptInput == 'N' ]
	then
		echo "Certificate requested by $1 has been rejected"
		echo "Deployment of packages and configurations are not pushed to this agent"
		let token++
	else
		echo "Please, type Y or N \n"
	fi
done
