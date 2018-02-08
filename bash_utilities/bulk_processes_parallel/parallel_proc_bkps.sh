#!/bin/bash
# backup .iso file in multiple processes / background & - cookbook, p102

PIDARRAY=()

for dir in $(sudo find . -type f -user 'natasa' -iname '*.zip')
do
	tar -jcvf ${dir%.*}.tar.bz2 . &
	#md5sum $dir > ${$file%.*}.md5

	PIDARRAY+=("$!") # with $! it holds the PID of the running process in the arrray
done
wait ${PIDARRAY[@]} # wait / doing this technique you prevent loop to finish earlier than processes
