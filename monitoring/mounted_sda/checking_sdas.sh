#!/bin/bash

df -h # lists all mounted devices, plus disk space information

# to check more info on a sda, you can type:

cat /etc/mtab | grep 'sda1' # change sda* for any other number, or even sdb* and so on


