#!/bin/bash

echo "pid for this running script is: $$"

filename=$(basename $0).log

(
while (( COUNT < 10 ))
do
	sleep 1
	let COUNT++
	echo $COUNT
done
) 2>&1 | tee -a $filename


echo "completed"
exit 0
