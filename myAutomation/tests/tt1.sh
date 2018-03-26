#!/bin/bash

varText=""

if [[ $(echo $varText | wc -l ) -eq 1 ]]
then
	echo "there is at least one line"
else
	echo "well, no lines at all"
fi
