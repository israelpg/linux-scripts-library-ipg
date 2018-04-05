#!/bin/bash

date "+%D"

date "+%d %b %y"

# a good one for log files:
date +%x
2018-03-31

# check time it takes to execute a command or script
time systemctl status mysql.service
