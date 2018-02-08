#!/bin/bash
# see more examples in Cookbook-2nd-Ed ... page 49

function check_file()
{
	if [ -e $1 ]
	then
		echo "Existing path or Filename $1"
		let token++
	else
		echo "'Path or Filename $1 does not exist"
	fi
}

token=0

while [ $token -eq 0 ]
do
	read -p 'Enter filename to search for: ' input
	check_file $input
done
