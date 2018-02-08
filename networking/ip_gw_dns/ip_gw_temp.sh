#!/bin/bash

sudo ifconfig eth0 10.12.55.123 netmask 255.255.255.0
sudo route add default gw 10.12.55.1
