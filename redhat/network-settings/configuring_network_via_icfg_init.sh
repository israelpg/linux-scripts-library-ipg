# Manual Network Configuration (instead of nmcli):

# Files under:
/etc/sysconfig/network-scripts/

# for example:
ifcfg-<name>

ifcfg-homenetwork

# For IPv4 configuration
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
PREFIX=24
IPADDR=10.0.1.27

# For IPv6 configuration
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
IPV6INIT=yes
IPV6ADDR=2001:db8::2/48

# DHCP Configuration:

DEVICE=em1
BOOTPROTO=dhcp
ONBOOT=yes

# To configure an interface to send a different host name to the DHCP server, add the following line to the ifcfg file:
DHCP_HOSTNAME=hostname

# To configure an interface to send a different fully qualified domain name (FQDN) to the DHCP server, add the following line to the ifcfg file:
DHCP_FQDN=fully.qualified.domain.name

# Note:
# Only one directive, either DHCP_HOSTNAME or DHCP_FQDN, should be used in a given ifcfg file. In case both DHCP_HOSTNAME and DHCP_FQDN are specified, only the latter is used.

# To configure an interface to use particular DNS servers, add the following lines to the ifcfg file: This will update /etc/resolv.conf
PEERDNS=no
DNS1=ip-address
DNS2=ip-address

# The permissions correspond to the USERS directive in the ifcfg files. If the USERS directive is not present, the network profile will be available to all users. 
# As an example, the following command in an ifcfg file will make the connection available only to the users listed:
USERS="joe bob alice"

# Also, you can set the USERCTL directive to manage the device:
# If you set yes, non-root users are allowed to control this device.
# If you set no, non-root users are not allowed to control this device.
