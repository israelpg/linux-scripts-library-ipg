#!/bin/bash
# Script: wall_extended_scripted_v2.sh
# Description: From the list of logged in users, via prompt select one to send a broadcast message to terminal(s)
# Author: Israel Palomino Garcia

list_users=/tmp/list_users_$$.log
who | awk '{ print $1 }' | uniq > $list_users
echo "The list of users: " ; cat $list_users

token_user=0

while [ $token_user -eq 0 ]
do
	read -p "Please, type one user from the list to send a message: " user
	check_user=/tmp/check_user_$$.log
	grep $user $list_users > $check_user
	number_lines=$(cat $check_user | wc -l)
	if [ $number_lines -gt 0 ]
	then
		let token_user++
	else
		echo "Please, select a valid user from the list"
		echo "The list of users: " ; cat $list_users
	fi
done

devices=$(ls -l /dev/pts/* | grep $user | awk '{print $10}')
read -p "Enter message to send to user $user : " message

for dev in $devices
do
	echo "$message" > $dev
done


