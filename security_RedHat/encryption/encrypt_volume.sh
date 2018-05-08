#!/bin/bash

# Encrypt a partition already in use, eg: /home/ --- ATTENTION: Data will be overwritten !!! (shred is used)

# 1. Change runlevel from default 5 (graphical target) to 1 (rescue mode):
# check current runlevel:
[ip14aai@02DI20161235444 ~]$ runlevel
N 5
# or:
[ip14aai@02DI20161235444 ~]$ systemctl get-default 
graphical.target
# set runlevel 1:
[ip14aai@02DI20161235444 ~]$ sudo telinit 1
# or:
[ip14aai@02DI20161235444 ~]$ systemctl isolate runlevel1.target 

# 2. umount the /home/ dir:
# but first note the device /dev related with the partition for /home:
ls -l /dev/mapper | grep home
df -h | grep home
findmnt | grep home
#
sudo umount /home
# if this step fails, probably is because files are opened and in use for this mounted dev, kill all with fuser:
# -m files mounted , -v verbose, -k kill !!!
sudo fuser -mvk /home

# 3. Check that partition is no longer mounted as home:
df -h
findmnt
cat /proc/mounts

#### NOTE: Now instead of working with target home, we directly work with the related device /dev/
# Normally: /dev/mapper

# 4. Fill in partition with random data using shred command: (This erases all existing data in this device!!!!!!!)

shred -v -n 1 /dev/VG00/LV_home
# or remove data: -z
shred -v -n 1 -z /dev/VG00/LV_home

# 5. Initialize device as encrypted LUKS volume which will use a passphrase:

cryptsetup --verbose --verify-passphrase luksFormat /dev/VG00/LV_home

# 6. Open the newly LUKS encrypted device with a mapping name /dev/mapper (home):

cryptsetup luksOpen /dev/VG00/LV_home home

# 7. Make sure the device mapping name home is present in the /dev/mapper:

ls -l /dev/mapper | grep home
## right, now we can work directly with the mapping name instead of device name

# 8. Create a filesystem (eg: ext3) in this device:

mkfs.ext3 /dev/mapper/home

# 9. Mount the filesystem:

mount /dev/mapper/home /home

df -h | grep home

# 10. Add line to /etc/crypttab file: (this file is empty if no encrypted devices are defined and in use)
#     This line ensures that passphrase is requested when opening volume (use device name not mapper)

home /dev/VG00/LV_home none

# 11. Add line to /etc/fstab to mount the device mapper with each boot:

/dev/mapper/home /home ext3 defaults 1 2

# 12. Restore default SELinux security contexts:
# This program is primarily used to set the security context (extended attributes) on one or more files.

/sbin/restorecon -v -R /home

# 13. Reboot the machine:

shutdown -r now

# 14. /etc/crypttab entry makes your computer ask your luks passphrase on boot.

# 15. Log in as root and restore your backup.

## ADDING A NEW PASSPHRASE TO AN EXISTING ENCRYPTED DEVICE:

cryptsetup luksAddKey <device>
# type current passwd, then type new passwd
# example:
cryptsetup luksAddKey /dev/VG00/LV_home # logically, this info concerning device name can be checked in the /etc/crypttab file, or checking
# mounted device: df -h

## REMOVING A PASSPHRASE FROM AN ALREADY ENCRYPTED DEVICE:

cryptsetup luksRemoveKey <device>


