#!/bin/bash

/etc/pam.d/system-auth
/etc/pam.d/password-auth

# explaining arguments:
# preauth: pam.d module called before the authentication takes place in the system itself (optional if authsucc is used)
# authfail: called after the modules which determine auth outcome, failed. If blocked, nothing, otherwise: add faillock lines 
# authsucc: called after the modules which determine auth outcome, succeded. Then clears faillock lines

# levels: auth - account -- password "Normally use auth and account, or just auth"

# EXAMPLES: "Note that non pam_faillock.so lines are already added, keep the order!!!"
# example: locking after 3 failing attempts, and waiting 10 minutes (600 seconds) to unlock it again:
auth    required	pam_env.so
auth	required	pam_faillock.so preauth silent audit deny=3 unlock_time=600 # silent to don't leak messages
auth	sufficient	pam_unix.so nullock try_first_pass
auth	[default=die]	pam_faillock.so authfail audit deny=3 unlock_time=600
auth	requisite	pam_succeed_if.so uid >= 1000 quiet_success
auth	required	pam_deny.so
# extra argument in case you want to lock root account: even_deny_root
auth    [default=die]   pam_faillock.so authfail audit deny=3 unlock_time=600

account required	pam_faillock.so

# if we plan to avoid system to lock specific user(s) even after failing to enter correct password, enter in both files /etc/pam.d/system-auth password-auth
# above the line where pam_faillock.so is called for first time:
auth	[success=1 default=ignore] pam_succeed_if.so user in user1:user2:user3

# to view number of failed attempts:
# as root to check all usernames:
faillock

# with sudo for a specific username:
sudo faillock --user <username>

# to unlock a user's account, run as root:
sudo faillock --user <username> --reset

### EXAMPLE - REAL SCENARIO:
# check files attached: system-auth, and password-auth

# testing it:

[ip14aai@02DI20161235444 ~]$ su -l rcordoba
Password: 
su: Permission denied
[ip14aai@02DI20161235444 ~]$ su -l rcordoba
Password: 
su: Permission denied
[ip14aai@02DI20161235444 ~]$ su -l rcordoba
Password: 
su: Permission denied
[ip14aai@02DI20161235444 ~]$ su -l rcordoba
Password: 
su: Authentication failure

# recorded in /var/log/secure

# first three times it just mentions Permission denied, not even mentioning if username is correct
# as from that point, authentication failure

root@rhel7$ faillock

rcordoba:
When                Type  Source                                           Valid
2018-06-05 12:02:31 TTY   pts/1                                                V
2018-06-05 12:02:39 TTY   pts/1                                                V
2018-06-05 12:02:46 TTY   pts/1                                                V


###########################################################################################

## ALTERNATIVE in terms of failed password but not blocking account:

## more about password setting definition under PAM module: /etc/pam.d (working in conjunction with /etc/login.defs if needed)
# edit:
/etc/pam.d/passwd

# example: max 3 attempts for entering correct password (otherwise skip but do not block account), plus defining minlen or minclass
# add following library line:
password        required        pam_cracklib.so retry=3 minlen=8 minclass=4 # minclass=4 means you must specify password with the 4 types of chars

# for a limited use of consecutive char type, say 3 (eg: abc): maxsequence=3
# in case you want the account to be locked, then check libraries to be loaded with faillock capabilities under pam.d module (system-auth, password-auth) - info above

## an account can be locked after several days of inactivity ... this is different than expiration date+inactive for a password (defined via chage or usermod)
# so that we can configure an account to be inactive when it has not been used say for 10 days:
/etc/pam.d/login
auth    required     pam_lastlog.so inactive=10

# Manual edit for a specific user with: chage, or passwd

