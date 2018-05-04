#!/bin/bash

# hard link is literally a copy of the original file, with the same inode, you remove one, you have the other one:
ln thisFile hardlink

# symb link, is simply a link:
ln -s thisFile symbLink

# in case the link exists, recreate with:
ln -sf thisFile symbLink

## searching for the symb link of a specific file, in case it has a symb link:

[ip14aai@02DI20161235444 ~]$ ls -lah | grep '^l'
lrwxrwxrwx.  1 ip14aai ip14aai   15 May  2 18:11 link1 -> /tmp/target.txt
[ip14aai@02DI20161235444 ~]$ readlink link1 
/tmp/target.txt
[ip14aai@02DI20161235444 ~]$ cd /tmp/
[ip14aai@02DI20161235444 tmp]$ sudo find -L . -samefile target.txt
./target.txt
