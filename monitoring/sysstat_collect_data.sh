#!/bin/bash

sudo apt-get install sysstat

# sar to start collecting data, -u for cpu information in 1 second interval 3 quantity
sar -u 1 3

# -w how busy our cpu is
sar -w 1 3 # switches between processes ... multitasking

# amount of free mem in our system:
sar -r 1 3

# swap:
sar -S 1 3

# transfers in bits per second:
sar -b 1 3

# network transmission by device/iface:

sar -d 1 3


