#!/bin/bash
# Date: 04/04/2018
# Author: ip14aai
# Rationale: This script calculates the number of days ago a user was lastlog in the system

for user in $(lastlog | grep -iv 'never logged in' | tail -n +2 | awk '{print $1}')
do
	# user date lastlog in seconds, --date expects a date string which we convert in seconds %s
	dateLastlog=$(date --date "$(lastlog | grep "$user" | awk '{print $4,$5,$6}')" +%s)
	(( dateLastlog = dateLastlog / 86400 )) # converting into days
	currentDate=$(date +%s)
	(( currentDate=currentDate / 86400 ))
	(( daysAgo=currentDate - dateLastlog )) 
	echo "Username: $user logged in $daysAgo"	
done

