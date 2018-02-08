#!/bin/bash

PIDARRAY=()

for i in {1..5}
do
	dd if="/dev/zero" of="file.$i.log" bs="1M" count=30
#	PIDARRAY+=("$!") # with $! it holds the PID of the running process in the arrray
done
#wait ${PIDARRAY[@]} # wait / doing this technique you prevent loop to finish earlier than processes
