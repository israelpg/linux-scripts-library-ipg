#!/bin/bash

sudo tcpdump -i <iface> -p <protocol>

# icmp / ping:

sudo tcpdump -i enp0s3 -p icmp


tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s3, link-type EN10MB (Ethernet), capture size 262144 bytes

0 packets captured
0 packets received by filter
0 packets dropped by kernel
