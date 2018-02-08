#!/bin/bash

ping hostname

ping 10.57.122.111

ping -i 2 -c 3 10.57.122.111 # it sends icmp packet with interval of 2 seconds, only 3 packets

# fping is similar, but only providing info on whether hosts are alive or not:

fping 10.57.122.111 10.57.122.196

# or providing a file with a list of hosts:

fping -f filename.txt

fping < filename.txt

