#!/bin/bash

sudo route add -net 192.168.56.0 netmask 255.255.255.0 gw 192.168.56.101 dev enp0s8
