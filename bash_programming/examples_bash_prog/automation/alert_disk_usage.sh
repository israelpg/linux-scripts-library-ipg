#!/bin/bash
set -o errexit
set -o nounset

while read line;
do
	filesystem=$(echo $line | awk '{print $1}')
	percentage=$(echo $line | awk '{print $5}' | tr -d '%')
	if [ $percentage -ge 75 ]
	then
		echo "Warning: $filesystem is at $percentage %"
	fi
done < <(df -h --total | grep -vi filesystem)
