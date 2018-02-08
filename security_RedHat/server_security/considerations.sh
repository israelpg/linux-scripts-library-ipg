#!/bin/bash

Recommended to use a combination of several techniques:

pam.d (login, passwd), /etc/security/access.conf,limits.conf, TCP wrappers (/etc/hosts.allow,deny) + xinetd (superserver which provides access control over Internet Services) + iptables firewall

# When concerned about the server itself, then use pam.d plus /etc/security files
# blocking some hosts: tcp wrappers (/etc/hosts.allow,deny) ... trying to access the server, or use a concrete service
# controlling who uses our services: combination between xinetd service controlling Internet Services + iptables to allow or block ports connection / networks --- good to avoid DDOS attacks

## TCP wrappers via banner implementation in a service (is like advicing the attacker of the protection)
# see: banners.sh + folder: banners_example_script

## TCP wrappers can also make use of /etc/hosts.deny to deny access to a server from a specific IP range (network)
# It may be combined with iptables firewall, of course
/etc/hosts.allow ... /etc/hosts.deny
# see: tcp_wrapper_hosts_deny.sh

# improving logging: tcp_wrapper_hosts_deny.sh

## xinetd
# controlling hosts or networks that can use a service, whether we disable it or not, resources assigned to it ...

