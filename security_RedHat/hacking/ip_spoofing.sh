#!/bin/bash

# Summary:
# IP spoofing is commited by a hacker, which sends several requests to a server (victim), indicating that replies from server (eg: ping/icmp)
# are redirected to an unexisting IP address, then TCP cannot close connection cuz there is not confirmation of delivery, and server collapses.

# To prevent this, procfs is configured, rp_filter=1 (enabling rp_filter) in /etc/sysctl.conf

sysctl -ar 'rp_filter'
net.ipv4.conf.all.rp_filter = 1

[ip14aai@02DI20161235444 ~]$ sysctl -ar 'rp_filter' | grep 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.virbr0.rp_filter = 1
net.ipv4.conf.virbr0-nic.rp_filter = 1

# If value is 0 (not enabled), then update the value:
sysctl -w 'net.ipv4.conf.all.rp_filter=1'
sysctl --system -p # --system for loading /etc/sysctl.d/*.conf file + -p for loading default /etc/sysctl.conf file

# values are:
# 0: No source address validation, 1 Strict Mode (recommended), 2 Loose Mode: return path might be different than source, but included in routing table

## NOW THE FUN STUFF, ATTACKING:
# Three hosts involved: net2, net3, and router (a Linux Server)
# Host net2: enp0s3 IP --> 192.168.58.4/24, GW --> 192.168.58.3
# router: enp0s3 IP --> 192.168.0.3/24 (Default route to Internet), enp0s8 IP --> 192.168.58.3 (network: net2), enp0s9 IP --> 192.168.59.4/24 (network: net3)
# Host net3: enp0s8 IP --> 192.168.59.3/24, GW --> 192.168.59.4

# Server/Router configuration: Allowing ip_forward in procfs / sysctl:

sysctl -w 'net-ipv4.ip_forward=1'
sysctl --system -p
# check with sysctl -ar 'ip_forward'

# Host net2: Here is where the hacker, using this machine, adds some lines in iptables for attacking with IP Spoofing:
net2$ sudo iptables -t nat -A POSTROUTING -p tcp -m tcp --dport 22 -j ACCEPT # in case you want to connect to host net2 via ssh (if host net2 is a VM)
net2$ sudo iptables -t nat -A POSTROUTING -j SNAT --to-source 192.168.59.10 # SNAT: Source NAT, here is the key, this address does not exist in the routing table
# any non-ssh packet leaving this host net2, will have source address 192.168.59.10
# note that we are using a non-existing IP address in net3, the router cannot expect that.

# Checking ping / icmp in host net3 and server/router:
sudo tcpdump -i <iface> -p icmp

## LOGGING: Enable log_martians for logging dropped packets by router: Martian Source
#  By defaut is disabled:
[root@02DI20161235444 ip14aai]# sysctl -ar 'log_martians'
net.ipv4.conf.all.log_martians = 0

sysctl -w 'net.ipv4.conf.all.log_martians=1'
sysctl --system -p

# logs are in: /var/log/message (CentOS), and /var/log/syslog (Debian)
tail -fn0 /var/log/message
# it will mention martian source <destination-IP> from <unexisting-IP>



