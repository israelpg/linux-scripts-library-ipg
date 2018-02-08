#!/bin/bash

# -a means only alive hosts, -g for specifying a network/bitmask

fping -a 10.57.122.0/24 -g 2> /dev/null
