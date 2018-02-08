#!/bin/bash

# To list modules and their status in the kernel:

lsmod

# For a specific module, use grep:

lsmod | grep 'ppdev'

# How to load a module in the kernel:
# example: module 8021q, related to vlan (see section networking/vlan.sh)

sudo modprobe 8021q # after installing vlan package via apt

# make it permanent on kernel boot:

sudo su -c 'echo "8021q" >> /etc/modules'
