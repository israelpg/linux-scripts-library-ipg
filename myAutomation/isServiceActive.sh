#!/bin/bash -x

#set -o errexit
set -o nounset

function checkService
{
	systemctl -H ip14aai@10.136.137.107 status $service
}

read -p "enter the service to check if is active: " service

checkService $service

if [[ $? -eq 0 ]]
then
	echo "$service is active"
	exit 0
else
	echo "$service is not active or unknown input"
	exit 1
fi
