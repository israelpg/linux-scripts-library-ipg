#!/bin/bash

# flush network to restart and reload values

sudo ifdown --force eth0 && sudo ip addr flush dev eth0 && sudo ifup --force eth0
