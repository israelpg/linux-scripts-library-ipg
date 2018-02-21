#!/bin/bash

echo "Open TCP ports in localhost:"
nmap -sT localhost

echo "Established connections:"
lsof -i4 -N -P

echo -e "\n"
netstat -tuplna

