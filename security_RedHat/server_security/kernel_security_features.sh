#!/bin/bash

# procfs within /proc/ handles security features at boot time, which can be managed in an interactive session using sysctl.conf 

/etc/sysctl.conf

# to see the kernel features:

sysctl -a | grep -i 'icmp' # or filtering by any other kernel property/value

# more professional using -r option as a regex:

sysctl -ar 'icmp'
sysctl -ar '^kernel\.domainname$' # starts with kernel, ends with domainname, using . as separator is special char, escape with \

# when adding a new feature, eg: icmp blocking
# via edit: /etc/sysctl.conf 
# or using command line:
sysctl -w <feature_name=value>
# reload with:
sysctl -p

# it is also possible to specify which file to reload (instead of default /etc/sysctl.conf) from the sysctl.d/*.conf files:
sysctl -p /etc/sysctl.d/*.conf
# list of conf files in /etc/sysctl.d/
10-console-messages.conf
10-ipv6-privacy.conf
10-kernel-hardening.conf
10-link-restrictions.conf
10-magic-sysrq.conf
10-network-security.conf
10-ptrace.conf
10-zeropage.conf
30-baloo-inotify-limit.conf
60-oracle.conf
99-sysctl.conf
cinelerra-cv.conf

# or better reload everything, default /etc/sysctl.conf file and /etc/sysctl.d/*conf files with:

sysctl -system -p

# Best practice:
# creating own conf files to structure security features:
# example: domainname, by default none: **** this is just an example, this value is not needed, we use dns instead
kernel.domainname = (none)

echo 'kernel.domainname=ip14aai.com' | sudo tee /etc/sysctl.d/01-nis-domain-name.conf
sysctl -system -p

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





