#!/bin/bash

# Better use iptables!!!!!

sudo ufw enable
sudo ufw disable

sudo ufw status

sudo ufw app list

# show result of an implementation before executing it:
sudo ufw --dry-run allow http

# from the app list you can allow or deny:

sudo ufw allow Squid
sudo ufw deny Postfix

# and delete:

sudo ufw delete allow Squid

# allow connections to Samba for a specific IP range/network
sudo ufw allow from 192.168.0.0/24 to any app Samba


# basic rules - PORTS:

sudo ufw allow 22

sudo ufw deny 55

# delete:

sudo ufw delete deny 55

# allow from a network to any IP address on this host:

sudo ufw allow proto tcp from 192.168.0.0/24 to any port 22


