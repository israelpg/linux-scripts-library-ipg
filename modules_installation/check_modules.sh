#!/bin/bash

apt-cache search isc-dhcp-server

apt-cache show isc-dhcp-server

dpkg -l | grep 'isc-dhcp-server'

# if are kernel modules:

lsmod
