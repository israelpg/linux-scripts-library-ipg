#!/bin/bash

# By default the script examines the auth.log file
AUTHLOG=/var/log/auth.log

#But if there is an argument $1, it means that this script was called passing an argument/filename different than auth.log
if [[ -n $1 ]]
then
	AUTHLOG=$1
	echo "Using log file: $1 instead of /var/log/auth.log"
fi

# Reference: I will work with a variable LOG, which refers to a file in the tmp folder. When you redirect to LOG, you write in the file
LOG=/tmp/valid.$$.log

# grep -v means that all lines except invalid will be redirected, we do not want attempt with only wrong username, no problem there, just concerned about wrong password for valid user
grep -v 'invalid' $AUTHLOG > $LOG

# Creating the list of users commiting wrong password
USERS=$(cat $LOG | grep 'Failed password' | awk '{ print $(NF-5)}' | sort | uniq)

# Creating the list of IPs attempting access, failed or not, all of them
IP_LIST=$(egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' $LOG | sort | uniq)
# IP_LIST=$(cat $LOG | awk '{print $(NF-3)}' | sort | uniq)

printf "%-5s|%-10s|%-10s|%-13s|%-33s|%s\n" "Sr#" "User" "Attempts" "IP address" "Host_Mapping" "Time range"

ucount=0

for ip in $IP_LIST;
do
	# IMPORTANT: Same IP can attempt several times with different users !!!
	grep $ip $LOG > /tmp/temp.$$.log

	for user in $USERS;
	do
		# filtering by IP, user by user only failed
		cat /tmp/temp.$$.log | grep 'Failed password' | grep $user > /tmp/$$.log # here you filter failed ones
		# from the file, cut chars so that you only get the time
		cut -c-16 /tmp/$$.log > $$.time
		# take the first failed attempt of accessing the server via ssh
		tstart=$(head -1 $$.time);
		# date with -d to take it from var instead of ctime, and format is %s meaning timestamp
		start=$(date -d "$tstart" "+%s");
		# last time trying to access the server getting failed password
		tend=$(tail -1 $$.time);
		end=$(date -d "$tend" "+%s");

		limit=$(($end -$start))

		# if limit, difference between 1st and last attempt is gt 20s, then is an intruder
		if [ $limit -gt 20 ];
		then
			let ucount++;
			IP=$(egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' /tmp/$$.log | head -1);
			TIME_RANGE="$tstart-->$tend"
			ATTEMPTS=$(cat /tmp/$$.log|wc -l);
			HOST=$(host $IP | awk '{print $NF}');

			printf "%-5s|%-10s|%-10s|%-10s|%-33s|%-s\n" "$ucount" "$user" "$ATTEMPTS" "$IP" "$HOST" "$TIME_RANGE";
		fi
	done
done

rm /tmp/valid.$$.log /tmp/$$.log $$.time /tmp/temp.$$.log 2>/dev/null


