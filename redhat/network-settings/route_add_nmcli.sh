# The following line configures a route where all IPs from network 192.168.122.0 are redirected via GW 10.10.10.1 :

nmcli connection modify connection_name +ipv4.routes "192.168.122.0/24 10.10.10.1"
