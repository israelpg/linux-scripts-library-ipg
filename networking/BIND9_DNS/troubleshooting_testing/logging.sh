#!/bin/bash

# Logs are specified in named.conf.local

# logs in /var/log/query.log, therefore assign permissions:

sudo touch /var/log/query.log
sudo chown bind /var/log/query.log

# attention with AppArmor protecting the log files, even assigning perms!

# edit /etc/apparmor.d/usr.sbin.named, and add:

var/log/query.log rw,
