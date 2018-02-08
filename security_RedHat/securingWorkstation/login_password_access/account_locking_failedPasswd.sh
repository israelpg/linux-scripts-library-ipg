#!/bin/bash

/etc/pam.d/system-auth
/etc/pam.d/password-auth

# example: locking after 3 failing attempts, and waiting 10 minutes (600 seconds) to unlock it again:

auth	required	pam_faillock.so preauth silent audit deny=3 unlock_time=600
auth	sufficient	pam_unix.so nullok	try_first_pass
auth	[default=die]	pam_faillock.so authfail audit deny=3 unlock_time=600

account	required	pam_faillock.so

# if we plan to avoid system to lock user even after failing to enter correct password, enter in both files /etc/pam.d/system-auth password-auth:

auth	[success=1 default=ignore] pam_succeed_if.so user in user1:user2:user3

# to view number of failed attempts:
faillock

# to unlock a user's account, run as root:

sudo faillock --user <username> --reset


