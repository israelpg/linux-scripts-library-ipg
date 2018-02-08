#!/bin/bash

# create a junk file full of zeros using dd:

dd if=/dev/zero of=loop_imagefile.img bs=200M count=1

# format file to make it ext4 extension using mkfs-ext4:

mkfs.ext4 loop_imagefile.img

# check file type:

file loop_imagefile.img # it must be ext4 in this case

# mkdir to use as mount point:

mkdir /mnt/loopback2

# mount loop file

mount -o loop loop_imagefile.img /mnt/loopback2

# checking:

df -h

cat /etc/mtab | grep 'loop'
