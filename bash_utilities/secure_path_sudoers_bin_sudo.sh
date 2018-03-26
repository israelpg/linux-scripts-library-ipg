#!/bin/bash

# Scenario: ccat binary is stored under folder:
/usr/local/bin

ccat /etc/environment # can be listed

ccat /etc/sudoers # cannot be listed if not root or using sudo

# sudo only executes binaries which are defined under:
/etc/sudoers

Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# then you can execute now:
sudo ccat /etc/sudoers
