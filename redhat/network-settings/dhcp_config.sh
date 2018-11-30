# For instance, setting up of the timeout (default is 60 seconds)

nmcli connection modify <connection_name> ipv4.dhcp-timeout: 10

# In this case, if cannot connect in 10 seconds, it will try IPV6 config, as long as property ipv4.may-fail: yes
# Otherwise, connection fails

# To check all properties / values for a specific connection_name :

israel@W9980173 ~/git/workspace_linux_scripts/redhat $ nmcli connection show 
--active                 docker0                  id                       path                     Wired\ connection\ 1     Wireless\ Internet\ PDA  
apath                    help                     --order                  uuid                     Wired\ connection\ 2     
israel@W9980173 ~/git/workspace_linux_scripts/redhat $ nmcli connection show Wired\ connection\ 2
connection.id:                          Wired connection 2
connection.uuid:                        6b1fceef-0bd9-3815-b7cd-50bb13c982d5
connection.interface-name:              --
connection.type:                        802-3-ethernet
connection.autoconnect:                 yes
connection.autoconnect-priority:        -999
connection.timestamp:                   1543584428
connection.read-only:                   no
connection.permissions:                 
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 
connection.gateway-ping-timeout:        0
connection.metered:                     unknown
connection.lldp:                        -1 (default)
802-3-ethernet.port:                    --
802-3-ethernet.speed:                   0
802-3-ethernet.duplex:                  --
802-3-ethernet.auto-negotiate:          yes
802-3-ethernet.mac-address:             9C:EB:E8:7E:2F:9B
802-3-ethernet.cloned-mac-address:      --
802-3-ethernet.mac-address-blacklist:   
802-3-ethernet.mtu:                     auto
802-3-ethernet.s390-subchannels:        
802-3-ethernet.s390-nettype:            --
802-3-ethernet.s390-options:            
802-3-ethernet.wake-on-lan:             1 (default)
802-3-ethernet.wake-on-lan-password:    --
ipv4.method:                            auto
ipv4.dns:                               
ipv4.dns-search:                        
ipv4.dns-options:                       (default)
ipv4.dns-priority:                      0
ipv4.addresses:                         
ipv4.gateway:                           --
ipv4.routes:                            
ipv4.route-metric:                      -1
ipv4.ignore-auto-routes:                no
ipv4.ignore-auto-dns:                   no
ipv4.dhcp-client-id:                    --
ipv4.dhcp-timeout:                      0
ipv4.dhcp-send-hostname:                yes
ipv4.dhcp-hostname:                     --
ipv4.dhcp-fqdn:                         --
ipv4.never-default:                     no
ipv4.may-fail:                          yes
ipv4.dad-timeout:                       -1 (default)
ipv6.method:                            auto
ipv6.dns:                               
ipv6.dns-search:                        
ipv6.dns-options:                       (default)
ipv6.dns-priority:                      0
ipv6.addresses:                         
ipv6.gateway:                           --
ipv6.routes:                            
ipv6.route-metric:                      -1
ipv6.ignore-auto-routes:                no
ipv6.ignore-auto-dns:                   no
ipv6.never-default:                     no
ipv6.may-fail:                          yes
ipv6.ip6-privacy:                       -1 (unknown)
ipv6.addr-gen-mode:                     stable-privacy
ipv6.dhcp-send-hostname:                yes
ipv6.dhcp-hostname:                     --
GENERAL.NAME:                           Wired connection 2
GENERAL.UUID:                           6b1fceef-0bd9-3815-b7cd-50bb13c982d5
GENERAL.DEVICES:                        enx9cebe87e2f9b
GENERAL.STATE:                          activated
GENERAL.DEFAULT:                        yes
GENERAL.DEFAULT6:                       no
GENERAL.VPN:                            no
GENERAL.ZONE:                           --
GENERAL.DBUS-PATH:                      /org/freedesktop/NetworkManager/ActiveConnection/27
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/Settings/9
GENERAL.SPEC-OBJECT:                    /
GENERAL.MASTER-PATH:                    --
IP4.ADDRESS[1]:                         10.100.2.96/22
IP4.GATEWAY:                            10.100.3.254
IP4.ROUTE[1]:                           dst = 10.198.226.211/32, nh = 10.100.3.254, mt = 100
IP4.DNS[1]:                             10.198.205.1
IP4.DNS[2]:                             10.198.206.221
IP4.DNS[3]:                             10.198.205.2
IP4.DNS[4]:                             10.198.206.222
IP4.DOMAIN[1]:                          mutworld.be
IP4.WINS[1]:                            10.198.205.1
IP4.WINS[2]:                            10.198.206.221
DHCP4.OPTION[1]:                        requested_subnet_mask = 1
DHCP4.OPTION[2]:                        requested_rfc3442_classless_static_routes = 1
DHCP4.OPTION[3]:                        subnet_mask = 255.255.252.0
DHCP4.OPTION[4]:                        domain_name_servers = 10.198.205.1 10.198.206.221 10.198.205.2 10.198.206.222
DHCP4.OPTION[5]:                        ip_address = 10.100.2.96
DHCP4.OPTION[6]:                        requested_static_routes = 1
DHCP4.OPTION[7]:                        dhcp_server_identifier = 10.198.226.211
DHCP4.OPTION[8]:                        netbios_name_servers = 10.198.205.1 10.198.206.221
DHCP4.OPTION[9]:                        requested_time_offset = 1
DHCP4.OPTION[10]:                       broadcast_address = 10.100.3.255
DHCP4.OPTION[11]:                       requested_interface_mtu = 1
DHCP4.OPTION[12]:                       dhcp_rebinding_time = 151200
DHCP4.OPTION[13]:                       requested_domain_name_servers = 1
DHCP4.OPTION[14]:                       dhcp_message_type = 5
DHCP4.OPTION[15]:                       requested_broadcast_address = 1
DHCP4.OPTION[16]:                       routers = 10.100.3.254
DHCP4.OPTION[17]:                       dhcp_renewal_time = 86400
DHCP4.OPTION[18]:                       requested_domain_name = 1
DHCP4.OPTION[19]:                       domain_name = mutworld.be
DHCP4.OPTION[20]:                       requested_routers = 1
DHCP4.OPTION[21]:                       expiry = 1543741460
DHCP4.OPTION[22]:                       requested_wpad = 1
DHCP4.OPTION[23]:                       requested_netbios_scope = 1
DHCP4.OPTION[24]:                       requested_ms_classless_static_routes = 1
DHCP4.OPTION[25]:                       requested_netbios_name_servers = 1
DHCP4.OPTION[26]:                       network_number = 10.100.0.0
DHCP4.OPTION[27]:                       requested_domain_search = 1
DHCP4.OPTION[28]:                       next_server = 0.0.0.0
DHCP4.OPTION[29]:                       ntp_servers = 10.198.205.1 10.198.205.2 10.198.205.1 10.198.205.2
DHCP4.OPTION[30]:                       dhcp_lease_time = 172800
DHCP4.OPTION[31]:                       requested_host_name = 1
DHCP4.OPTION[32]:                       requested_ntp_servers = 1
IP6.ADDRESS[1]:                         fe80::a57d:4133:35a2:af2/64
IP6.GATEWAY:                            


##### To make the retry DHCP IPV4 persistent, add value "infinity"

nmcli connection modify <connection_name> ipv4.dhcp-timeout: infinity

### NetworkManager will retry until it gets a lease from dhcp server ... in the process, we can avoid not having any IP at all, by setting:

nmcli connection modify <connection_name> ipv4.address 192.168.1.25
# You won't have full connectivity, like Internet access, but you are still in the IP range within the Network for other services, kept alive.
