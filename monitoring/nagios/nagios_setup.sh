#!/bin/bash

# SOURCE INFO: https://help.ubuntu.com/lts/serverguide/nagios.html

# Install in the server which will be used to monitor rest of network (other servers and hosts):

# server: sudo apt-get install nagios3 nagios-nrpe-plugin

# Normally you are prompted to type your nagiosadmin password, therefore: user is nagiosadmin, password to setup

# Otherwise, you can add new users/password by typing:

sudo htpasswd /etc/nagios3/htpasswd.users nagiosadmin
sudo htpasswd /etc/nagios3/htpasswd.users israel

# In the rest of servers, the ones to be monitored, you need to install the plugin:

sudo apt-get install nagios-nrpe-plugin

# plus the nagios-nrpe-server in case you want to check disks.

# Config Files, in the server: /etc/nagios3/conf.d
# Config Files, in the monitored hosts: /etc/nagios-plugins/config/check_nrpe.cfg

# CONFIGURE SERVER - Which hosts and services to check for:

# 1/ cp /etc/nagios3/conf.d/localhost_nagios3.cfg server2.cfg (server2.cfg uses the blueprint and implement config by user)

# 2/ edit server2.cfg: define host, and different services to check: DNS, check Disks ... see Ubuntu Server Guide!!!
# SOURCE INFO: https://help.ubuntu.com/lts/serverguide/nagios.html
# You need to define a host: define host (add server name, alias, and IPaddress of the client to check for)
# Then you config the services, define service (again, server name, alias, and check_command:
# Here is important to understand that the services execute COMMANDS, defined in the plugin for performing several actions
# For instance, Check_disk ... well, then check the plugin config files if you must adapt it: 
# eg: /etc/nagios-plugins/config/disk.cfg (for the check disk service)

# URL for checking nagios monitoring browser tool: http://localhost/nagios3

# CLIENT: Which is another host, perhaps a server (DNS, and so on) ... to be checked by Nagios in server1

# 1/ Edit /etc/nagios-plugins/config/check_nrpe.cfg --> Just for DISK CHECK, allowing server for checking/monitoring
# ... for other services, see Ubuntu Server Guide!!!


