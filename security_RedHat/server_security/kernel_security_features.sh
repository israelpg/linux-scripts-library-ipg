#!/bin/bash

/etc/sysctl.conf

# to see the kernel features:

sysctl -a | grep -i 'icmp' # or filtering by any other kernel property/value

# when adding a new feature, eg: icmp blocking
# via edit: /etc/sysctl.conf , reload with:
sysctl -p

#### some features:

# Disable ICMP requests/ping, our server does not give ping to other machines:
net.ipv4.icmp_echo_ignore_all = 1

# Enable TCP SYN Cookie Protection against DDOS attacks:
net.ipv4.tcp_syncookies = 1

# Disable IP Source Routing: To avoid that our server replies to a machine registered in the routing table, always trust in routing tables
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# Disable ICMP Redirect Acceptance:
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Enable IP Spoofing Protection: Detect if a host is trying to change its source address, pretending to be someone else
# 0 for nor source validation, 1 for Strict mode, 2 Loose mode
net.ipv4.conf.all.rp_filter = 1

# Enable Ignoring Broadcasts Request
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Enable Bad Error Message Protection
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Enable Logging of Spoofed Packets, Source Routed Packets, Redirect Packets
net.ipv4.conf.all.log_martians= 1

# Default Settings: Make sure values are setup:
# Buffer Overflow Attack Mitigation:
# ASLR: Address Space Layout Randomization
cat /proc/sys/kernel/randomize_va_space
2
# making kernel exploits harder No-eXecute (NX bit):
cat /proc/sys/kernel/kptr_restrict
1

# File system hardening:
# protecting hardlinks and symlinks:
cat /proc/sys/fs/protected_hardlinks
1
cat /proc/sys/fs/protected_symlinks
1

# Increased dmesg / kernel logging protection:
kernel.dmesg_restrict
1





