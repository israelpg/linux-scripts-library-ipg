#!/bin/bash

read -p "Please enter a number: " var11

(if [ $var11 -eq 0 ]
then
	echo "is 0"
else
	echo "not 0"
fi) > output_$$.log
