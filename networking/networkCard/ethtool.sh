#!/bin/bash

sudo apt-get install ethtool

sudo ethtool enp0s3
# displays hardware capabilities, and more important, transfer speed

# if we want to force network interface to use certain speed: /etc/network/interfaces :

auto enp0s3
iface enp0s3 inet static
pre-up /sbin/ethtool -s enp0s3 speed 1000 duplex full


