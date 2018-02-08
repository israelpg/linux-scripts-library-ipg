#!/bin/bash

# Summary: Tiger VCN Server allows to connect remotely to a machine, but not only via shell, but with a desktop as well:

[ip14aai@localhost scripts]$ sudo yum info tigervnc.x86_64 
Loading "fastestmirror" plugin
Loading "langpacks" plugin
Adding en_GB.UTF-8 to language list
Config time: 0.010
Yum version: 3.4.3
rpmdb time: 0.000
Setting up Package Sacks
Loading mirror speeds from cached hostfile
 * base: centos.cu.be
 * extras: centos.cu.be
 * updates: centos.crazyfrogs.org
pkgsack time: 0.007
Available Packages
Name        : tigervnc
Arch        : x86_64
Version     : 1.8.0
Release     : 1.el7
Size        : 238 k
Repo        : base/7/x86_64
Committer   : Jan Grulich <jgrulich@redhat.com>
Committime  : Wed May 17 14:00:00 2017
Buildtime   : Mon Aug  7 03:32:46 2017
Summary     : A TigerVNC remote display system
URL         : http://www.tigervnc.com
Licence     : GPLv2+
Description : Virtual Network Computing (VNC) is a remote display system which
            : allows you to view a computing 'desktop' environment not only on the
            : machine where it is running, but from anywhere on the Internet and
            : from a wide variety of machine architectures.  This package contains a
            : client which will allow you to connect to other desktops running a VNC
            : server.

# install it ... for connecting to the machine with the server

# plus install the server in in the machine you want to connect, therefore running tiger server service:

[ip14aai@localhost ~]$ sudo yum install tigervnc-server.x86_64

# default service config file:

cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver-username@.service

# edit the config file in /etc :

ExecStart=/usr/sbin/runuser -1 <username> -c "/usr/bin/vncserver %i -geometry 1280x1024"
PIDFile=/home/<username>/.vnc/%H%i.pid

# reload daemon / service

systemct daemon-reload

# set the password for <username> to be able to connect:

su - username

# use command to establish the passwd:

vncpasswd

# now from the client, we will be able to connect to the vnc tiger server, with a proper desktop

# Note: You can setup different users, you just need to create the corresponding .service files:

vncserver-<username>@.service

# For instance:

vncserver-user1@.service
vncserver-user2@.service

### starting VNC Server:

systemctl enable vncserver@:display_number.service
systemctl start vncserver@display_number.service

# in the example above:

systemctl start vncserver-user1@:3.service # where 3 is a display number, not a user number or something else

### FIREWALL AND PORTS CONSIDERATION:

# open port 5902 so that vncserver listens for connections to display_number 2 for specified user in conf:

sudo iptables -A INPUT -p tcp --dport 5902 -j ACCEPT

# check that iptables is well configured now:

sudo iptables -L -n | grep '5902'

# is it listening?

netstat -tnlp

lsof -i -P | grep '5902'



