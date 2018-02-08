#!/bin/bash
#Filename: delay_script.sh

echo -n Count:
tput sc #tput sc = tput store cursor

count=0;
while true;
do
	if [ $count -lt 40 ];
	then
		let count++;
		sleep 1;
		tput rc # retrieve cursor
		tput ed 
		echo -n $count;
	else exit 0;
	fi
done
