#!/bin/bash

# this script will detect all binaries in the /usr/sbin folder which can be used with TCP wrappers

set -o errexit

FOLDER="/usr/sbin/"
BIN_FILES=$(ls ${FOLDER} >/tmp/listbins_$$.log)

if [[ $? != 0 ]]
then
	exit 1
fi	

while read line
do
	checkLib=$(ldd ${FOLDER}/${line} | grep 'libpam.so' | wc -l)
	if [[ $checkLib -gt 0 ]]
	then
		echo "$line is a service handled by PAM Module"
	fi 
done < /tmp/listbins_$$.log

