#!/bin/bash

#  encrypted remote login, which can be protected for specific users, IP range ... /etc/ssh/sshd_config
ssh
# examples

ssh user@host
ssh user@host "commands to execute in remote machine"
systemctl -H user@host enable <service.name> # this session will be via ssh as well

# encrypted tranmission of files
scp
# examples
scp user@host ~/tests/ # from remote machine to localhost
scp ~/test user@host:/destinationFolder/subfolder # from localhost to remote machine

# encrypted secure FTP connection
sftp

