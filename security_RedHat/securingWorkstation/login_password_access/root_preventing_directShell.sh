#!/bin/bash

# Note with previous knowledge: You can prevent access via pam.d/login with the pam_access.so library, exclusive to root, IP, etc ... read: access_sec_config.sh

# what you can do in terms of ROOT session restriction is to prevent direct root login: instead you must use a visudo user which uses sudo <command>
/etc/passwd
# change bash for root user:
root:x:0:0:root:/root:/sbin/nologin
# via command:
sudo chsh -s /sbin/nologin root
# or:
sudo usermod -s /sbin/nologin root

## another way to prevent a root login
# remove tty login:
/etc/securetty
# leave it empty ... or just leave out the tty<number> you want to disable the login session
# nevertheless, a user can login with root via OpenSSH tools ... so, no 100% guarantee, to disable root SSH login see below:
/etc/ssh/sshd_config
PermitRootLogin no





