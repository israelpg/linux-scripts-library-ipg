#!/bin/bash

# Description: Monitor disk usage health for remote systems

# In this log file the info about du for remote hosts is written: a var is used for reference to work with it:
logfile="cpu_mem_usage.log"

# if there is an argument (calling script with filename as argument), then logfile is that filename passed by:
if [[ -n $1 ]]
then
	logfile=$1
fi

# if the logfile exists, we remove content
if [ -e $logfile ]
then
	echo '' > $logfile
fi

# IP_LIST=$(fping -a 10.57.122.0/24 -g 2>/dev/null)
IP_LIST="10.57.121.95"

(
cur_date=$(date +%D)
echo $cur_date
for ip in $IP_LIST
do
	# ssh (with auto-login using keys) to execute remotely command dh -H in each host from the IP_LIST, one by one in the for loop: (a user must have auto-login)
	# grep -v to display lines which do not contain %, which is the header for default output of ps -eo command line
	ssh natasa@$ip 'ps -eo comm,tty,user,pcpu,pmem --sort -pmem' | grep -v '%' | head -n 5 > /tmp/remote_info_$ip.log

	# printing the header for the lines concerning details for each IP
	echo $ip
	printf "%-15s %-5s %-15s %-8s %-8s %-15s %-15s\n" "Command" "TTY" "User" "%CPU" "%MEM" "Status CPU" "Status MEM"

	while read line; # read line from file specified in last line, done (IP by IP)
	do
		# calculating the percentages to check if it is OK value or WARN, after removing decimal part .*
		echo $line | awk '{ print $4 }' > /tmp/pcpu_$$.log
                echo $line | awk '{ print $5 }' > /tmp/pmem_$$.log
                pcpuCol=$(cat /tmp/pcpu_$$.log)
                pcpu=${pcpuCol/\.*}
                pmemCol=$(cat /tmp/pmem_$$.log)
                pmem=${pmemCol/\.*}
                if [ $pcpu -lt 10 ]
                then
                        statusPCPU="OK"
                else
                        statusPCPU="WARN"
                fi
                if [ $pmem -lt 10 ]
                then
                        statusPMEM="OK"
                else
                        statusPMEM="WARN"
                fi
		# adding status variables in the $line:
		line+=" $statusPCPU $statusPMEM"
		echo $line | awk '{ printf("%-15s %-5s %-15s %-8s %-8s %-15s %-15s",$1,$2,$3,$4,$5,$6,$7); }'
		echo ""
	done< /tmp/remote_info_$ip.log
done
) >> $logfile
