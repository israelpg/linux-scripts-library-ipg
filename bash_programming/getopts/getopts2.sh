#!/bin/bash

usage()
{
cat << EOF
Script $0 help instructions:
$0 -h for help
$0 -v for version number
$0 -f for passing a filename as argument
EOF
}

# hv are options, do not have colon at the end, whereas f has colon : (expects an argument: filename)
while getopts "hvf:" OPTION
do
	case $OPTION in
	h)
		echo "Listing help"
		usage
		exit 0
		;;
	v)
		echo "$0 Version 1.0"
		exit 0
		;;
	f)
		filename=$OPTARG
		echo "Script $0 called passing filename: ${filename}"
		;;
	*)
		echo "No valid option passed when calling script $0"
		usage
		exit 1
		;;
	esac
done

if [[ $# -ne 0 ]]
then
	echo "Well, it seems you called the script $0 passing argument filename ${filename}!"
	exit 0
else
	echo "You have called the script without passing any option nor argument."
	usage
	exit 1
fi
