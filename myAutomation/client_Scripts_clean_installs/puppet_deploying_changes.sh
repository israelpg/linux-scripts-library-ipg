#!/bin/bash
# date: 29/06/2017 - developed by Israel Palomino Garcia
# Summary: Automate deploying puppet policies into selected agents - version 1.0
# Recommendatios: implement ssh auto-login with authorized_keys in server

echo "List of manifest(s) to be implemented: \n"
ls -lah /etc/puppetlabs/code/environments/production/manifests

# Retrieve all certificates
sudo /opt/puppetlabs/bin/puppet cert list --all > /tmp/list_certs_$$.log
list_certs=/tmp/list_certs_$$.log

# From all certificates, just get those which are already signed off
list_signedHosts=$(grep '^+' $list_certs | cut -d ' ' -f 2 | tr -d '"')

for host in $list_signedHosts
do
	echo $host
	token=0
	array_deployed_hosts=()
	index_array=0
	while [ $token -eq 0 ]
	do
		read -p "Do you want to deploy manifest(s) in host $host ? Y/N ? " promptInput
		if [ $promptInput == 'Y' ]
		then
			echo "Right, you want to deploy manifest(s) in host $host"
			let token++
			array_deployed_hosts[index_array]=$host
			let index_array++
			sudo ssh -t natasa@$host 'sudo /opt/puppetlabs/bin/puppet agent --test'
		elif [ $promptInput == 'N' ]
		then
			echo "Manifest(s) not deployed in $host"
			let token++
		else
			echo "Please, type Y or N \n"
		fi
	done
done

number_deployed=${#array_deployed_hosts[*]}

if [ $number_deployed -gt 0 ]
then
	echo "The list of hosts where manifest(s) deployed: "
	echo ${array_deployed_hosts[*]}
else
	echo "Any deployment performed."
fi

