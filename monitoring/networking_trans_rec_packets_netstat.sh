#!/bin/bash

netstat -i

# to constantly monitor transmission:

watch -n 2 "netstat -i"

# this can be compared with results of iftop or vnstat

# per type of packets:

netstat -s
