#!/bin/bash

echo "This script displays the arguments passed"

# $# is the number of arguments passed when calling the script $0
# command shift is used to move to next argument, which then will be $1, printed

while [[ $# -ne 0 ]]
do
	echo $1
	shift
done

# output:

#[ip14aai@02DI20161235444 bash_programming]$ bash tests/passing.sh 10 20 30 40
#This script displays the arguments passed
#10
#20
#30
#40
