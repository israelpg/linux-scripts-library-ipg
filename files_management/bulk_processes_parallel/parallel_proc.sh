#!/bin/bash
# generate checksums for each .iso file - cookbook, p102

PIDARRAY=()

for file in *.iso # this would work as well: $(find -type f -iname '*.iso')
do
	md5sum $file > ${file%.*}.md5 & # background process while continue with script
	PIDARRAY+=("$!") # with $! it holds the PID of the running process in the arrray
done
wait ${PIDARRAY[@]} # wait / doing this technique you prevent loop to finish earlier than processes

