#!/bin/bash

# this is on top of xinetd

# to check if a service is supported by libwrapper.so library / TCP Wrappers:
# library dependency: ldd
ldd <binary>

ldd $(which sshd)

israel@israel-N56JN:~/tests/24012018$ ldd $(which sshd)
        linux-vdso.so.1 =>  (0x00007ffcc87a7000)
        libwrap.so.0 => /lib/x86_64-linux-gnu/libwrap.so.0 (0x00007f3ea86af000)

# sshd has library libwrap.so.0, therefore it supports TCP wrappers

# similar to block via iptables firewall:

/etc/hosts.deny

# blocking ALL services to whole network:
ALL : 10.136.137.0/24 \
 : spawn /bin/echo `date` %c %d >> /var/log/intruder_alert.log \
 : deny
# %c user details, %a IP, %h client's hostname, %H server's hostname, %n client's hostname, %N
# %d service details the attacker was trying to break, %p process id, %u username, %s: processID, hostname, IP...
# details are redirected to a log file
[root@localhost profile.d]# tail /var/log/intruder_alert.log
Fri 19 Jan 15:10:57 CET 2018 10.136.137.109 sshd
Fri 19 Jan 15:11:09 CET 2018 10.136.137.109 sshd

## example:
sshd,vsftpd : 10.136.137.120 \
 : spawn /bin/echo `date` %c %d %p %u %s>> /var/log/intruder_alert.log \
 : deny

# block ALL services just one of the hosts in a network, plus logging activity:
/etc/hosts.deny
ALL : 10.136.137.119 \
 : spawn /bin/echo `date` %c %d >> /var/log/intruder_alert.log \
 : deny

# blocking sshd and vsftpd services for a host:
sshd,vsftpd : 10.136.137.119 \
 : spawn /bin/echo `date` %c %d >> /var/log/intruder_alert.log \
 : deny

# allow is in:
/etc/hosts.allow

## some admins decide to add in the same file, say hosts.allow (can be in hosts.deny if you prefer that):
sshd : client1.example.com : allow
sshd : client2.example.com : deny

## or by using both files, like in this scenario: allowing sshd and vsftpd just for a host, rest of services are denied to everybody:
/etc/hosts.allow
sshd,vsftpd : 10.136.137.109

/etc/hosts.deny
sshd,vsftpd : ALL # remarking just in case
ALL : ALL

# improve logging while blocking via TCP wrappers:
# eg: an attacker tries to connect to port 23 (telnet port) in an ftp server:
/etc/hosts.deny
in.telnetd : ALL : severity emerg
# or:
sshd : .example.com : severity local0.alert # local0 should be enabled in syslogd

sshd : 10.0.0.0/8 \
 : spawn /bin/echo `/bin/date` access denied from network 10.0.0.0/8>>/var/log/sshd.log \
 : deny
