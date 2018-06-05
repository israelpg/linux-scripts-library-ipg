#!/bin/bash

# PAM.D module is useful for:
# 1. User login definition complementing /etc/login.defs
# 
# 2. Defining access control as a security layer: system-auth, sshd: Using libraries .so
#    Filtering access for network, user, service ... in combination with: /etc/security/{access,limits,time}.conf
#
# 3. /etc/pam.d/login can define that a user gets inactive after n days # individual basis using chage or passwd commands
#
# 4. /etc/pam.d/passwd can define more rules than /etc/login.defs for password definitions, again, chage or passwd for individual basis 
