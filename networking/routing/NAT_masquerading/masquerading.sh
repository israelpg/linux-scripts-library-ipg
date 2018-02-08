#!/bin/bash

# IP Masquerading allows several machines to connect to the IP Masq Linux machine acting as server, which forwards
# client packets into the Internet. Moreover, external hosts will see that these packets are linked to the server IP
# instead of directly attached to the clients.

# First we need to allow the Linux acting as server to forward IPv4 and IPv6 packets from clients to the Internet:
# Edit sysctl.conf file so that changes are permanent to the system:

sudo nano -c /etc/sysctl.conf

# net.ipv4.ip_forward=1

# net.ipv6.conf.default.forwarding=1

# enable new settings in the config file:

sudo sysctl -p

# * temp changes can also be applied (not permanent as /etc/sysctl.conf), in this case:
# echo "1" > /proc/sys/net/ipv4/ip_forward

# Adapt Firewall Rules so that server performs NAT, translating internat IPs into external:
# add to nat table, rule applies to source network specified, traffic routed to iface enp0s3, masquerade
# -t table nat
# -A append POSTROUTING
# -s source network
# -o output iface !!!! Bear in mind that source is originated via internal network/iface, like enp0s8, -o points Internet
# -j jump to masquerade

# in this example below: SERVER (enp0s3 is pointing to Internet, enp0s8 to internal private network / CLIENT: only has enp0s8 internal)

sudo iptables -t nat -A POSTROUTING -s 192.168.56.0/24 -o enp0s3 -j MASQUERADE

# same can be applied by using this method:

sudo iptables --table nat --append POSTROUTING --in-interface enp0s8 --out-interface enp0s3 -j MASQUERADE

# add forward rules in the iptables firewall as well: allow connections from internal to external and viceversa

sudo iptables -A FORWARD -s 192.168.56.0/24 -o enp0s3 -j ACCEPT
sudo iptables -A FORWARD -d 192.168.56.0/24 -m state --state ESTABLISHED,RELATED -i enp0s3 -j ACCEPT

# or this way:

sudo iptables --apend FORWARD --in-interface enp0s8 -j ACCEPT

# apply changes by restarting networking.service:

sudo systemctl restart networking.service

# to be applicable in reboot, add the commands in /etc/rc.local


