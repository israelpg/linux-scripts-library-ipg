#!/bin/bash

# associated service: sshd.service
# systemctl to manage the daemon

# CONFIGURE SSH TO USE KEY-BASED AUTHENTICATION instead of password:
# by default, configuration in /etc/ssh/sshd_config specifies Password Authentication, instead of key-based:

PasswordAuthentication no

# Therefore, we must generate keys in one machine and add the .pub key in the /authorized_keys of the remote machine:

# 1/ Generate the keys (.id, .pub): (By default are generated in ~/.ssh/ ... type a passphrase)

ssh-keygen -t rsa

# another option is ssh-keygen -t ecdsa

# 2/ Copy the .pub key to the remote machine in folder ~/.ssh/authorized_keys :

ssh-copy-id user@hostname

# you can specify the .pub file in case there are several versions:

ssh-copy-id -i ~/.ssh/this_key.pub user@hostname

# saving passphrase for a shell prompt session:

sudo ssh-add


