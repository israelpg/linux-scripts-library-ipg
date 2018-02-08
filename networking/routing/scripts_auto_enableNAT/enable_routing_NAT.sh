#!/bin/bash

echo 0 > /proc/sys/net/ipv4/ip_forward
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
iptables -A FORWARD -i enp0s8 -o enp0s3 -s 192.168.56.0/24 -p tcp \
--dport 80 -j ACCEPT
iptables -A FORWARD -i enp0s3 -o enp0s8 -d 192.168.56.0/24 -p tcp \
--sport 80 -j ACCEPT
iptables -t nat -A POSTROUTING -o enp0s3 -s 192.168.56.0/24 -j SNAT \
--to-source 10.57.122.197
echo 1 > /proc/sys/net/ipv4/ip_forward
