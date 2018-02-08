#!/bin/bash

function find()
{
	echo $1
	[ -f $1 ] && echo $command
	[ -f $1 ] || echo "Cannot find $1"
}

token=0
command=$(pwd ; ls -lah ; let token++)

while [ $token -eq 0 ]
do
	read -p 'Enter path or filename: ' var
	find $var
done
