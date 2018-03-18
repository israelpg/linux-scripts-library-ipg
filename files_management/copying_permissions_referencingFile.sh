#!/bin/bash

# copying file permissions to another file:

chmod --reference=1.txt 2.txt

# example:

root@israel-N56JN:/home/israel/git/workspace_linux_scripts# ls -lah *.txt
-rw-r--r-- 1 root root 0 Mär 18 18:36 1.txt
-rw------- 1 root root 0 Mär 18 18:36 2.txt
root@israel-N56JN:/home/israel/git/workspace_linux_scripts# chmod --reference=1.txt 2.txt
root@israel-N56JN:/home/israel/git/workspace_linux_scripts# ls -lah *.txt
-rw-r--r-- 1 root root 0 Mär 18 18:36 1.txt
-rw-r--r-- 1 root root 0 Mär 18 18:36 2.txt


