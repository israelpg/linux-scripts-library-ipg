#!/bin/bash

sudo apt-get install putty-tools

# convert windows ppk file to pem file used by Debian:
# -O for Output in key type: private-openssh: -o for output to .pem file:
sudo puttygen windowsprivatekey.ppk -O private-openssh -o privateKey.pem

sudo chmod 400 privateKey.pem

ssh -i privateKey.pem user@hostname
