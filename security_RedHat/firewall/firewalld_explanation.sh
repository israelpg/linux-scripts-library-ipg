#!/bin/bash

# Source info: https://www.tecmint.com/configure-firewalld-in-centos-7/1

# service name: firewalld.service

systemctl status firewalld.service

# graphical tool:
firewall-config

# Normally the running firewall is iptables, better stop it, and mask units to /dev/null:
systemctl stop iptables
systemctl mask iptables
...
● iptables.service
   Loaded: masked (/dev/null; bad)
   Active: inactive (dead)

# check main zone, interface, sources, services, rules ... in one command:
firewalld-cmd --list-all

[root@02DI20161235444 firewall]# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3
  sources: 
  services: dhcpv6-client ssh
  ports: 5070/tcp 34558/udp 34558/tcp 20048/tcp 445/tcp 2049/tcp 34915/tcp 111/tcp 48004/tcp
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules:

# check zones, active zones and active services

[root@02DI20161235444 firewall]# firewall-cmd --get-zones
block dmz drop external home internal public trusted work
# public means the one with access to the Internet, default zone: CHECK TYPES OF ZONES IN FILE:
firewalld_components_list.txt

# config file:
/etc/firewalld/firewalld.conf # for instance, default zone: DefaultZone=public

# checking available zones:
firewall-cmd --get-active-zones
# default zone
firewall-cmd --get-default-zone
# set default zone:
firewall-cmd --set-default-zone=home

# checking available ervices:
firewall-cmd --get-services | tr ' ' '\n'

# to add a customized service, eg: rtmp with port 1935: using an existing one as template (eg: ssh)
cp /usr/lib/firewalld/services/ssh.xml /etc/firewalld/services
# edit file, changing short tag, description tag, and protocol + port tags with the values for your customized service
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>rtmp</short>
  <description>To allow RTMP Streaming</description>
  <port protocol="tcp" port="1935"/>
</service>
# plus command line:
firewall-cmd --zone=public --add-service=rtmp # more details about add or remove services below (eg: permanent, zones ...)

# list interfaces, ports, services ... by zone

firewall-cmd --zone=public --list-interfaces
firewall-cmd --zone=public --list-ports

# removing the service from a specified zone:

firewall-cmd --permanent --zone-public --add-service=<service_name>

# adding a port in the public zone, main iface (RTD: enp0s3) !!! does not mean accept or reject, just add in the list

firewall-cmd --permanent --zone=public --add-port=2222/tcp

# removing a port, meaning it will be blocked:

firewall-cmd --zone=public --remove-port=2222/tcp

# similar procedure for services:

firewall-cmd --zone=public --add-service=ftp

firewall-cmd --zone=public --remove-service=ftp

## interface assignation for a zone:
# normally the default zone has the default iface assigned, but is not the same for the rest of zones, for configuring iface per zone:
firewall-cmd --zone=home --change-interface=eth0

#####  SERVER: allowing services, or applying rules for clients connecting to my server: (http, https, vnc-server, postgresql) .. service-port in /etc/services
# in the example below, our server allows the use of the following services for hosts in the network 10.136.137.0/24
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.0/24" service name="http" accept' --permanent
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.0/24" service name="https" accept' --permanent
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.0/24" service name="vnc-server" accept' --permanent
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.0/24" service name="postgresql" accept' --permanent
firewall-cmd --reload
firewall-cmd --list-all

# following this rich rules, we can proceed blocking a service like ssh for a specific network range or IP:
[root@02DI20161235444 firewall]# firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.110" service name="ssh" reject' --permanent 
firewall-cmd --reload

# to remove a rich rule:
[root@02DI20161235444 firewall]# firewall-cmd --zone=public --remove-rich-rule='rule family="ipv4" source address="10.136.137.110" service name="ssh" reject' --permanent
firewall-cmd --reload



