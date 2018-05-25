#!/bin/bash

# Scenario: Tomcat has default port: 8081, in case we decide to change it to 8088

# firewall:

firewall-cmd --zone=public --add-port=8088/tcp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-ports

# semanage / SELINUX:

semanage -a -t http_port_t -p tcp 8088

# check once you open the browser, that everything is listening accordingly, port and socket:

[root@02DI20161235444 tomcat]# nmap -p 8088 localhost

Starting Nmap 6.40 ( http://nmap.org ) at 2018-05-25 14:18 CEST
Nmap scan report for localhost (127.0.0.1)
Host is up (-950s latency).
Other addresses for localhost (not scanned): 127.0.0.1
PORT     STATE SERVICE
8088/tcp open  radan-http

Nmap done: 1 IP address (1 host up) scanned in 0.07 seconds
[root@02DI20161235444 tomcat]# netstat -tuplna | grep 8088
tcp6       0      0 :::8088                 :::*                    LISTEN      31017/java          
[root@02DI20161235444 tomcat]# ss -ntl | grep 8088
LISTEN     0      100         :::8088                    :::*                  
[root@02DI20161235444 tomcat]# 



