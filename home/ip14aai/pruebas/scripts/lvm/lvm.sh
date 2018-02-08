#!/bin/bash

# Scenario:
# adding a .vdi or .vdmk disk in a virtual machine, to extract data (instead of using PowerISO tool in Win)
# we mount the disk which is recognized as LVM, instead of ext3 or ext4:

sudo apt-get install lvm2
# detect lvm partitions
sudo pvscan
# scan for lvm volume group(s)
sudo vgscan
# activate lvm volume group(s)
sudo vgchange -ay
# now should be available, check for available lvm:
sudo lvscan
# may be mounted if needed:
sudo mount /dev/sd*/log_vol /mnt/<mount-point>
