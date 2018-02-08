#!/bin/bash

# sudo aulast: root audit
sudo aulast

# this command provides info about current and revious login sessions:
last

# this one provides info about last log session per user:
lastlog
# reading from /var/log/lastlog
# to add more details, like number of failed attempts, add the following .so library from PAM module to:
# /etc/pam.d/login
session    optional     pam_lastlog.so silent noupdate showfailed

## an account can be locked after several days of inactivity ... this is different than expiration date+inactive for a password (defined via chage or usermod)
# so that we can configure an account to be inactive when it has not been used say for a month:
auth    required     pam_lastlog.so inactive=10

# similar by locking account in GNOME via gdm file under pam module config:
# /etc/pam.d/gdm
session    optional     pam_lastlog.so silent noupdate showfailed

