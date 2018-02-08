#!/bin/bash

# By default is enabled, that's why the /etc/network/interfaces contains # in the manual settings

sudo systemctl status NetworkManager.service

# To stop using it, stop and disable:

sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service

# Then edit /etc/network/interfaces, in order to define dynamic or static configuration (IP)
# Nevertheless, make sure first that file: /etc/NetworkManager/NetworkManager.conf contains:
# [ifupdown]
# managed=false

# Reboot system and network should be manually defined and applicable
