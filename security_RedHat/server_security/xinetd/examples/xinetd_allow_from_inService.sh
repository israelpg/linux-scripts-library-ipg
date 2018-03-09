#!/bin/bash
# eg: telnet

service telnet
{
	socket_type	= stream
	protocol	= tcp
	wait		= no
	user		= root
	server		= /usr/sbin/in.telnetd
	only_from	= 127.0.0.1
	only_from	= 192.168.15.0 # whole network
	log_on_success	= DURATION EXIT HOST PID USERID # /var/log/messages
	log_on_failure	= ATTEMPT HOST USERID
	# selecting a file other than /var/log/messages :
	# log_type	= FILE /var/log/mytelnet.log
	disable		= no
}
