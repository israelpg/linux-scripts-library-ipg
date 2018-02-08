#!/bin/bash

# 2 layers:

/etc/sysctl.conf

net.ipv4.icmp_echo_ignore_all = 1

sysctl -p

# plus iptables filter:

iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -d localhost -m state --state NEW,ESTABLISHED,RELATED -j DROP
iptables -A OUTPUT -p icmp --icmp-type 0 -s localhost -d 0/0 -m state --state ESTABLISHED,RELATED -j DROP

service iptables save

