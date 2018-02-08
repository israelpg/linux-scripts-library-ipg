#!/bin/bash

# service : network : command (optional)
# service is normally a daemon, check: /usr/sbin

# spawn for sending mail to root user, informing about the incidence:
# twist sends echo to user trying to use the service which is forbidden for him/her

vsftpd : ALL : spawn (/usr/sbin/safe_finger -l 0%h | /bin/mail -s %d-%h root) &
vsftpd : ALL : twist /bin/echo "access to this service is forbidden"
