#!/bin/bash

# Best practice, passwords must be shadow, meaning that hashed are not stored under:
/etc/passwd
# but intead in:
/etc/shadow

# otherwise, this may compromise security, since an attacker may copy the /etc/passwd file, and try to crack the passwords in his own local machine

# Defining password generation when creating a user in the system with useradd:
/etc/login.defs
# like MIN_LENGTH, expiration, etc ...

## more about password setting definition under PAM module: /etc/pam.d
# edit:
/etc/pam.d/password
# add following library line:
password	required	pam_cracklib.so retry=3 minlen=8 minclass=4 # minclass=4 means you must specify password with the 4 types of chars
# for a limited use of consecutive char type, say 3 (eg: abc): maxsequence=3

## an account can be locked after several days of inactivity ... this is different than expiration date+inactive for a password (defined via chage or usermod)
# so that we can configure an account to be inactive when it has not been used say for a month:
auth    required     pam_lastlog.so inactive=10

## PASSWORD CRACKERS:
# John The Ripper (www.openwall.com/john/
# Crack
# Slurpie (in multiple computers in parallel)

# DEFINING PASSWORD FOR A USER:
sudo passwd username

###### APPLYING PASSWORD CHANGES MANUALLY

## CHAGE (change password settings to an existing user):
# to change the settings for an already defined password, use chage:
# checking current password settings for a user:
sudo chage -l <username>

# setting max expiration day:
sudo chage -M 90 <username>
# setting number of inactive days after the password expiration before locking the account:
sudo chage -I 5 <username>
# setting expiration date
sudo chage -E 2018-12-31 <username>
# is set to 0, account is not locked after expiration date:
sudo chage -I 0 <username>
# forcing immediate expiration date to happen:
sudo chage -d 0 username

# changes can also be done via usermod command:
# locking account:
sudo usermod -L <username> # adds a ! in front of hashed password
# unlock
sudo usermod -U <username>
# other options:
-e # expiration date
-f # inactive






