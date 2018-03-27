#!/bin/bash

id <username>

uid=1000(ip14aai) gid=1000(ip14aai) groups=1000(ip14aai)


groups <groupname>

pepe : pepe grpquota


## complete user info: use one of these two methods: getent or finger ... finger is preferable:

[root@02DI20161235444 tests]# getent passwd <username>
pepe:x:1001:1001::/home/pepe:/bin/bash

# for a better formatting, use column for creating a table:

getent passwd pepe | column -t -s ':'


# or: finger <username>:

[root@02DI20161235444 tests]# finger pepe
Login: pepe           			Name:
Directory: /home/pepe               	Shell: /bin/bash
Last login Tue Mar 20 15:34 (CET) on pts/1
No mail.
No Plan.

## LISTING ALL USERS IN THE SYSTEM
# checking /etc/passwd file:

cat /etc/passwd | column -t -s ':'
# specific user
grep -i <username> /etc/passwd | column -t -s ':'

# using lslogins -u:
[root@02DI20161235444 tests]# lslogins -u
  UID USER      PROC PWD-LOCK PWD-DENY  LAST-LOGIN GECOS
    0 root       165        0        0 Feb07/14:53 root
 1000 ip14aai     52        0        0 Mar22/16:30 Israel PG
 1001 pepe         0        0        0 Mar05/10:54
 1002 natasa       0        0        0 Mar08/10:44
 1003 rcordoba     0        0        1
65534 nfsnobody    0        0        1             Anonymous NFS User


## ACTIVE LOGINS:

w
who


## ABOUT LOGINS:

last
lastlog




