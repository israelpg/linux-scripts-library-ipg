#!/bin/bash

# Check if the module for USB drivers is loaded in the lsmod modules list:

lsmod | grep 'usb_storage'
lsmod | grep 'uas'

sudo modprobe -r usb_storage
sudo modprobe -r uas

# Next, list the content of the current runtime kernel usb storage modules directory by issuing the below command:

cd /lib/modules/`uname -r`/kernel/drivers/usb/storage
mv usb-storage.ko usb-storage.ko.blacklist



