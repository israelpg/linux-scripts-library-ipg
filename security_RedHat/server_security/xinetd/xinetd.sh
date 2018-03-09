#!/bin/bash

/etc/xinetd.conf

# services config files are under:
/etc/xinetd.d/<service_name>

# for instance, telnet:
service rsync
{
	disable		= no
	id		= rsync
	wait		= yes
	socket_type	= stream
	user		= root
	server		= /usr/bin/rsync
	server_args	= --daemon
	log_on_success	+= PID HOST EXIT
	log_on_failure	+= USERID
	no_access	= 10.136.137.0/24
}

# to list all services within xinetd, enabled or not:
chkconfig --list

# to enable a service to be controlled by xinetd:
chkconfig telnet on # disable with: chkconfig telnet off


