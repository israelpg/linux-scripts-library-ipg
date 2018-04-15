#!/bin/bash

# logrotate allows to manage logs for any program, some confs come by default:

# /etc/logrotate.d/

# for instance: apt

# 1/ Copy one of the configs, eg: apt, to generate a conf for a program which is not yet defined:

sudo cp /etc/logrotate.d/apt prueba

# 2/ Now edit the config file for your program.

sudo nano -c prueba

/var/log/prueba {
  rotate 3
  maxage 10
  compress
  compresscmd /bin/gzip
  uncompresscmd /bin/gunzip
  size 2k
  missingok
  notifempty
  copytruncate
}

# file is prueba inside folder /var/log. 
# rotate means max 3 copies, maxage 10 days, size max 2k, compression, if missing file is ok, generate it,
# do not rotate if empty, copy when creating new log file

# 3/ Create prueba file in the /var/log folder, and assign ownership and permissions:

sudo touch /var/log/prueba

sudo chown syslog:adm prueba

sudo chmod 664 prueba

# 4/ rotate can be scheduled daily, weekly, montly if no size defined, in the config file section 2. Manually:

sudo logrotate /etc/logrotate.conf

######### TIPS: Use a watch -n 1 'ls -lah /var/log | grep 'prueba'' --> to monitor changes in folder
# or using the inotifywait if you want:

# sudo inotifywait -m -r -e create,delete,modify,move /var/log -q
