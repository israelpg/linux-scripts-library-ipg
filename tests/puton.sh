#!/bin/bash

readonly folder="/var/log"

readonly file="messages"

resultGrep=$(cat $folder/$file | grep -ci 's')

echo "resultGrep = $resultGrep"

if [[ $resultGrep -gt 25 ]]
then
	echo "big file"
else
	echo "malecki"
fi
