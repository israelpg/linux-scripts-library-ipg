#!/bin/bash

# as root:

dd if=/dev/zero of=/home/swapfile bs=1024 count=1048576

mkswap /home/swapfile
swapon /home/swapfile
swapon -a

# Make it permanent with each boot, edit /etc/fstab (but first create a bkp copy)
echo '/home/swapfile swap swap defaults 0 0' >> /etc/fstab

exit # root
swapon -s # to verify, also check (cat /proc/meminfo | grep -i swap)




