#!/bin/bash

## By default NetworkManager.service is enabled and started
## This is the primary networking configuration to be taken into account
## Secondary are the init scripts under /etc/init.d/network

# In Red Hat Enterprise Linux 7, NetworkManager is started first, and /etc/init.d/network checks with NetworkManager to avoid tampering with 
# NetworkManager's connections. NetworkManager is intended to be the primary application using sysconfig configuration files, and /etc/init.d/network is intended to be secondary.

# NetworkManager :

systemctl <status|start|stop|enable|disable ...> NetworkManager.service

# init.d/network :

systemctl <status|start|stop|enable|disable ...> network.service

## To execute some of the init.d/network scripts, just use the appropriate command, like for ifup / ifdown :
/usr/sbin
ifup

# Red Hat:

[root@s999lq2iib02 ~]# cat /etc/init.d/network | grep ifup
	action $"Bringing up loopback interface: " ./ifup ifcfg-lo
	action $"Bringing up interface $i: " ./ifup $i boot
    action $"Bringing up interface $i: " ./ifup $i boot

# the network scripts are stored under:

/etc/sysconfig/network-scripts

# Debian:

grep 'ifup' /etc/init.d/networking 
# Provides:          networking ifupdown
[ -x /sbin/ifup ] || exit 0
ifup_hotplug () {
		ifup $ifaces "$@" || true
	if ifup -a $exclusions $verbose && ifup_hotplug $exclusions $verbose
	if ifup --exclude=lo $state $verbose ; then
	if ifup -a --exclude=lo $exclusions $verbose && ifup_hotplug $exclusions $verbose


