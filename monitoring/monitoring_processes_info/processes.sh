#!/bin/bash

ps -ax

# same as:

ps -ef

# get a pid for an application:

pgrep firefox # gives pid, say 3265

ps -p 3265 -o comm,user,tty,pcpu,pmem

## equivalent to:
[root@02DI20161235444 ip14aai]# ps -p `pgrep firefox` -o comm,user,tty,pmem,pcpu
COMMAND         USER     TT       %MEM %CPU
firefox         ip14aai  ?         4.9  0.5

# or:
ps -C firefox -o comm,user,tty,pcpu,pmem

# or:

cat /proc/pid/comm


# more processes info can be obtained using several options, FOR INSTANCE:

ps -eo pid,comm,user,tty,pmem,stat

# OPTIONS ARE LISTED BELOW:
# pcpu
# pid (process ID)
# ppid (parent pid)
# pmem
# comm (executable filename, to identify process by its name)
# cmd (Simple command)
# user
# nice (Priority)
# time (cumulative CPU time)
# etime (elapsed time since the process started)
# tty
# euid (effective user id)
# stat (process state)

# exe info:

readlink /proc/pid/exe

# Other info available under:

/proc/pid # like cwd ... bin, mem and so on ...


# processes for one user:

ps -u israel

# for root processes:

ps -U root -u root

# A good example:

ps -U root -u root -o user,pid,comm,nice,state,tty,pmem,time| head -n 10

# SORTING, by CPU consumption:

ps -eo pid,comm,nice,pcpu,pmem,stat,tty,time --sort -pcpu | head -n 10

# getting info for a specific process passing its C command name:

ps -C puppet -o time=

# or another example:
ps -C firefox -o user=

# processes by specific tty:

ps -t tty1

# info about process threads:

ps -eLf
