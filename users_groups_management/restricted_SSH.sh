#!/bin/bash

# /etc/ssh/sshd_config

AllowGroups sshlogin

# you need to create group sshlogin in the system, and add the users allowed to connect via ssh from remote host

# server config:

sudo nano -c /etc/ssh/sshd_config

# add line from above. You can also use other options: AllowUsers, DenyGroups, DenyUsers

# restart ssh.service:

sudo systemctl restart ssh.service

# You can also limit root access via ssh :

PermitRootLogin no
