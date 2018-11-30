#!/bin/bash

# simple connection to the remote machine:

ssh user@host

# executing a command in the remote machine:

ssh user@host ls -lah /etc/system.d/system

### authentication:

# when connecting for first time, fingerprint is displayed ... check in your machine, if .pib key in the remote machine is yours:

ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub
# the fingerprint displayed should match, otherwise, is not your key, better run for your life


