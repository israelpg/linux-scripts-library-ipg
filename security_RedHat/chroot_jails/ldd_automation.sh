#!/bin/bash

set -o errexit
set -o nounset

# folders

chroot_lib64="/testing_chroot/bin/lib64/"

# copying the libraries into the chroot folder:

while read line
do
		cp $line $chroot_lib64
done < <(ldd /usr/bin/ls | cut -d ' ' -s -f3)
