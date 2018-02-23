#!/bin/bash

echo "Active users:"
w

echo "Open TCP ports in localhost:"
nmap -sT localhost

echo "Established connections:"
lsof -i4 -N -P

echo -e "\n"
netstat -tuplna

echo "List of intruders:"
./detect_ip_intruders.sh
