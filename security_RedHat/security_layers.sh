#!/bin/bash

# incoming requests:

1st layer: Firewall

2nd layer: TCP Wrappers

3rd layer: PAM module : system-auth, sshd --> /etc/security/access.conf limits.conf time.conf

4th layer: xinetd

