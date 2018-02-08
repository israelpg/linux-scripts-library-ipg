#!/bin/bash

# 1) Scan for a specific port in a host:

nmap -p 80 10.57.122.197

# 2) Scan entire machine for checking open ports:

nmap 10.57.122.197

# 3) open ports in all network hosts:

nmap 10.57.122.0/24 # (0-255)

# 4) fast scan

nmap -F 10.57.122.196

# 5) with many details:

nmap -v 10.57.122.197

# 6) scan a machine for TCP open ports

nmap -sT 10.57.122.197

# 7) scan UDP in a host:

nmap -sU 10.57.122.197

# 8) supported protocols in a remote machine

nmap -sO 10.57.122.197

# 9) -O is for OS scan along with default port scan:

nmap -O google.com
