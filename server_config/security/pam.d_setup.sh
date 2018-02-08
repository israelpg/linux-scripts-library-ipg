#!/bin/bash

# defining password policy and security concerns in:

ls /etc/pam.d

# common-password, for instance



# something interesting is about ssh connections allowed in the system, for instance for a particular user when using putty,
# limit number of sessions

nano -c /etc/pam.d/sshd

# here we cannot apply the changes directly ... but it refers to different files where we can perform several actions, for instance:
# limiting sessions is done via /etc/security/limits.conf

nano -c /etc/security/limits.conf

username maxlogins 1
# or by group:
@groupname maxlogins 4 # notice the @ in front!

# also how many files a user can open, etc ...


# concerning login, we can disable logins other than root in the system: just create file:

touch /etc/nologin # as indicated in /etc/pam.d/login


# or using a file which contains a list of names not allowed to login: /etc/security/limits.conf:

auth required pam listfile.so item=user sense=deny file=/etc/ssh/sshd.deny onerr=succeed
# file /etc/ssh/ssd.deny (add usernames which cannot access the system via ssh, which is limited to access/login)



# SUMMARY: With some examples/scenarios:

# I have a server, and I want only a few users to be able to login via ssh:
# create one group: sshlogin, and then edit /etc/ssh/sshd_config (adding line AllowGroups sshlogin
# users that can access should be added to that group

# We can also use the login within /etc/pam.d/login ... well, it refers to: /etc/security/limits.con, then create a file with users list

# If we want only root to login: touch /etc/nologin

# We want to limit number of logins per user: /etc/security/limits.conf
# same file to edit for limiting number of files open per user



