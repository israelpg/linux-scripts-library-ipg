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
# example: Connecting from RH to Debian, then in the ssh session, I can query the file authorized_keys, where I see my RH username@host
[ip14aai@02DI20161235444 security_RedHat]$ ssh ip14aai@10.136.137.110
Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-121-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

386 packages can be updated.
40 updates are security updates.

Last login: Tue May  8 13:41:27 2018 from 10.136.137.109
ip14aai@02DI20161542844:~$ ssh-keygen -l -f .ssh/authorized_keys 
2048 SHA256:L5qBEDmznIw5kMbXqHZnQuFaiazkTbh2S73RPSsvdqk root@02DI20161235444 (RSA)
2048 SHA256:XSZCEkidqtLZ7jW+Yb7u78zCXj+0u9S5MYDmepjrXGE ip14aai@02DI20161235444 (RSA) # This is my RH session authorized in Debian

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

# Using a port other than default 22: Hiding ssh default port
# Note: /etc/services is just a reference file, not an effective one
# Change port number in the conf file: (eg: from 22 to 2222)
vim /etc/ssh/sshd_config
Port 2222
# SElinux must enable this port to be changed:
semanage port -a -t ssh_port_t -p tcp 2222
# Now update firewalld to accept port
firewall-cmd --zone=public --add-port=2222/tcp --permanent
firewall-cmd --reload
# check config with:
firewall-cmd --zone=public --list-all
# check that this port is now opened:
[root@02DI20161235444 ip14aai]# nmap -p 2222 localhost

Starting Nmap 6.40 ( http://nmap.org ) at 2018-05-16 10:38 CEST
Nmap scan report for localhost (127.0.0.1)
Host is up (-1700s latency).
Other addresses for localhost (not scanned): 127.0.0.1
PORT     STATE SERVICE
2222/tcp open  EtherNet/IP-1

Nmap done: 1 IP address (1 host up) scanned in 0.06 seconds 
# or netstat -tuplna
[root@02DI20161235444 ip14aai]# netstat -tuplna | grep 2222
tcp        0      0 0.0.0.0:2222            0.0.0.0:*               LISTEN      1152/sshd           
tcp6       0      0 :::2222                 :::*                    LISTEN      1152/sshd

# now from client, to connect via ssh to remote server, we must specify port 2222 instead of default 22:
ssh user@host -p 2222

# Do not allow root login via ssh:
vim /etc/ssh/sshd_config
PermitRootLogin no

# other options: tcp wrappers (/etc/hosts.deny), xinetd 
