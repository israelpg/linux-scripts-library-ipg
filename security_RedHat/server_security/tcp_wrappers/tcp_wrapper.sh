#!/bin/bash

# similar to block via iptables firewall:

/etc/hosts.deny

# blocking ALL services to whole network:
ALL : 10.136.137.0 : spawn /bin/echo `date` %c %d >> /var/log/intruder_alert.log
# %c user details
# %d service details the attacker was trying to break
# details are redirected to a log file
[root@localhost profile.d]# tail /var/log/intruder_alert.log
Fri 19 Jan 15:10:57 CET 2018 10.136.137.109 sshd
Fri 19 Jan 15:11:09 CET 2018 10.136.137.109 sshd

# block ALL services just one of the hosts in a network, plus logging activity:
/etc/hosts.deny
ALL : 10.136.137.119 : spawn /bin/echo `date` %c %d >> /var/log/intruder_alert.log
# blocking sshd and vsftpd services for a host:
sshd,vsftpd : 10.136.137.119 : spawn /bin/echo `date` %c %d >> /var/log/intruder_alert.log

# allow is in:
/etc/hosts.allow

## scenario: allowing sshd and vsftpd just for a host, rest of services are denied to everybody:
/etc/hosts.allow
sshd,vsftpd : 10.136.137.109,LOCAL

/etc/hosts.deny
sshd,vsftpd : ALL # remarking just in case
ALL : ALL

# improve logging while blocking via TCP wrappers:
# eg: an attacker tries to connect to port 23 (telnet port) in an ftp server:
/etc/hosts.deny
in.telnetd : ALL : severity emerg
