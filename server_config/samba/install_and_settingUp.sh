#!/bin/bash

# Server Linux:

# packages and dependencies to install:

sudo apt-get install samba
sudo apt-get install samba-client
sudo apt-get install samba-common
sudo apt-get install cifs-utils

# Allow application in our Firewall (ufw)

sudo ufw app list # probably rule is not initially added, therefore add rule:
sudo ufw allow samba
sudo ufw status

# Two daemons: (systemctl: /usr/sbin/smbd /usr/sbin/nmbd)

# Config file: /etc/samba/smb.conf (create a copy/bkp)

sudo nano -c /etc/samba/smb.conf

# Adding a resource to be shared, for instance a folder:

[Server_Downloads_Folder]
path=/home/ip14aai/Downloads
guest ok = yes
writable = yes
printable = no
write list = @staff # only group staff can write in
#force user = palisra # (to act as this user, even with a different user logon)
#force group = ip14aai

# restart service:

sudo systemctl restart smbd.service
sudo systemctl status smbd.service

# CLIENTS:

# Another Linux (client)
sudo apt-get install samba-client
sudo apt-get install samba-common
sudo apt-get install cifs-utils

# list resources shared in the server:

smbclient -L 10.57.121.196 # that is the IP of the server

# connecting to that resource:

smbclient \\\\10.57.121.196\\Server_Downloads_Folder <literal password in local client>

# the rest, is just like ftp commands, use this manual: www.tldp.org/HOWTO/SMB-HOWTO-8.html

# better if you mount the folder permanently, by installing smbfs package, and typing:

smbmount "\\\\server-name\\resource-name" -U rtg2t -c 'mount /resource-name -u 500 -g 100'

# a graphical option: installing smb4k

# Using encrypted passwords for accessing the info:

sudo nano -c /etc/samba/smb.conf

encrypt passwords = yes
smb passwd file = /etc/smbpasswd
