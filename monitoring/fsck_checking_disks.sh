#!/bin/bash

df -h

cat /etc/fstab

fsck /dev/sdb2

# we can also check one specific file type, even not mounted:

fsck.ext4 loop_imagefile.img # ext4, same for ext3 and so on ...

####### SUMMARY FILESYSTEMS:

dd if=/dev/zero of=loopfile.img bs=200M count=1

mkfs.ext4 loopfile.img

file loopfile.img

# you can mount:

mkdir /mnt/loopback2

mount -o loop loopfile.img /mnt/loopback2

# check filesystem:

sudo fsck.ext4 /mnt/loopback2
