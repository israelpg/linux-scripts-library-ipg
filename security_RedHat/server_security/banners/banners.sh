#!/bin/bash

# banners are used to display a message to remote users connecting to our server to use a service: smtp, ssh, vsftpd ...

# Instructions for an initial message before login:

# 1/ Create the banner in /etc/banners/<service_name> , eg: sshd
/etc/banners/sshd

# activate banner via:
/etc/sshd_config
Banner /etc/banners/sshd

# allowing ALL users to have access to the server after banner is displayed before login:
sshd : ALL : banners /etc/banners/

# for an after login message:
/etc/motd
# if you want to use script instead, then better edit the motd as a sh script in:
/etc/profile.d/motd.sh




