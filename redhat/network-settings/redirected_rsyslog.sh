# You can send logs from one machine to another via UDP (redirection auto):

# In the reader or receiver:

/etc/rsyslog.conf

# open port udp 514 :

#################
#### MODULES ####
#################
...
# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")
...

# Make sure the port is listening:

netstat -ln | grep 514

udp        0      0 0.0.0.0:514             0.0.0.0:*                          
udp6       0      0 :::514                  :::*                               


### then , the sender needs to be configured via netconsole :

/etc/sysconfig/netconsole

[root@s999lnx86 ~]# cat /etc/sysconfig/netconsole 
# This is the configuration file for the netconsole service.  By starting
# this service you allow a remote syslog daemon to record console output
# from this system.

# The local port number that the netconsole module will use
# LOCALPORT=6666

# The ethernet device to send console messages out of (only set this if it
# can't be automatically determined)
# DEV=

# The IP address of the remote syslog server to send messages to
SYSLOGADDR=192.168.1.55

# The listening port of the remote syslog daemon
 SYSLOGPORT=514

# The MAC address of the remote syslog server (only set this if it can't
# be automatically determined)
# SYSLOGMACADDR=

### Just indicate the IP address of the receiver with UDP port 514 opened

# Messages are to be read by reader under:

/var/log/messages # note this must be a Red Hat machine
