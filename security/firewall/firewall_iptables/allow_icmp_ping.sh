#!/bin/bash

sudo iptables -A INPUT -p icmp --icmp-type any -j ACCEPT
sudo iptables -A OUTPUT -p icmp --icmp-type any -j ACCEPT
