#!/bin/bash

function function2()
{
	echo "index is $1"
	echo "value is $2"
	array1[$1]=$2
	echo ${array1[*]}
}

export -f function2

bash child_calls_expF.sh
