#!/bin/bash

# simple connection to the remote machine:

ssh user@host

# executing a command in the remote machine:

ssh user@host "ls -lah /etc/system.d/system"

# remote systemctl:

systemctl -H user@host status <service_name>

### authentication:

# when connecting for first time, fingerprint is displayed ... check in your machine, if .pib key in the remote machine is yours:
ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub
# the fingerprint displayed should match, otherwise, is not your key, better run for your life

## copy : scp
# From your machine to remote:
scp /folder/thisfile.txt user@host:/here/

# From remote machine to your server:
scp user@host:/folder/thisfile.txt /myfolder/

# auto-login from a server to a remote host via ssh, no password will be requested by remote host

# We will use encrypted keys, private and public. 

# Server will generate the keys: using algorithm rsa

ssh-keygen -t rsa
# type the paraphrase

# keys are created under folder: ~/.ssh
# the public key will be transferred to all those machines that you want to connect from the server via ssh

ssh natasa@10.57.122.192 "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
# or:
ssh pepe@10.57.122.192 "mkdir ~/.ssh ; cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub

# best way to copy pub key is by using command: ssh-copy-id:
# -i identity file
ssh-copy-id -i user@host # it will copy the .pub key to the remote host ~/.ssh/authorized_key

# now when connecting from server to client, no password is required

ssh natasa@10.57.122.192

