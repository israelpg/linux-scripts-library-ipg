#!/bin/bash

# auto-login from a server to a remote host via ssh, no password will be requested by remote host

# We will use encrypted keys, private and public. 

# Server will generate the keys: using algorithm rsa

ssh-keygen -t rsa
# type the paraphrase

# keys are created under folder: ~/.ssh
# the public key will be transferred to all those machines that you want to connect from the server via ssh

ssh natasa@10.57.122.192 "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub

# or better:

ssh pepe@10.57.122.192 "mkdir ~/.ssh ; cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub

# now when connecting from server to client, no password is required

ssh natasa@10.57.122.192

