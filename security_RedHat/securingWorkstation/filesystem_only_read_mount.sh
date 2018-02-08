#!/bin/bash

# when a filesystem is mounted, it will be read only

# service:
systemctl status udisks2.service
● udisks2.service - Disk Manager
   Loaded: loaded (/usr/lib/systemd/system/udisks2.service; static; vendor preset: enabled)
   Active: active (running) since Mon 2018-01-15 17:20:20 CET; 1 day 19h ago
     Docs: man:udisks(8)
 Main PID: 2673 (udisksd)
   CGroup: /system.slice/udisks2.service
           └─2673 /usr/lib/udisks2/udisksd --no-debug

# edit conf file:
/etc/rules.d/80-udisks.rules

ENV{UDISKS_MOUNT_OPTIONS}="ro,noexec"
ENV{UDISKS_MOUNT_OPTIONS_ALLOW}="noexec,nodev,nosuid,atime,noatime,nodiratime,ro,sync,dirsync"

# to apply rule for existing devices:

sudo udevadm trigger

# reload rules:

sudo udevadm control --reload


