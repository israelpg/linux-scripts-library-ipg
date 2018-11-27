#### SELINUX : Security Layer
# This is a systemctl service which can be enabled or disabled
# And it has two possible modes: Enforcing | Permissive
# When system is installing for first time, it is in Permissive, once finished, it changes to Enforcing

# Checking current SELINUX status:

[root@s999lnx81 ~]# getenforce

Disabled


# To change state:

setenforce Enforcing


# To permanently apply changes use the config file:

[root@s999lnx81 ~]# cat /etc/selinux/config

# This file controls the state of SELinux on the system.

# SELINUX= can take one of these three values:

#       enforcing - SELinux security policy is enforced.

#       permissive - SELinux prints warnings instead of enforcing.

#       disabled - SELinux is fully disabled.

SELINUX=disabled

# SELINUXTYPE= type of policy in use. Possible values are:

#       targeted - Only targeted network daemons are protected.

#       strict - Full SELinux protection.

SELINUXTYPE=targeted

 

# SETLOCALDEFS= Check local definition changes

SETLOCALDEFS=0
