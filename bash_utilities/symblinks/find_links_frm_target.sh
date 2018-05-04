#!/bin/bash

# the targetFile.txt is the file we are thinking may be targeted by symb links in a specific folder
# therefore, we are -L listing in a folder, -samefile, meaning it searches for symb links

sudo find -L /inThisFolder/ -samefile targetFile.txt

# example below:
# A link1 symb link in ~ folder is pointing to /tmp/target.txt file:

lrwxrwxrwx. 1 ip14aai ip14aai 15 May  2 18:11 /home/ip14aai/link1 -> /tmp/target.txt

[ip14aai@02DI20161235444 ~]$ readlink link1 
/tmp/target.txt

[ip14aai@02DI20161235444 ~]$ stat link1 
  File: ‘link1’ -> ‘/tmp/target.txt’
  Size: 15        	Blocks: 0          IO Block: 4096   symbolic link
Device: fd00h/64768d	Inode: 27142698    Links: 1
Access: (0777/lrwxrwxrwx)  Uid: ( 1000/ ip14aai)   Gid: ( 1000/ ip14aai)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2018-05-02 18:11:46.242439294 +0200
Modify: 2018-05-02 18:11:44.555439294 +0200
Change: 2018-05-02 18:11:44.555439294 +0200

# some time later, we are now checking stuff in a folder, say /tmp/ and we are see that target.txt file has a symb link pointing to it:

ip14aai@02DI20161235444 ~]$ stat /tmp/target.txt 
  File: ‘/tmp/target.txt’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 9748829     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ ip14aai)   Gid: ( 1000/ ip14aai)
Context: unconfined_u:object_r:user_tmp_t:s0
Access: 2018-05-02 18:10:42.825439294 +0200
Modify: 2018-05-02 18:10:42.825439294 +0200
Change: 2018-05-02 18:10:42.825439294 +0200

# to check what is the symb link:

sudo find -L ~ -samefile target.txt

##########################################

# automation: find all symb links to several files, not just one as before:

# created some temp files under /tmp/ folder: target1.txt, target2.txt .. up to 4 [touch /tmp/target{1,2,3,4}.txt]

# created symb links under ~/tests/
[ip14aai@02DI20161235444 tests]$ for i in {1..4}
> do
> ln -s "/tmp/target$i.txt" "link$i"
> done
[ip14aai@02DI20161235444 tests]$ ls -lah
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  180 May  3 11:46 .
drwx------. 23 ip14aai ip14aai 4.0K May  3 11:43 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
lrwxrwxrwx.  1 ip14aai ip14aai   16 May  3 11:46 link1 -> /tmp/target1.txt
lrwxrwxrwx.  1 ip14aai ip14aai   16 May  3 11:46 link2 -> /tmp/target2.txt
lrwxrwxrwx.  1 ip14aai ip14aai   16 May  3 11:46 link3 -> /tmp/target3.txt
lrwxrwxrwx.  1 ip14aai ip14aai   16 May  3 11:46 link4 -> /tmp/target4.txt
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.img

# use xargs to process file by file from /tmp/ folder, and check the find the symblinks

[ip14aai@02DI20161235444 tmp]$ sudo find . -type f | xargs -I {} find -L /home/ip14aai/tests/ -samefile {}
[sudo] password for ip14aai: 
/home/ip14aai/tests/link2
/home/ip14aai/tests/link3
/home/ip14aai/tests/link4
/home/ip14aai/tests/link1
