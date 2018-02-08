#!/bin/bash

sudo visudo # to add in the /etc/sudoers file our username so that we can execute as root when needed:

# add this to the file:
ip14aai ALL=(ALL:ALL) ALL

