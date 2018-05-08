#!/bin/bash

# 1/ Physical Attack:

# Physically reboot system, if GRUB is not protected with password, try to create an Interactive Session by
# pressing I during boot sequence

# if it has not been secured in /etc/sysconfig/init - PROMPT:no ... you can start the Int Session, and try to
# enter commands in prompt as root

# This may be complex, you may perhaps use the lack of GRUB password protection trying to boot from a Win
# which is part of a dual boot system

# 2/ Password Attack
# A password set must be hashed in root shadow file /etc/shadow, otherwise hashed passwords are stored in
# /etc/passwd

# Well, easy, copy the file into your USB, and then from your own machine, use brutal force to crack passwords

## PASSWORD CRACKERS:
# John The Ripper (www.openwall.com/john/
# Crack
# Slurpie (in multiple computers in parallel)

# 3/ Vulnerable networking services, which must be protected behind a firewall:

# remote logins other than ssh are vulnerable:
rlogin
telnet
ftp / vsftpd

# web content
http

# mail content
smtp
sendmail

# samba
smb

nfs

# transmits the contents of memory
netdump
netdump-server

# transmit info about user
finger
rwhod

# other vulnerable services:
authd
yppasswdd
ypserv
ypxfrd

# 4/ Types of Attacks:
DoS, DDoS (several machines attacking / bots)
# IP Spoofing: This attack leads to DDOS. A hacker sends pings to a server, but indicates in the package that reply is to an unexisting IP address
# The server collapses, because cannot close the TCP, then there are several requests, and crashes, file: ip_spoofing.sh

Script Vulnerability Attacks:
Webservers executing server-side scripts are vulnerable if not protected.

Buffer Overflow Attacks:
Services that connect to ports 0-1023 must run as root.
If one of these ports is opened and used by one app which is vulnerable to an exploitable fuffer attack, the hacker can get access.
* ports check: netstat -netap / nmap -sT -O <IP>

 

