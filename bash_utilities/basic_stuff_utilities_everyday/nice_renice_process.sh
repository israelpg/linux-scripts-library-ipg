#!/bin/bash

# to check the niceness of processes, for instance the top 5 in mem consumption:
[ip14aai@localhost arrays]$ ps -eo comm,tty,user,pcpu,pmem,ni --sort -pmem | head -n 5
COMMAND         TT       USER     %CPU %MEM  NI
firefox         ?        ip14aai  18.8  9.7 -10
gnome-shell     ?        ip14aai   3.6  7.0   0
Xorg            tty1     root      4.4  3.3   0
evolution-calen ?        ip14aai   0.0  1.2   0

# to start a process / app with a defined niceness, say gedit with -20 (max):
sudo nice -n -20 gedit # from -20 (most favourable setting to 19 less favourable)
# nice goes from -19 to 20 ... (max priority/less nice for processor that must work harder, to less priority, nicer for processor)

# renice:
#EXAMPLES
sudo renice 5 <pid>

# if firefox is pid: 4099
[ip14aai@localhost arrays]$ sudo renice -10 -p 4099

#The following command would change the priority of the processes with PIDs 987 and 32, plus all processes owned by the users daemon and root:
renice +1 987 -u daemon root -p 32

