#!/bin/bash

# We create one disk image, mounted as nfs, then a subfolder called shared is the one which contains info from clients/users, looks:
#ip14aai@02DI20161542844:/nfs-quota/shared$ ls -lah
#total 9,8M
#drwxrwsrwt 2 root    quotagrp 1,0K sept.  8 11:16 .
#drwxrwsrwt 4 nobody  nogroup  1,0K sept.  6 12:04 ..
#-rw-r--r-- 1 natasa  quotagrp    0 sept.  8 10:52 client1.txt
#-rw-r--r-- 1 natasa  quotagrp  10K sept.  8 11:16 junkC2.txt
#-rw-r--r-- 1 natasa  quotagrp 9,8M sept.  8 11:17 junkC32.txt
#-rw-r--r-- 1 natasa  quotagrp  10K sept.  8 11:16 junkC.txt
#-rw-rw-r-- 1 ip14aai quotagrp    0 sept.  6 11:43 pepito
#-rw-rw-r-- 1 ip14aai quotagrp    0 sept.  6 12:09 s3.txt
#-rw-rw-r-- 1 ip14aai quotagrp    0 sept.  6 12:04 ser2.txt


## SERVER

# 1/ Create a folder that will be shared

sudo mkdir -p /nfs-folder-quota

# 2/ Create an image file stored in server folder /usr/disk-img:

sudo dd if=/dev/zero of=/usr/disk-img/shared-disk.ext3 bs=1M count=100

# 3/ mkfs to ext3 extension:

sudo mkfs.ext3 /usr/disk-img/test-img.ext3

file /usr/disk-img/test-img.ext3

# 4/ Edit /etc/fstab ( to mount disk image recently created as a filesystem /proc/mounts df /etc/fstab ...

/usr/disk-img/test-img.ext3   /nfs-quota                  ext3    rw,loop,usrquota,grpquota       0       0

# 5/ Mount /nfs-folder-quota

sudo mount /nfs-quota

# checks:

df -h

cat /proc/mounts

# obviously in: /etc/fstab, as edited before

# Ownership for main nfs folder (nfs-quota) is: nobody:nogroup

# 6/ Add quotagrp in the system: sudo groupadd quotagrp

# 7/ Select users that are part of this group: sudo usermod -a -G groupname username

# 8/ Inside the mounted point nfs-folder-quota, create a folder which will contain the permissions for the group:
#    mkdir -p /nfs-quota/shared
#    /quota/shared:$ sudo chown -R root:quotagrp
#    /quota/shared:$ sudo chmod 2775 . ## this is for setgid (exec with group permissions, files with group ownership when created)
#    ## You can also add sticky bit, avoiding users to remove others files: sudo chmod a+t .

# 9/ Setting up quotas: Files for config and writing
#    quotacheck -cug /nfs-quota
#    quotacheck -avug
#    ## Two files are created: aquota.group aquota.user

# 10/ For each user, defining its quota:
#     edquota -f /nfs-quota username
#Disk quotas for user natasa (uid 1002):
#Filesystem                   blocks       soft       hard     inodes     soft     hard
#/dev/loop1                    10000      10000      10000          5        0        0

# ## or in command line: setquota -u username 100 200 10 15 -a /dev/loop<corresponding number>

# 11/ Turn on quotas defined:
#     quotaon /nfs-quota

# In case needed to turn off to make new changes: sudo quotaoff -avug

# 12/ Quota for groups: edquota -g quotagrp ## or: ## setquota -g quotagrp 5 100 6 10 -a /dev/loop0

## PRINTING REPORTS ##

# with the user logged in: type:
# quota

# In the server itself, also this option:
# repquota /nfs-quota (for all users)

# report by group: repquota -g /nfs-quota


