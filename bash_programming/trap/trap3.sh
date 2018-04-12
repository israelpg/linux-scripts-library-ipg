#!/bin/bash

timestamp=$(date +"%d-%m-%y")
filenameLog=$timestamp.$(basename $0).log
filePID="/tmp/$timestamp.$(basename $0).pid"

# this first trap is to delete pid file when an exit occurs
trap 'rm -f $filePID; ' EXIT
# this trap is executed with a closing signal/term 15 executed, then it triggers exit with trap rm
trap 'echo "$0 script is terminating via code 15 closing signal/term" ; exit 3' 15 2>&1 | tee -a $filenameLog

echo "$timestamp" > $filenameLog

if [[ ! -f  $filePID ]]
then
	touch $filePID
	echo "File $filePID has been created" >> $filenameLog
else
	echo "" > $filePID
fi

echo "pid: $$ for this running script $0 is saved in file: $filePID" >&1 | tee -a $filenameLog
echo $$ > $filePID
echo "Kill the pid $$ by running: kill -9 $$ or using the file as ref: kill -9 $ (cat $filePID)"

(
while (( COUNT < 50 ))
do
	sleep 1
	let COUNT++
	echo $COUNT
done
echo "completed"
) 2>&1 | tee -a $filenameLog

exit 0
