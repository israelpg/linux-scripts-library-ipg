sudo apt-get install vlan

# check for module 8021q, standard for VLAN:

lsmod | grep '8021q'

# add module vlan to kernel if not loaded already
sudo modprobe 8021q

# create vlan over physical enp0s3, called: enp0s3.100

sudo vconfig add enp0s3 100

# assign an address to the new interface vlan: better to update interfaces file!!!

sudo ip addr add 192.168.56.110/24 dev enp0s3.100

# another option:
sudo ifconfig enp0s3.100 192.168.56.110 netmask 255.255.255.0 broadcast 192.168.56.255

# make it permanent on kernel boot:

sudo su -c 'echo "8021q" >> /etc/modules'

# create interface: /etc/network/interfaces
# dynamic:
auto enp0s3.100
iface enp0s3.100 inet dhcp
	vlan-raw-device enp0s3
# static:
auto enp0s3.100
iface enp0s3.100 inet static
	vlan-raw-device enp0s3
	address 192.168.56.110
	netmask 255.255.255.0

# to check details:

ifconfig enp0s3.100

# or:

cat /proc/net/vlan/enp0s3.100

# to remove a vlan:

sudo ifconfig enp0s3.100 down

sudo vconfig rem enp0s3.100

