# For instance: Printing the pid(s) for user israel:

ps -aux | awk '{if ($1 == "israel") print $2}'

processes = !ps -aux
# print all processes by typing: processes
# using built-in function grep:
processes.grep('gnome')

# to grep excluding a particular word use prune=True:
processes.grep('firefox', prune=True)

In [298]: topprocesses=!ps -eo comm,user,tty,pcpu,pmem --sort=-pmem | head -n 10

In [299]: topprocesses.grep('firefox', prune=True)
Out[299]:
['COMMAND         USER     TT       %CPU %MEM',
 'gnome-shell     gdm      tty1      0.0 17.4',
 'Web Content     israel   tty2      0.5  3.8',
 'gnome-shell     israel   tty2      2.8  3.2',
 'brave           israel   tty2      0.4  2.7',
 'Web Content     israel   tty2      0.1  2.3',
 'Web Content     israel   tty2      0.2  2.2',
 'brave           israel   tty2      1.5  2.0',
 'brave           israel   tty2      0.2  1.6']

# notice how it looks if we don't exclude firefox:
In [304]: !ps -eo comm,user,tty,pcpu,pmem --sort=-pmem | head -n 10
COMMAND         USER     TT       %CPU %MEM
gnome-shell     gdm      tty1      0.0 17.4
Web Content     israel   tty2      0.5  3.8
gnome-shell     israel   tty2      2.8  3.2
firefox         israel   tty2      0.7  2.7
brave           israel   tty2      0.4  2.7
Web Content     israel   tty2      0.1  2.3
Web Content     israel   tty2      0.2  2.2
brave           israel   tty2      1.5  2.0
brave           israel   tty2      0.2  1.6

# Filtering specific fields:
In [337]: processes.grep('israel').fields(0, 1, 8)
Out[337]:
['israel 821 Sep17',
 'israel 1046 09:38',
 'israel 1082 09:38',
 'israel 1958 Sep16',
 'israel 2000 Sep16',

