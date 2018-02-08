#!/bin/bash
# date: 28/06/2017 - developed by Israel Palomino Garcia
# Summary: Automate agent certificate requests approval - version 1.0

sudo /opt/puppetlabs/bin/puppet cert list > /tmp/list_requests_$$.log
list_requests=/tmp/list_requests_$$.log
cat $list_requests

list_hosts=$(cut -d ' ' -f 3 $list_requests | tr -d '"')
cat $list_hosts

for host in $list_hosts
do
	echo $host
	token=0
	array_signed_hosts=()
	index_array=0
	while [ $token -eq 0 ]
	do
		read -p "Do you want to sign certificate for host $host ? Y/N ? " promptInput
		if [ $promptInput == 'Y' ]
		then
			echo "Right, you want to sign certificat for host $host"
			let token++
			array_signed_hosts[index_array]=$host
			let index_array++
			sudo /opt/puppetlabs/bin/puppet cert sign $host
		elif [ $promptInput == 'N' ]
		then
			echo "Certificate requested by $host has been rejected"
			let token++
		else
			echo "Please, type Y or N \n"
		fi
	done
done

number_signed=${#array_signed_hosts[*]}

if [ $number_signed -gt 0 ]
then
	echo "The list of requests signed include the following hosts: "
	echo ${array_signed_hosts[*]}
else
	echo "None of the requested certificates was signed off"
fi

echo "Current list of certificate requests remaining to be signed, if any: "
sudo /opt/puppetlabs/bin/puppet cert list


