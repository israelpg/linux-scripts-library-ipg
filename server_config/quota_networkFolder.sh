#!/bin/bash

# Scenario: Server works as Fileserver, therefore, space quotas must be setup for user(s) or group(s)

# 1/ First create a folder in the server, this will be the mounted folder:

mkdir -p /quota

# 2/ Create a disk image with ext3, to be mounted in the server:

mkdir -p /usr/disk-img
dd if=/dev/zero of=/usr/disk-img/disk-quota.ext3 bs=1MB count=40
mkfs.ext3 /usr/disk-img/disk-quota.ext3
file /usr/disk-img/disk-quota.ext3

# 3/ Add config line into /etc/fstab for defining attributes before mounting the folder:

/usr/disk-img/disk-quota.ext3	/quota	ext3	rw,loop,usrquota,grpquota	0	0

# 4/ Mount the image ext3 into the folder quota:

sudo mount /quota

# 5/ Checkings: inside /quota folder, lost+found has been created
#    Check /proc/mounts --> grep 'quota' /proc/mounts
#    df -h
#    cat /etc/fstab

# 6/ Add quotagrp in the system: sudo groupadd quotagrp

# 7/ Select users that are part of this group: sudo usermod -a -G groupname username

# 8/ Inside the mounted point quota, create a folder which will contain the permissions for the group:
#    mkdir -p /quota/shared
#    /quota/shared:$ sudo chown -R root:quotagrp
#    /quota/shared:$ sudo chmod 2775 . ## this is for setgid (exec with group permissions, files with group ownership when created)
#    ## You can also add sticky bit, avoiding users to remove others files: sudo chmod a+t .

# 9/ Setting up quotas: Files for config and writing
#    quotacheck -cug /quota
#    ## Two files are created: aquota.group aquota.user

# 10/ For each user, defining its quota:
#     edquota -f /quota username
#Disk quotas for user natasa (uid 1002):
#Filesystem                   blocks       soft       hard     inodes     soft     hard
#/dev/loop1                        0      10000      10000          2        0        0

#     ## or in command line: setquota -u username 100 200 10 15 -a /dev/loop<corresponding number>

# 11/ Turn on quotas defined: 
#     quotaon /quota

# 12/ Quota for groups: edquota -g quotagrp ## or: ## setquota -g quotagrp 5 100 6 10 -a /dev/loop0

## PRINTING REPORTS ##

# with the user logged in: type:
# quota

# In the server itself, also this option:
# repquota /quota (for all users)

# report by group: repquota -g /quota
