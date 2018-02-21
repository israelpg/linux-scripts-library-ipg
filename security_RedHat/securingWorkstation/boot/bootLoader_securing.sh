#!/bin/bash

### 1st you must protect the BIOS with a password

### 2nd you must protect GRUB with a Password if this is used as a Boot Loader for our Linux Machine 
# in two cases, if machine is only system or in a dual boot config with Win:
sudo /sbin/grub-md5-crypt # it generates the hashed password for GRUB
# edit the grub config file to add the password: /boot/grub/grub.conf:
password --md5 <password-hash>

# in red hat: /usr/sbin/grub2-setpassword:
sudo grub-setpassword # — Generate the user.cfg file containing the hashed grub bootloader password.

# secured, because:
# to enter command line before grub loads our RH, you must first press p followed by the GRUB password

# in case we have a dual boot, with a Win, we must secure that part, same in /boot/grub/grub.conf
# search for title , and add the word lock just benath it, as it is show below:
title DOS
lock
# but bear in mind, this only works in combination with a password line (with hash) / see above

# you can add specific password for Win adding its own password --md5 <password-hash> line

### disable PROMPT while booting the system with Interactive Session:
# this is: while the system is booting, you can press I to start an interactive session to start up each service one by one
# a hacker can get physical access to the machine, and try to press I, start Interactive session and stop or prevent security service
# then he may take control of our system ...
# prevent that PROMPT as root by adding to /etc/sysconfig/init:
PROMPT=no






