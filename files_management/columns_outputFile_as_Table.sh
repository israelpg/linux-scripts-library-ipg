#!/bin/bash

getent passwd > passwdFile.txt

# -t as table, -s as separator/delimiter:

cat passwdFile.txt | grep -t -s ':'

...
uuidd              x  100    101    /run/uuidd                          /bin/false
_apt               x  120    65534  /nonexistent                        /bin/false
libvirt-qemu       x  121    133    Libvirt Qemu,,,                     /var/lib/libvirt            /bin/false
libvirt-dnsmasq    x  122    134    Libvirt Dnsmasq,,,                  /var/lib/libvirt/dnsmasq    /bin/false
vnstat             x  123    135    /var/lib/vnstat                     /bin/false
pepe               x  1002   1002   /home/pepe                          /bin/bash
sshd               x  124    65534  /var/run/sshd                       /usr/sbin/nologin
...

# or better using the command column after another one:

getent passwd | column -t -s ':'

# another example:

mount | column -t # similar output than findmnt
