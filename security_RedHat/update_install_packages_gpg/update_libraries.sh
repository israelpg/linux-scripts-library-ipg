#!/bin/bash

# In case a library needs to be updated (package), we want to check first for open apps which are currently using it, and halt them:
# example: libwrap library has this .so file --> /lib64/libwrap.so (which use TCP wrappers for host access control)

sudo lsof /lib64/libwrap.so.0.7.6

COMMAND    PID    USER  FD   TYPE DEVICE SIZE/OFF   NODE NAME
auditd     632    root mem    REG  253,0    42520 109283 /usr/lib64/libwrap.so.0.7.6
gnome-set 3091 ip14aai mem    REG  253,0    42520 109283 /usr/lib64/libwrap.so.0.7.6
pulseaudi 3104 ip14aai mem    REG  253,0    42520 109283 /usr/lib64/libwrap.so.0.7.6
gnome-she 3164 ip14aai mem    REG  253,0    42520 109283 /usr/lib64/libwrap.so.0.7.6
firefox   3826 ip14aai mem    REG  253,0    42520 109283 /usr/lib64/libwrap.so.0.7.6

# Therefore, halt firefox and the rest of applications using this lib, then update the library, and there you go ...
# eg: kill firefox
sudo kill -9 3826 # pid: 3826

# check the package name for this library:
[ip14aai@localhost tests]$ rpm -qf /lib64/libwrap.so.0.7.6
tcp_wrappers-libs-7.6-77.el7.x86_64

# perform update checking hash for GPG signature:
sudo rpm- Uvh /lib64/tcp_wrappers-libs-7.6-77.el7.x86_64
