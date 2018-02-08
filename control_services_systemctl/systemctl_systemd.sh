#!/bin/bash

# systemd controls the services active, enabled, in the system as init

# before sysv-rc-conf was used, although it is still available, it is better to use systemctl tool

# to see the list of services, all of them:

systemctl -a

# then enable or disable:

systemctl enable apache2.service

# start or stop:

systemctl start apache2.service

# restart or reload:

systemctl restart apache2.service

# active 

systemct is-active service.name # if is active, we can stop it: sudo systemctl stop <service-name>

###### In any case ... type: systemctl (tab) and you will get a list of functionalities to handle services

# files containing units per each service, under folders:

/lib/systemd/system/*

/etc/systemd/system/*

# to see logs for services, use the journalctl:

journalctl -u <service-name>
