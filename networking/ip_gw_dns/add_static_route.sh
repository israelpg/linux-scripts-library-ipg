#!/bin/bash

# my machine is in the network 10.57.122/0, and I add a route to another subnet:
# 10.56.110.0 ... plus the router, .1, for my device eth0

sudo route add -net 10.56.110.0 netmask 255.255.255.0 gw 10.57.122.1 dev eth0
sudo route add -host 10.56.110.1 netmask 255.255.255.0 gw 10.57.122.1 dev eth0
