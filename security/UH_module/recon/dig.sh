#!/bin/bash

# Getting DNS information :

# For instance, get the address of google.com :

israel@W9980173 ~ $ dig google.com | grep google.com | cut -f6 | tail -n -1

172.217.19.206

# or easy way:

israel@W9980173 ~ $ dig google.com +short

172.217.19.206

# a loop to find out information of each IP returned by server dig command execution :

for ip in `dig google.com +short`; do whois $ip; done | grep -v '^#'

# To find out a relation between server names and IPs :

for ip in `cat GoogleServerIPs`; do echo "[*]$ip -> "`dig -x $ip +short`; done
