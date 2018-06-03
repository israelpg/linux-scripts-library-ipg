#!/bin/bash

# as usual, using module pam.d, loading pam_access.so library in the section we require:

# login: to prevent a user to login in the system via /bin/ login, not in ssh: (NOT IN pam.d/LOGIN IS IN SYSTEM-AUTH!!!!!!!!!!!!!!!!!!!!!!!!!!!)
/etc/pam.d/system-auth
account	required	pam_access.so

# the configure /etc/security/access.conf
- : john : ALL

# now with sshd services:
/etc/pam.d/sshd
account	required	pam_access.so
# access to everyone from IP 10.57.121.55 except John:
/etc/security/access.conf
+ : ALL EXCEPT john : 10.57.121.55

## for ssh, there is the possibility of creating a file list containing allowed or denied users:
# check in the specific manual here in my lib: networkingServices/protecting_services_by_user_fileList.sh

# check for logging under:
tail -f /var/log/secure

# it is possible to call the pam_access library module for all services that call the system wide PAM configuration files in the /etc/pam.d directory:
echo 'authconfig --enablepamaccess --update' | tee -a /etc/pam.d/*-auth

# restricting access by time: pam_time.so , /etc/security/time.conf
/etc/pam.d/system-auth ; /etc/pam.d/sshd
account required pam_time.so
# example: restricting LOCAL login access from 17:30h to 08:00h except for root
/etc/security/time.conf
# this one is handy:
# bin login or ssh *
# allowing non-root users to just login within business hours:
* ; * ; !root ; Al0830-1700
# or just login system-auth:
login ; tty* ; ALL ; !root ; !Wk1730-0800
# or just sshd:
sshd ; tty* ; john ; Wk0800-1730 # john can only connect via sshd during working hours

### setting limits

# maxlogins:
/etc/pam.d/system-auth
session required	pam_limits.so
/etc/security/limits.conf
#<domain>      <type>  <item>         <value>
@office - maxlogins 4 # for user of group office, maxlogins=4 ... instead of @groupname can be username

