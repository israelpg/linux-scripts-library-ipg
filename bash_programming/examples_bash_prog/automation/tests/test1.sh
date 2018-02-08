#!/bin/bash

read -p "Enter a number: " number

case "$number" in
[0-9]|10)
	echo "del 0 al 10"
	;;
1[1-9]|20)
	echo "del 11 al 20"
	;;
21)
	echo "21! Black Jack!"
	;;
esac
