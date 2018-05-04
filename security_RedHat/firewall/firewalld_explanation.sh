# firewall service: daemon --> firewalld.service

# in order to avoid conflicts with iptables firewall, stop it, disable it, and mask it:
systemctl stop iptables.service
systemctl disable iptables.service
systemctl mask iptables.service

# zones:
firewall-cmd --list-all-zones
# to check the main active one:
firewall-cmd --get-active-zones
# set default zone:
firewall-cmd --set-default-zone=<zoneName>
# list all for a zone:
firewall-cmd --zone=public --list-all

# interface:
# define an interface for a zone:
firewall-cmd --zone=external --add-interface=eth1
firewall-cmd --reload

## SOURCES: Networks
firewall-cmd --zone=public --add-source=192.168.1.0/24 --permanent

## PORTS
# list ports
firewall-cmd --zone=public --list-ports

# adding a port: (permanent!)
firewall-cmd --zone=public --add-port=22/tcp --permanent
# reload!!!
firewall-cmd --reload
# list again
# removing port:
firewall-cmd --zone=public --remove-port=22/tcp --permanent
firewall-cmd --reload
# this will prevent connections to this port, except * service ssh is expressively added
# note: removing the port from list-ports in firewalld service does not mean it is close:
nmap -p 22 localhost
Starting Nmap 6.40 ( http://nmap.org ) at 2018-04-18 14:40 CEST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00014s latency).
Other addresses for localhost (not scanned): 127.0.0.1
PORT   STATE SERVICE
22/tcp open  ssh

Nmap done: 1 IP address (1 host up) scanned in 0.04 seconds


## services 
#--------------------------->>> SERVICE overrules port, eg: if ssh is added, removing 22 does not prevent access
# add service
firewall-cmd --zone=public --list-services
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --reload
# remove service: 
firewall-cmd --zone=public --remove-service=http --permanent
firewall-cmd --reload

# rich rule: controlling a system service
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.0/24" service name="postgresql" accept' --permanent
firewall-cmd --reload
firewall-cmd --list-all

# following this rich rules, we can proceed blocking a service like ssh for a specific network range or IP:
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.110" service name="ssh" reject' --permanent
firewall-cmd --reload

# to remove a rich rule:
firewall-cmd --zone=public --remove-rich-rule='rule family="ipv4" source address="10.136.137.110" service name="ssh" reject' --permanent
firewall-cmd --reload

# blocking IP via rich rule:
firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="10.136.137.120" reject' --permanent

# ICMP: This is a service (icmpd), which handles the ping requests from this server and to this server
# get list of all icmp types we can handle with firewalld:
firewall-cmd --get-icmptypes
# this should be: echo-request, echo-reply
# in order to block incoming pings (similar to a block via /etc/sysctl.conf for kernel features management):
firewall-cmd --add-icmp-block=echo-request --permanent
firewall-cmd --reload
firewall-cmd --list-all

# MASQUERADE:
# Details for iptables under script:
/home/ip14aai/git/workspace_linux_scripts/security/NAT_masquerading/masquerading.sh
# in firewalld (redhat):
# Scenario: The idea is to allow remote connections to a virtual machine, therefore, you cannot point from
# the remote client machine to port 22, because that port is from the host, I need to change guest port 22 to
# another port, eg: 2222 - normally done for external zone
# steps:
# 1. Check masquerade is yes
firewall-cmd --zone=external --query-masquerade
yes
firewall-cmd --zone=public --add-forward-port=port=22:proto=tcp:toport=2222:toaddr=10.136.137.120 --permanent
firewall-cmd --reload
firewall-cmd --zone=external --list-forward-ports

## LOCKDOWN - Ensure that firewalld rules cannot be changed by any app:
firewall-cmd --query-lockdown
no
firewall-cmd --lockdown-on
success
firewall-cmd --reload
                                                                                              134,0-1       Bot

