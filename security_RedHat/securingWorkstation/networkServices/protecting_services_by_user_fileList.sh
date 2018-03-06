#!/bin/bash

# listed users are not able to load a service, eg: ssh, mail, vsftpd ...
# for instance: vsftpd

/etc/pam.d/vsftpd

auth	required	pam_listfile.so	item=user	sense=deny	file=/etc/vsftpd.ftpusers onerr=succeed

# same applicability for other services like: /etc/pam.d/pop ... imap ... ssh


