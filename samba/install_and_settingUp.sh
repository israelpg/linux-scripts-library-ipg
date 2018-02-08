#!/bin/bash

# Server Linux:

# packages and dependencies to install:
# DEBIAN:
sudo apt-get install samba
sudo apt-get install samba-client
sudo apt-get install samba-common
sudo apt-get install cifs-utils
# REDHAT:
samba.x86_64                              4.6.2-11.el7_4                 updates
samba-client.x86_64                       4.6.2-11.el7_4                 updates
samba-common.noarch                       4.6.2-11.el7_4                 updates
samba-common-libs.x86_64                  4.6.2-11.el7_4                 updates
samba-common-tools.x86_64                 4.6.2-11.el7_4                 updates
cifs-utils.x86_64                         6.2-10.el7                     base   

# FIREWALL CONFIGURATION:
# DEBIAN: Allow application in our Firewall (ufw):
sudo ufw app list # probably rule is not initially added, therefore add rule:
sudo ufw allow samba
sudo ufw status

# REDHAT / via iptables:

sudo iptables -A INPUT -p udp --dport 137 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 138 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 139 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 445 -j ACCEPT
# in case we need to block Samba for one host in concrete:
sudo iptables -A INPUT -d server_IP -p tcp --dport 137 -j DROP

# Two daemons: (systemctl: /usr/sbin/smbd /usr/sbin/nmbd)

# service name: DEBIAN: smbd.service, REDHAT: smb.service

systemctl start smb.service

# Config file: /etc/samba/smb.conf (create a copy/bkp)

sudo nano -c /etc/samba/smb.conf

# adding the Samba server itself to a Windows Workgroup:

workgroup = <workgroupname>

# Adding a resource to be shared, for instance a folder:

[Server_Downloads_Folder]
comment = this is a shared resource via Samba
path= /home/ip14aai/Downloads
guest ok = yes
writable = yes
printable = no
write list = @staff # only group staff can write in
#valid users = pepe pedro # in case you manually specify the only users who can access the resource
#force user = palisra # (to act as this user, even with a different user logon)
#force group = ip14aai

# restart service:

sudo systemctl restart smb.service
sudo systemctl status smb.service

# creating a user and a password to use this resource (NOTE: It must exist in the server / added):
# smbpasswd file
smbpasswd -a username

# other authentication options are using a SAM Database via pdbedit tool:
sudo pdbedit -a username
sudo pdbedit -L

# defining ACLs in Samba Server Resource Shared Folder:
smbcacls //servername/resourcesharedname filename <options>

# CLIENTS:

# Another Linux (client)
sudo apt-get install samba-client
sudo apt-get install samba-common
sudo apt-get install cifs-utils

# the client can list resources shared in the server:
smbclient -L 10.57.121.196 # that is the IP of the server

# with net utility, other info can be obtained:
# shared resources:
net -l share -S hostname
# users:
net -l user -S username


# connecting to that resource:

smbclient \\\\10.57.121.196\\Server_Downloads_Folder <literal password in local client>

## or RedHat easier way:

smbclient //servername/resource_name -Uusername

smbclient //10.57.121.196/SalesDeptFolder -Upepe

# once connected, is like an ftp session / commands:
# the rest, is just like ftp commands, use this manual: www.tldp.org/HOWTO/SMB-HOWTO-8.html
ls
cd
rmdir
mkdir
put
get
help
exit

# Mounting the shared resource / folder:

mount -t cifs //servername/sharename /mnt/point/ -o username=username,password=password

# better if you mount the folder permanently, by installing smbfs package, and typing:

smbmount "\\\\server-name\\resource-name" -U rtg2t -c 'mount /resource-name -u 500 -g 100'

# a graphical option: installing smb4k

# Using encrypted passwords for accessing the info:

sudo nano -c /etc/samba/smb.conf

encrypt passwords = yes
smb passwd file = /etc/smbpasswd

### SECURITY

# By default Security Level is User-Level Security)
/etc/samba/smb.conf
[GLOBAL]
security = user # no need to specify it, is default value

# In case we need to authenticate user/password with a Domain Controller, then:

/etc/samba/smb.conf

[GLOBAL]
...
security = domain
workgroup = <workgroupname>
...

# If there is an Active Directory, then:

[GLOBAL]
...
security = ADS
realm = EXAMPLE.COM
password server = kerberos.example.com



