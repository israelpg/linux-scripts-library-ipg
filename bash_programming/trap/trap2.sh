#!/bin/bash

filePID="/tmp/$(basename $0).pid"

if [[ -f  $filePID ]]
then
	rm $filePID
else
	touch $filePID
fi

echo "pid: $$ for this running script $0 is saved in file: $filePID"
echo $$ > $filePID
echo "Kill the pid $$ by running: kill -9 $$ or using the file as ref: kill -9 $ (cat $filePID)"

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
