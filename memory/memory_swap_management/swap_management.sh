#!/bin/bash

# There are different levels of swappiness, meaning the system writing in swap to relief RAM.
#
# vm.swappiness = 0 - swap is only activated by the system in case of urgency
# vm.swappiness = 10 - recommended to improve performance, writing in RAM until 90% of capacity
# vm.swappiness = 60 - default value, RAM is written until 40%
# vm.swappiness = 100 - always swapping, writing in disk, instead of RAM
#
# To check level of swappiness:

cat /proc/sys/vm/swappiness

sysctl vm.swappiness

# Temporary change of swappiness value:

echo 10 > /proc/sys/vm/swappiness

# or:

sysctl -w vm.swappiness=10

# permanent change:
# edit /etc/sysctl.conf , and add line:

vm.swappiness=10

# apply changes:

sysctl -p
swapoff -a && swapon -a

# check status

sudo swapon -s
