#!/bin/bash

usage()
{
cat << EOF
Script $0 help instructions:
$0 -h for help
$0 -v for version number
$0 -s for correct execution!
EOF
}

while getopts "hvs" OPTION
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
	s)
		echo "Success, this option executes the rest of the script..."
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
	echo "Well, it seems you called the script $0 with option s, well done!"
	exit 0
else
	echo "You have called the script without passing any option"
	usage
	exit 1
fi
