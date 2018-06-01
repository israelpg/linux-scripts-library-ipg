#!/bin/bash

set -o errexit
set -o nounset

# Setting a trap for exit in order to clean files when exiting script:
#trap "rm ..." exit

# By default the script examines the /var/log/secure file (RedHat logging file / access recorded):
AUTHLOG=/var/log/secure

# Main concern is about failed password, not the unknown user attempt:
# this is a failed password line:
# Feb 21 10:30:54 02DI20161235444 sshd[16330]: Failed password for pepe from 10.136.137.107 port 61201 ssh2
# this is a wrong username line:
# Feb 21 10:34:49 02DI20161235444 sshd[16393]: Failed password for invalid user pedro from 10.136.137.107 port 61297 ssh2

# But if there is an argument $1, it means that this script was called passing an argument/filename different than /var/log/secure
if [[ -n $1 ]]
then
	AUTHLOG=$1
	echo "Using log file: $1 instead of /var/log/secure"
fi

# Reference: I will work with a variable LOG, which refers to a file in the tmp folder. When you redirect to LOG, you write in the file
LOG=/tmp/checking_logins.$$.log

# First filter, we drop from our log file, the lines where username was wrong
# grep -v means that all lines except invalid will be redirected, we do not want attempt with only wrong username, no problem there, just concerned about wrong password for valid user
grep -v 'invalid' $AUTHLOG > $LOG

# fetching IPs from local machines commiting failed password: (Note: same IP might have tried with several valid users)
IPS_INTRUDERS=$(cat $LOG | grep -i 'failed password' | awk '{print $(NF-3)}' | sort | uniq)

# Creating the list of users commiting failed password
USERS=$(cat $LOG | grep -i 'failed password' | awk '{ print $(NF-5) }' | sort | uniq)

printf "The complete list of attempts detailed below:\n"
printf "%-5s|%-10s|%-10s|%-14s|%-37s|%s\n" "Sr#" "User" "Attempts" "IP address" "Time range"

ucount=0

for ip in $IPS_INTRUDERS;
do
	# IMPORTANT: Same IP can attempt several times with different users !!!
	grep $ip $LOG > /tmp/intruderIP_$ip.log

	for user in $USERS; # for this intruderIP, check only failed password for those users attempted
	do
		# filtering by IP, user by user only failed
		cat /tmp/intruderIP_$ip.log | grep -i 'failed password' | grep $user > /tmp/userFailed_$$.log # here you filter failed ones
		# from the file, cut chars so that you only get the time
		cut -c-16 /tmp/userFailed_$$.log > /tmp/$$.time
		# take the first failed attempt of accessing the server via ssh
		tstart=$(head -1 /tmp/$$.time);
		# date with -d to take it from var instead of ctime, and format is %s meaning timestamp
		start=$(date -d "$tstart" "+%s");
		# last time trying to access the server getting failed password
		tend=$(tail -1 /tmp/$$.time);
		end=$(date -d "$tend" "+%s");

		limit=$(($end -$start))

		# if limit, difference between 1st and last attempt is gt 20s, then is an intruder
		if [ $limit -gt 20 ];
		then
			let ucount++;
			TIME_RANGE="$tstart --> $tend"
			ATTEMPTS=$(cat /tmp/userFailed_$$.log | wc -l);
			# HOST=$(host $IP | awk '{print $NF}'); --> this only if checking internal attacks
			printf "%-5s|%-10s|%-10s|%-10s|%-33s|%-s\n" "$ucount" "$user" "$ATTEMPTS" "$ip" "$TIME_RANGE";
		fi
		rm /tmp/userFailed_$$.log /tmp/$$.time
	done
	rm /tmp/intruderIP_$ip.log
done

rm /tmp/checking_logins.$$.log 2>/dev/null
