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
i for installing script $0 in user's folder
f for folder name to be created --> $0 -f <folder_name>
EOF
}

# detecting user
username=$(whoami)

# checking options passed when calling script $0:
while getopts "hvif:" OPTION
do
	case $OPTION in
	h)	
		usage
		exit 0
		;;
	v)
		echo "$0 Version 1.0"
		exit 0
		;;
	i)
		echo "Installing script $0 in user's bin folder..."
		cp $0 /home/${username}/bin/
		usage
		exit 0
		;;
	f)
		chrootFolder=$OPTARG
		;;
	*)
		echo "Wrong option chosen"
		usage
		exit 1
		;;
	esac
done

if [[ $# -eq 0 ]]
then
	echo "No argument has been passed as folder name, exiting..."
	usage
	exit 1
fi

# if an argument has been passed script $0 continues
# Creating file structure:
if [[ ! -z $chrootFolder ]]
then
	if [[ ! -d $chrootFolder ]]
	then
		mkdir -p ${chrootFolder}/{bin,etc,lib,lib64} &&
		echo "PS1='JAIL $ '" > ${chrootFolder}/etc/bash.bashrc
	else
		echo "Folder ${chrootFolder} already exists, exiting script"
		exit 0
	fi
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
