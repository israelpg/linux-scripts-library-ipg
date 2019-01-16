#!/bin/bash

nmcli con show

NAME                  UUID                                  TYPE      DEVICE  
docker0               5bc3bac1-8eb9-4a68-accc-7fa4fc830b3c  bridge    docker0 
telenet-43475         2efc34e4-1cd7-45f7-8e1d-8bb54ea8a410  wifi      wlan0   
TELENETHOMESPOT       16e37d60-a7af-4d9e-a922-18b6d8d3e3d5  wifi      --      
UH Hacking Room L2TP  d850d3aa-7da2-4aec-88aa-8c6c6f7bb912  vpn       --      
Wired connection 1    c751187a-b16a-3867-bdfb-645ec78666ef  ethernet  --      
ZTE_H168N522922       aeea3edf-a9b0-46c4-89a9-c8ade637ae80  wifi      --      
telenet-43475         de2eab07-62e5-48f4-ab9e-0688db35290c  wifi      --     


nmcli conn show --active

NAME           UUID                                  TYPE    DEVICE  
docker0        5bc3bac1-8eb9-4a68-accc-7fa4fc830b3c  bridge  docker0 
telenet-43475  2efc34e4-1cd7-45f7-8e1d-8bb54ea8a410  wifi    wlan0   

# view device status:
nmcli device status

# pretty view mode:
nmcli -p device

# general status view:
nmcli general status

# other general options:
W9980173 ~ # nmcli general 
help         hostname     logging      permissions  status


nmcli con mod <network_connection_name>

#### Adding a new connection
# nmcli con add type type of the connection "con-name" connection name  ifname ifname interface-name the name of the interface ipv4 address ipv4 address gw4 address gateway address

## Checking network devices:

nmcli -t

# or:

nmcli -f DEVICE,TYPE device


### adding new connection using nmcli:

W9980173 ~ # nmcli connection add 
autoconnect  con-name     help         ifname       master       slave-type   type         
W9980173 ~ # nmcli connection add con-name test-conn 
autoconnect  ifname       master       save         slave-type   type         
W9980173 ~ # nmcli connection add con-name test-conn ifname 
docker0          enp0s25          enx9cebe87e2f9b  lo               wlp3s0           
W9980173 ~ # nmcli connection add con-name test-conn ifname enp0s25 
autoconnect  master       save         slave-type   type         
W9980173 ~ # nmcli connection add con-name test-conn ifname enp0s25 type 
adsl        bond        cdma        gsm         ip-tunnel   olpc-mesh   team        vlan        vxlan       wimax       
bluetooth   bridge      ethernet    infiniband  macvlan     pppoe       tun         vpn         wifi        
W9980173 ~ # nmcli connection add con-name test-conn ifname enp0s25 type ethernet ...


### a complete example for a static ip4 configuration:

nmcli connection add con-name testing-connection ifname enp0s25 type ethernet ip4 192.168.0.240 gw4 192.168.0.1

# then bring the new connection up:

nmcli connection up <connection_name>

# then check status:

nmcli connection show --active

nmcli device status
# nmcli -p device

# in case we don't want NetworkManager to be the first Kernel instance taking control of it:

nmcli device set <iface_name> managed no



### for a dhcp

nmcli con add type ethernet con-name my-office ifname ens3

nmcli con up my-office

$ nmcli device status
DEVICE  TYPE      STATE         CONNECTION
ens3    ethernet  connected     my-office
ens9    ethernet  disconnected  --
lo      loopback  unmanaged     --

# or: nmcli -p device


### Configuring a Dynamic Ethernet Connection

#To change the host name sent by a host to a DHCP server, modify the dhcp-hostname property:
$ nmcli con modify my-office my-office ipv4.dhcp-hostname host-name ipv6.dhcp-hostname host-name

#To change the IPv4 client ID sent by a host to a DHCP server, modify the dhcp-client-id property:
$ nmcli con modify my-office my-office ipv4.dhcp-client-id client-ID-string

# To ignore the DNS servers sent to a host by a DHCP server, modify the ignore-auto-dns property:
$ nmcli con modify my-office my-office ipv4.ignore-auto-dns yes ipv6.ignore-auto-dns yes


### setting up DNS:

# To set two IPv4 DNS server addresses:
$ nmcli con mod test-lab ipv4.dns "8.8.8.8 8.8.4.4"

# additional DNS:
nmcli con mod test-lab +ipv4.dns "8.8.8.8 8.8.4.4"


### To configure a static Ethernet connection using the interactive editor:
$ nmcli con edit type ethernet con-name ens3

===| nmcli interactive connection editor |===

Adding a new '802-3-ethernet' connection

Type 'help' or '?' for available commands.
Type 'describe [>setting<.>prop<]' for detailed property description.

You may edit the following settings: connection, 802-3-ethernet (ethernet), 802-1x, ipv4, ipv6, dcb
nmcli> set ipv4.addresses 192.168.122.88/24
Do you also want to set 'ipv4.method' to 'manual'? [yes]: yes
nmcli>
nmcli> save temporary
Saving the connection with 'autoconnect=yes'. That might result in an immediate activation of the connection.
Do you still want to save? [yes] no
nmcli> save
Saving the connection with 'autoconnect=yes'. That might result in an immediate activation of the connection.
Do you still want to save? [yes] yes
Connection 'ens3' (704a5666-8cbd-4d89-b5f9-fa65a3dbc916) successfully saved.
nmcli> quit


### Locking a Profile to a Specific Device Using nmcli

# To lock a profile to a specific interface device:
nmcli connection add type ethernet con-name connection-name ifname interface-name

# To make a profile usable for all compatible Ethernet interfaces:
nmcli connection add type ethernet con-name connection-name ifname "*"

# Note that you have to use the ifname argument even if you do not want to set a specific interface. Use the wildcard character * to specify that the profile can be used with any compatible device.
# To lock a profile to a specific MAC address:

nmcli connection add type ethernet con-name "connection-name" ifname "*" mac 00:00:5E:00:53:00


### Adding a Wi-Fi Connection with nmcli

# To view the available Wi-Fi access points:
$ nmcli dev wifi list
  SSID            MODE  CHAN  RATE     SIGNAL  BARS  SECURITY
  FedoraTest     Infra  11    54 MB/s  98      ▂▄▆█  WPA1
  Red Hat Guest  Infra  6     54 MB/s  97      ▂▄▆█  WPA2
  Red Hat        Infra  6     54 MB/s  77      ▂▄▆_  WPA2 802.1X
* Red Hat        Infra  40    54 MB/s  66      ▂▄▆_  WPA2 802.1X
  VoIP           Infra  1     54 MB/s  32      ▂▄__  WEP
  MyCafe         Infra  11    54 MB/s  39      ▂▄__  WPA2

# To create a Wi-Fi connection profile with static IP configuration, but allowing automatic DNS address assignment:
$ nmcli con add con-name MyCafe ifname wlan0 type wifi ssid MyCafe \
ip4 192.168.100.101/24 gw4 192.168.100.1

#To set a WPA2 password, for example “caffeine”:
$ nmcli con modify MyCafe wifi-sec.key-mgmt wpa-psk
$ nmcli con modify MyCafe wifi-sec.psk caffeine

# To change Wi-Fi state:
$ nmcli radio wifi [on | off ]

#Changing a Specific Property Using nmcli
#To check a specific property, for example mtu:

$ nmcli connection show id 'MyCafe' | grep mtu
802-11-wireless.mtu:                     auto

# To change the property of a setting:
$ nmcli connection modify id 'MyCafe' 802-11-wireless.mtu 1350

# To verify the change:
$ nmcli connection show id 'MyCafe' | grep mtu
802-11-wireless.mtu:                     1350
