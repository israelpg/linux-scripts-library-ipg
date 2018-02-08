#!/bin/bash

ldd $(which sshd)

israel@israel-N56JN:~/tests/24012018$ ldd $(which sshd)
	linux-vdso.so.1 =>  (0x00007ffcc87a7000)
	libwrap.so.0 => /lib/x86_64-linux-gnu/libwrap.so.0 (0x00007f3ea86af000)

# sshd has library libwrap.so.0, therefore it supports TCP wrappers

