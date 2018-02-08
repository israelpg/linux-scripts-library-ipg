#!/bin/bash

# check syntax:
# forward:
named-checkzone example.com /etc/bind/db.example.com
# reverse:
named-checkzone 1.168.192.in-addr.arpa /etc/bind/db.192
# in RTD: named-checkzone 122.57.10.in-addr.arpa /etc/bind/db.10

dig -x 127.0.0.1 # to check it listens to port 53/DNS

dig google.com # external works?

# make pings ... fping ...



