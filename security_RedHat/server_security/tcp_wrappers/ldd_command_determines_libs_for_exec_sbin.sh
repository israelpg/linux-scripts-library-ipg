#!/bin/bash

# useful for finding those .so libs associated with a daemon which has the executable under
# /usr/sbin
# eg: apache2

ldd /usr/sbin/apache2

# or for a regular command under /usr/bin
# you can mix with command which to find the executable for a command, normally in /usr/bin

israel@israel-N56JN:~/tests/24012018$ ldd /bin/echo 
	linux-vdso.so.1 =>  (0x00007ffd5b9c8000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fdfca5fa000)
	/lib64/ld-linux-x86-64.so.2 (0x000055b2bce62000)
israel@israel-N56JN:~/tests/24012018$ ldd $(which echo)
+	linux-vdso.so.1 =>  (0x00007ffc233f5000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fe5ee4c0000)
	/lib64/ld-linux-x86-64.so.2 (0x0000558e1e69d000)

