#!/bin/bash

token=0

if [[ ! -n $1 ]]
then
	echo "Please, call script passing one username as argument"
else
	USERNAME=$1
	let token++
fi

if [ $token -gt 0 ]
then
	devices=$(ls -l /dev/pts/* | grep $USERNAME | awk '{print $10}')
	for dev in $devices
	do
		cat /dev/stdin > $dev
	done
fi
