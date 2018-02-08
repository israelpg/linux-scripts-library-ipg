#!/bin/bash

# Rationale: Create a network folder in the server, and allow remote connections from clients, that will mount that folder

# Source: www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-amount-on-ubuntu-16-04

# SERVER:

# 1/ Install nfs-kernel-server package:

sudo apt-get install nfs-kernel-server

# 2/ Create folder to be shared:

mkdir -p /nfs-folder

sudo chown nobody:nogroup /nfs-folder -R

# 3/ edit /etc/exports
#    add a line: /nfs-folder	IP-client(rw,sync,no_root_squash,no_subtree_check)
#    go to shell and type: sudo exportfs -a

# 4/ Initialize and start the systemd/systemctl service for the nfs-kernel-server

sudo systemctl enable nfs-kernel-server.service
sudo systemctl start nfs-kernel-server.service

# 5/ Adjust the Firewall, in order to allow the client connect to our machine/server:

sudo ufw allow from network/24 to any port nfs

sudo ufw status # it should list network allowed to port 2049, which maps with nfs connections to this port (/etc/services)

# CLIENT

# 1/

sudo apt-get install nfs-common

sudo systemctl enable nfs-client.target
sudo systemctl start nfs-client.target

mkdir -p /mnt/nfs/nfs-folder

sudo mount ip_server:/nfs-folder /mnt/nfs/nfs-folder

# checks:

df -h

## MOUNTING AT BOOT/CLIENT:

# edit /etc/fstab

ip_server:/nfs-folder	/mnt/nfs/nfs-folder	nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1080 0 0



