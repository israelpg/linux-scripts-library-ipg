#!/bin/bash

# install vnstat - network bandwith monitor tool

sudo apt-get install vnstat

# configure /etc/vnstat.conf:
# Interface: <iface name>
# DatabaseDir "<path to dbs>"
# plus other options to configure, like RateUnit bytes or Mb

# create db for each iface
# 1) find out the path shell for vnstat user:

cat /etc/passwd | grep 'vnstat'

# 2) change path shell:

sudo chsh -s /bin/bash vnstat

# 3) now vnstat user can execute runuser command to create the db in name of vnstat

runuser -l vnstat -g vnstat -c '/usr/bin/vnstat -u -i enp0s3'

# 4) Now refuse a login for vnstat user:

sudo chsh -s /sbin/nologin vnstat
# sbin requires root privileges, moreover nologin does not exist, goes nowhere as its own shell
# on the other hand, /usr/bin/vnstat exists so that executes command vnstat 

# Checking status / starting / stopping via service

suso service vnstat status # same using start or stop

# using vnstat

vnstat -i enp0s3

vnstat -i enp0s3 d | less # daily h hourly m monthly w weekly

vnstat -i enp0s3 -l # live, non-stop, like tail -f

vnstat -i enp0s3 -tr # calculating sampling in 5 seconds ...

