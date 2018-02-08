#!/bin/bash
# see more examples in Cookbook-2nd-Ed ... page 49

function check_file()
{
	[ -e $1 ] && ls -lah $1 ; let token++
	[ -e $1 ] || echo 'Try again mate'
}

token=0

while [ $token -eq 0 ]
do
	read -p 'Enter filename to search for: ' input
	check_file $input
done
