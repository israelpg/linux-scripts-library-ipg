#!/bin/bash

### 1st you must protect the BIOS with a password

### 2nd you must protect GRUB with a Password if this is used as a Boot Loader for our Linux Machine
# in both cases, if Linux is the only system, or in a dual boot config with Win:

##### red hat:
sudo /sbin/grub-md5-crypt # it generates the hashed password for GRUB

# edit the grub config file to add the password: 
vim /boot/grub/grub.conf

password --md5 <password-hash>

# secured, because:
# to enter command line before grub loads our RH, you must first press p followed by the GRUB password

# in case we have a dual boot, with a Win, we must secure that part, same in /boot/grub/grub.conf
# search for title , and add the word lock just benath it, as it is show below:
title DOS lock password --md5 <password-hash>

##### debian:
# generate hashed password:
grub-mkpasswd-pbkdf2

# then edit a custom file in the folder:
vim /etc/grub.d/40_custom

#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
# define superusers
set superusers="milosz"

#define users
password_pbkdf2 milosz grub.pbkdf2.sha512.10000.800EF[..].7977C[..]

# it is also possible to define menu entries, lock some of them, and so on, info on:
# https://blog.sleeplessbeastie.eu/2015/01/06/how-to-password-protect-grub-entries/

###########################################################

### disable PROMPT while booting the system with Interactive Session:
# this is: while the system is booting, you can press I to start an interactive session to start up each service one by one
# a hacker can get physical access to the machine, and try to press I, start Interactive session and stop or prevent security service
# then he may take control of our system ...

# prevent that PROMPT as root by adding to /etc/sysconfig/init:
PROMPT=no






