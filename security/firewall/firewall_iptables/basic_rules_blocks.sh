#!/bin/bash

# block specific ip address, so that trying to connect to destination, will be blocked:
iptables -A OUTPUT -d 10.57.122.194 -j DROP

# block specific port as destination:
iptables -A OUTPUT -p tcp -dport 21 -j DROP


# delete a rule:

sudo iptables -D OUTPUT -d 10.57.122.194 -j DROP
