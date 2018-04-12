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

# check zones, active zones and active services

[root@02DI20161235444 firewall]# firewall-cmd --get-zones
block dmz drop external home internal public trusted work
# public means the one with access to the Internet, default zone: CHECK TYPES OF ZONES IN FILE:
firewalld_components_list.txt

# checking zones:
firewall-cmd --get-active-zones
firewall-cmd --get-default-zone

# checking services:
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

firewall-cmd --add-service=rtmp
# or selecting zone if needed:
firewall-cmd --zone=public --add-service=rtmp

# list interfaces, ports ... by zone

firewall-cmd --zone=public --list-interfaces
firewall-cmd --zone=public --list-ports

# adding a port in the public zone, main iface (RTD: enp0s3)

firewall-cmd --permanent --zone=public --add-port=2222/tcp

# removing a port, meaning it will be blocked:

firewall-cmd --zone=public --remove-port=2222/tcp

# similar procedure for services:

firewall-cmd --zone=public --add-service=ftp

firewall-cmd --zone=public --remove-service=ftp

