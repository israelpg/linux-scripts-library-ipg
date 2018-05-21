#!/bin/bash

set -o errexit
set -o nounset

# File structure: Main folder
chroot_lib="./testing_chroot"

if [[ ! -d ${chroot_lib} ]]
then
	mkdir -p ${chroot_lib}/{bin,etc,lib,lib64} &&
	echo "PS1='JAIL $ '" | tee ${chroot_lib}/etc/bash.bashrc
fi

# binaries_array: List of binaries needed in our chroot folder
array_bins=(bash ls touch)

# copying the libraries into the chroot folder:
# get length of array with binaries, determining number of binaries:
lengthArray=${#array_bins[*]}

# for each binary:
for ((i=0; i<lengthArray; i++))
do
	binary=${array_bins[$i]}
	# copy binary into chroot folder:
	cp /bin/${binary} ${chroot_lib}/bin/ 

	# getting lib dependencies for binary and copy them into chroot folder:
	while read line
	do
		# getting if folder is /lib/ or /lib64/:
		libFolder=$(echo ${line} | cut -d '/' -f 2)
		# copy lib into correct folder:
		cp ${line} ${chroot_lib}/${libFolder}/
	done < <(ldd /bin/${binary} | tail -n +2 | awk '{print $(NF-1)}')
done
