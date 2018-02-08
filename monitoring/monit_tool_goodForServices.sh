#!/bin/bash

# monit can be used to monitor the services of our servers (eg: apache2, mysqld ...) remotely via httpd

sudo apt-get install monit

# config: /etc/monit/monitrc

# some interesting lines:

set daemon 30 # to refresh monitoring each 30s, instead of default 120s

# services like apache2 come with this default parameters:

#  check process apache with pidfile /usr/local/apache/logs/httpd.pid
#    start program = "/etc/init.d/httpd start" with timeout 60 seconds
#    stop program  = "/etc/init.d/httpd stop"
#    if cpu > 60% for 2 cycles then alert
#    if cpu > 80% for 5 cycles then restart
#    if totalmem > 200.0 MB for 5 cycles then restart
#    if children > 250 then restart
#    if loadavg(5min) greater than 10 for 8 cycles then stop
#    if failed host www.tildeslash.com port 80 protocol http 
#       and request "/somefile.html"
#    then restart
#    if failed port 443 protocol https with timeout 15 seconds then restart
#    if 3 restarts within 5 cycles then unmonitor
#    depends on apache_bin
#    group server

# I have tried successfully:

# check apache2 service - auto starting in case of failure encountered by monit:
check process apache2 with pidfile /var/run/apache2/apache2.pid
        start program = "/etc/init.d/apache2 start"
        stop program = "/etc/init.d/apache2 stop"
        group www-data

# monitoring hosts, like Nagios is able to do as well:

## Check a remote host availability by issuing a ping test and check the 
## content of a response from a web server. Up to three pings are sent and 
## connection to a port and an application level network check is performed.
#
#  check host myserver with address 192.168.1.1
#    if failed ping then alert
#    if failed port 3306 protocol mysql with timeout 15 seconds then alert
#    if failed port 80 protocol http

# include files for individual sites:
Include /etc/monit/conf-available/*.cfg

# Now this cool scenario, imagine we want to monitor via monit, and we do it via ssh connecting to the server it has the installation:

ssh -L 8383:localhost:2812 username@ipaddress

# it means we are creating an ssh tunnel, which allows to connect the remote port 2812 using in our machine (local), the port 8383
