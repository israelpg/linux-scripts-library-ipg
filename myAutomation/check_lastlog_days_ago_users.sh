#!/bin/bash
# Date: 04/04/2018
# Author: ip14aai
# Rationale: This script calculates the number of days ago a user was lastlog in the system
# if the user has not logged in for more than 45 days ago, it is removed from the system

# functions
function deleteUser()
{
	tokenInput="true"
	while [[ $tokenInput == "true" ]]
	do
		read -p "User: $user has not logged in $daysAgo days ago, do you want to remove it from the system? (Y/N): " inputDelete
		case $inputDelete in
			Y) echo "User: $user deleted" ; tokenInput="false";;
			N) echo "User: $user not deleted" ; tokenInput="false";;
			*) echo -e "Wrong option, please type Y (Yes) or N (No)\n" 	
		esac
	done
}

# getting the current date in seconds %s
currentDate=$(date +%s)
currentDate=$(echo "$currentDate" / 86400 | bc)

echo -e "Script init ... checking for users who have not logged in for the last 45 days ...\n"

# discard never logged in users, get only username
for user in $(lastlog | grep -iv 'never logged in' | tail -n +2 | awk '{print $1}')
do
	# get only date in seconds for lastlog of this specific $user
	dateLastlog=$(date --date "$(lastlog | grep "$user" | awk '{print $4,$5,$6}')" +%s)
	(( dateLastlog=dateLastlog / 86400 )) # converting into days
	# calculate difference between currentDate and dateLastLog for this $user
	(( daysAgo="$currentDate" - dateLastlog )) 
	
	# if number of days ago is greater than <value> then it will be deleted or not upon admin's decision
	if (( daysAgo > 45 ))
	then
		deleteUser $user $daysAgo
	fi	
done

