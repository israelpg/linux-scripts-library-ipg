#!/bin/bash

# Source Routing: The sending host can specify to the router the return path for redirecting the answers from other hosts
# therefore, is like saying to the router, "do not use your routing tables, use this info", this may lead to malicious use
# Sometimes is a good idea to Disable Source Routing in the server, so that cannot accept info other than routers

/etc/sysctl.conf

net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.all.forwarding=0
net.ipv6.conf.all.forwarding=0
# disable multicast
net.ipv4.conf.all.mc_forwarding=0
net.ipv6.conf.all.mc_forwarding=0
# icmp redirects disable:
net.ipv4.conf.all.accept_redirects=0
net.ipv6.conf.all.accept_redirects=0
# secure icmp disable:
net.ipv4.conf.all.secure_redirects=0
# disable sending of all IPv4 ICMP redirected packets on all ifaces:
net.ipv4.conf.all.send_redirects=0

sysctl -p

