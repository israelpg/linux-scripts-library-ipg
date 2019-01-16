# Enable or disable Multicast with IGMP

# The Internet Group Management Protocol (IGMP) enables the administrator to manage routing and subscription to multicast traffic between networks, hosts, 
# and routers. The kernel in Red Hat Enterprise Linux supports IGMPv3.

# To display multicast information, use the ip maddr show subcommand, for example:

israel@W9980173 ~/Downloads $ ip maddress show dev enp0s25
2:	enp0s25
	link  01:00:5e:00:00:01
	inet  224.0.0.1
	inet6 ff02::1
	inet6 ff01::1

israel@W9980173 ~/Downloads $ ip link show dev enp0s25 
2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
    link/ether 3c:97:0e:a3:d7:a2 brd ff:ff:ff:ff:ff:ff

# You can shee that there is an specification to MULTICAST in the properties line, to disable:

ip link set multicast off dev enp0s25

# to enable again:

ip link set multicast on dev enp0s25

### Checking the addresses subscribed for Multicasting:

cat /proc/net/igmp

W9980173 ~ # cat /proc/net/igmp
Idx	Device    : Count Querier	Group    Users Timer	Reporter
1	lo        :     1      V3
				010000E0     1 0:00000000		0
2	enp0s25   :     1      V3
				010000E0     1 0:00000000		0
4	enx9cebe87e2f9b:     2      V3
				010000E0     1 0:00000000		0
				FB0000E0     6 0:00000000		0
5	docker0   :     2      V3
				FB0000E0     3 0:00000000		0
				010000E0     1 0:00000000		0
9	vetha960db8:     1      V3
				010000E0     1 0:00000000		0
