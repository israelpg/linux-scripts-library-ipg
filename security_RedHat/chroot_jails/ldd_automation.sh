#!/bin/bash

# This script setups a chroot folder environment, and 

set -o errexit
#set -o nounset

usage()
{
cat << EOF
Help menu for script $0 - Argument options are:
$0 -<argument>

h for help
v for version
f for folder name to be created --> $0 -f <folder_name>
EOF
}

# checking argument options when creating script $0:
while getopts "h:v:f" OPTION
do
	case $OPTION in
	h)	
		usage
		exit 1
		;;
	v)
		echo "$0 Version 1.0"
		exit 1
		;;
	f)
		chrootFolder=$OPTARG
		;;
	esac
done

# Creating file structure:
if [[ ! -z $chrootFolder ]]
then
	if [[ ! -d $chrootFolder ]]
	then
		mkdir -p ${chrootFolder}/{bin,etc,lib,lib64} &&
		echo "PS1='JAIL $ '" | tee ${chrootFolder}/etc/bash.bashrc
	else
		echo "Folder ${chrootFolder} already exists, exiting script"
		exit 1
	fi
else
	echo "Please, provide a valid folder name to be created"
	usage
	exit 1
fi

# binaries_array: List of binaries needed in our chroot folder
array_bins=(ls touch bash)

# copying the libraries into the chroot folder:
# get length of array with binaries, determining number of binaries:
lengthArray=${#array_bins[*]}

# for each binary:
for ((i=0; i<lengthArray; i++))
do
	binary=${array_bins[$i]}
	# copy binary into chroot folder:
	cp /bin/${binary} ${chrootFolder}/bin/ 

	# getting lib dependencies for binary and copy them into chroot folder:
	while read line
	do
		# getting if folder is /lib/ or /lib64/:
		libFolder=$(echo ${line} | cut -d '/' -f 2)
		# copy lib into correct folder:
		cp ${line} ${chrootFolder}/${libFolder}/
	done < <(ldd /bin/${binary} | tail -n +2 | awk '{print $(NF-1)}')
done
