#!/bin/bash

# Description: Monitor disk usage health for remote systems

# In this log file the info about du for remote hosts is written: a var is used for reference to work with it:
logfile="diskusage.log"

# if there is an argument (calling script with filename as argument), then logfile is that filename passed by:
if [[ -n $1 ]]
then
	logfile=$1
fi

# if the logfile does not exist, it is created
if [ ! -e $logfile ]
then
	printf "%-8s %-14s %-9s %-8s %-6s %-6s %-6s %s\n" "Date" "IP address" "Device" "Capacity" "Used" "Free" "Percent" "Status" > $logfile
else
	numberLines=$(cat $logfile | wc -l)
	sed -i "2,$numberLines d" $logfile # everything removed except header for file
fi

# IP_LIST=$(ping -a 10.57.122.0/24 -g 2>/dev/null)
IP_LIST="10.57.122.76"

(
for ip in $IP_LIST
do
	# ssh (with auto-login using keys) to execute remotely command dh -H in each host from the IP_LIST, one by one in the for loop: (a user must have auto-login)
	ssh natasa@$ip 'df -H' | grep '^/dev/' | sort -nrk 1 >> /tmp/remote_hosts_$$.df

	while read line; # read line from file specified in last line, done
	do
		cur_date=$(date +%D)
		printf "%-8s %-14s " $cur_date $ip

		echo $line | awk '{ printf("%-9s %-8s %-6s %-6s %-8s",$1,$2,$3,$4,$5); }'

		pusg=$(echo $line | egrep -o "[0-9]+%") # get only numbers, wildcard is number plus %
		pusg=${pusg/\%/} # slicing, percentage out, only keeping number
		if [ $pusg -lt 80 ]
		then
			echo SAFE
		else
			echo ALERT
		fi
	done< /tmp/remote_hosts_$$.df
done
) >> $logfile
