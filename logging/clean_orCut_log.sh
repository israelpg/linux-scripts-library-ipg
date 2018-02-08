#!/bin/bash
# Description: Logged in as root, make up a specific log

LOG_DIR=/tests/var/log
ROOT_UID=0
LINES=50
E_XCD=86 # cannot change dir
E_NOTROOT=87 # uid is not root

# check user logged in, must be root in order to continue execution with privileges
if [ $UID -ne $ROOT_UID ]
then
	echo "You must be logged in as root, with uid 0 in order to continue with this script"
	exit $E_NOTROOT
fi

# check if there is an argument which is related to number of lines, used for the tail of log
if [[ -n $1 ]]
then
	lines=$1
else
	echo "Right, so no argument passed for number of lines, therefore, we assume is: " $LINES
	lines=$LINES
fi
# working in logs directory
cd $LOG_DIR || {
	echo "Cannot change to directory $LOG_DIR"
	exit $E_XCD
}

token=0
while [ $token -eq 0 ]
do
	ls -lah
	read -p "Select one of the logs to be maked up, including extension if applicable: " thisLog
	find . -maxdepth 1 -type f -iname "$thisLog" > /tmp/thisLog_$$.temp # returns ./<log_name>
	varLogExists=$(cat /tmp/thisLog_$$.temp | wc -l)
	if [ "$varLogExists" -eq 0 ]
	then
		echo "Log typed does not exist in $LOG_DIR"
	else
		validLog=$(cat /tmp/thisLog_$$.temp | grep -o "$thisLog") # grep to slice only filename
		echo "validLog is: " $validLog
		echo "number of lines: " $lines
		log="$LOG_DIR/$validLog"
		log_temp=/tmp/log_$$.temp
		tail -n $lines $log > $log_temp
		mv $log_temp $thisLog
		let token++
	fi
done
# cat /dev/null > wtmp # in case we want to delete sessions info
exit 0 # successful completion of this script
