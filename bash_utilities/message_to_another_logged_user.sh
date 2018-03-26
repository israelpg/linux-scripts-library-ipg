#!/bin/bash

w
# or who to see list of logged in users

write <username> <terminal> # press Ctrl+D after typing the message

write username pts/2 # Ctrl+D

[root@02DI20161235444 workspace_linux_scripts]# w
 16:35:12 up  7:05,  2 users,  load average: 0.06, 0.14, 0.10
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
ip14aai  :0       :0               09:30   ?xdm?   7:17   0.31s gdm-session-worker [pam/gdm-password]
ip14aai  pts/0    :0               09:30    0.00s  1.56s 27.92s /usr/libexec/gnome-terminal-server
[root@02DI20161235444 workspace_linux_scripts]# write ip14aai pts/0

Message from ip14aai@02DI20161235444 (as root) on pts/0 at 16:35 ...
this is a test message ... to myself, anyway, just testing # sending this message

this is a test message ... to myself, anyway, just testing # I have received it myself

EOF # after typing Ctrl+D ... EOF

