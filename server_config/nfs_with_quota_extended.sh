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

sudo mkdir -p /nfs-quota

# 2/ Create an image file stored in server folder /usr/disk-img:

sudo dd if=/dev/zero of=/usr/disk-img/test-img.ext3 bs=1M count=100

# 3/ mkfs to ext3 extension:

sudo mkfs.ext3 /usr/disk-img/test-img.ext3

file /usr/disk-img/test-img.ext3

# 4/ Edit /etc/fstab ( to mount disk image recently created as a filesystem /proc/mounts df /etc/fstab ...

/usr/disk-img/test-img.ext3   /nfs-quota                  ext3    rw,loop,usrquota,grpquota       0       0

# 5/ Mount /nfs-folder-quota as a /dev/loop(n) device

sudo mount /nfs-quota

# checks:

df -h

cat /proc/mounts

# obviously in: /etc/fstab, as edited before, reflected with:
findmnt

# Ownership for main nfs folder (nfs-quota) is: nobody:nogroup (Debian), nobody:nobody (RedHat)

# 6/ Add grpquota in the system:
sudo groupadd grpquota

# 7/ Select users that are part of this group:
sudo usermod -a -G groupname username
# or:
sudo gpasswd -a username groupname

# 8/ Inside the mounted point nfs-folder-quota, create a folder which will contain the permissions for the group:
mkdir -p /nfs-quota/shared
#    /quota/shared:
$ sudo chown -R root:grpquota
#    /quota/shared:$ 
sudo chmod 2775 . ## this is for setgid (exec with group permissions, files with group ownership when created)
#    ## You can also add sticky bit, avoiding users to remove others files: 
sudo chmod a+t .

# 9/ Setting up quotas: Files for config and writing
# -c create -u user -g group, over main nfs-folder with nobody:nobody ownership, and mounted via /etc/fstab:
quotacheck -cug /nfs-quota
# activate verbose user group:
quotacheck -avug
# Two files are created: aquota.group aquota.user
# refreshing all quota files:
quotaoff -a
quotaon -a

# now the quotas can be setup

## Scenario: You can setup a quota for a group: edquota -g grpquota, and define there the limits, plus some individual edquota -u (per user)
## For instance, you can setup a limit for everyone except for pepe, who can even have less, or more..

# 10/ For each user, defining its quota individually:
edquota -u /nfs-quota username

#Disk quotas for user natasa (uid 1002): (Use either blocks or inodes)
# blocks are calculated as: 1024=1M ... inodes means number of files !!! IMPORTANT ABOUT BLOCKS AND NODES
# soft: warning message as from specified number
# hard: maximum number
Filesystem                   blocks       soft       hard     inodes     soft     hard
/dev/loop1                        0      102400    112640          0        0        0

# ## or in command line: setquota -u username 100 200 10 15 -a /dev/loop<corresponding number>

# 11/ Turn on quotas defined:
quotaoff /nfs-quota
quotaon /nfs-quota

# In case needed to turn off to make new changes: sudo quotaoff -avug

# 12/ Quota for groups:
edquota -g quotagrp ## or: ## setquota -g quotagrp 5 100 6 10 -a /dev/loop0

## PRINTING REPORTS ##

[root@02DI20161235444 shared]# quota pepe
Disk quotas for user pepe (uid 1001):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
     /dev/loop0   10078   51200   56320               1       0       0

# repquota /nfs-quota (for all users in grpquota)
[root@02DI20161235444 server_config]# repquota -u /nfs-quota/
*** Report for user quotas on device /dev/loop0
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --   78287       0       0              4     0     0
nobody    --       1       0       0              1     0     0
pepe      --   10078   51200   56320              1     0     0

# report by group: repquota -g /nfs-quota
[root@02DI20161235444 shared]# repquota -g /nfs-quota/
*** Report for group quotas on device /dev/loop0
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
Group           used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --      12       0       0              1     0     0
nobody    --       1       0       0              1     0     0
grpquota  --   78275       0       0              3     0     0


## SHARING : nfs-server folder
# client needs to run nfs-common)
# server edit its exports folder:
/etc/exports
/nfs-folder	IP-client(rw,sync,no_root_squash,no_subtree_check)
# or instead of IP, a network: 10.136.137.0/24
exportfs -a

# summary:
exportfs -s
# or:
[root@02DI20161235444 ip14aai]# showmount -e
Export list for 02DI20161235444:
/nfs-quota 10.136.137.120

# client, mounting at boot client
/etc/fstab
ip_server:/nfs-folder	/mnt/nfs/nfs-folder	nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1080 0 0

# manual mount:
mount -t nfs IP_server:/nfs-folder /mnt/shared-folder

## in case of timeout ... allow ports in the firewall:
rpcinfo -p
...

[root@02DI20161235444 server_config]# firewall-cmd --permanent --add-port=111/tcp
success
[root@02DI20161235444 server_config]# firewall-cmd --permanent --add-port=34558/tcp
success
[root@02DI20161235444 server_config]# firewall-cmd --permanent --add-port=20048/tcp
success
[root@02DI20161235444 server_config]# firewall-cmd --permanent --add-port=2049/tcp
success
[root@02DI20161235444 server_config]# firewall-cmd --permanent --add-port=34915/tcp
success
[root@02DI20161235444 server_config]# firewall-cmd --reload
success

iptables --list

Chain IN_public_allow (1 references)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ssh ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:34558 ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:mountd ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:nfs ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:34915 ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:sunrpc ctstate NEW


# To use key-based authentication with NFS-mounted home directories, enable the use_nfs_home_dirs SELinux boolean first:

setsebool -P use_nfs_home_dirs 1
