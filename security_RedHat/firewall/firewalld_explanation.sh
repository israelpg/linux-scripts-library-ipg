ll-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.0/24" service name="postgresql" accept' --permanent
firewall-cmd --reload
firewall-cmd --list-all

# following this rich rules, we can proceed blocking a service like ssh for a specific network range or IP:
[root@02DI20161235444 firewall]# firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.136.137.110" service name="ssh" reject' --permanent
firewall-cmd --reload

# to remove a rich rule:
[root@02DI20161235444 firewall]# firewall-cmd --zone=public --remove-rich-rule='rule family="ipv4" source address="10.136.137.110" service name="ssh" reject' --permanent
firewall-cmd --reload

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
# another port, eg: 2222



                                                                                              134,0-1       Bot

