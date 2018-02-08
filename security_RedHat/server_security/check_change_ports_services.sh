#!/bin/bash

# relation: services / ports:
cat /etc/services

# to check open ports in localhost by system services:

[root@localhost securingWorkstation]# nmap -sT -O localhost

Starting Nmap 6.40 ( http://nmap.org ) at 2018-01-17 15:42 CET
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00046s latency).
Other addresses for localhost (not scanned): 127.0.0.1
Not shown: 996 closed ports
PORT    STATE SERVICE
22/tcp  open  ssh
25/tcp  open  smtp
111/tcp open  rpcbind
631/tcp open  ipp
Device type: general purpose
Running: Linux 3.X
OS CPE: cpe:/o:linux:linux_kernel:3
OS details: Linux 3.7 - 3.9
Network Distance: 0 hops

# in a specific IP, remote machine:
[root@localhost securingWorkstation]# nmap -sT -O <ip-address>

Starting Nmap 6.40 ( http://nmap.org ) at 2018-01-17 15:42 CET
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00046s latency).
Other addresses for localhost (not scanned): 127.0.0.1
Not shown: 996 closed ports
PORT    STATE SERVICE
22/tcp  open  ssh
25/tcp  open  smtp
111/tcp open  rpcbind
631/tcp open  ipp
Device type: general purpose
Running: Linux 3.X
OS CPE: cpe:/o:linux:linux_kernel:3
OS details: Linux 3.7 - 3.9
Network Distance: 0 hops

# check for a specific port:

sudo nmap -p 22 localhost / ip_address

## checking established and listening ports in our machine / continue -c:
# TCP and UDP:
sudo netstat -tupac

# only listening TCP:
sudo netstat -netap

<LISTEN> only ...

# TCP and UDP:
sudo netstat -tupln
