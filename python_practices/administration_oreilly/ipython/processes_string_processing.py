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

# We can obtain results in a string mode instead of list:
In [61]: processes.grep('israel').fields(0,1,8).fields(1).s
Out[61]: '717 898 1310 1354 2831 2899 2901 2909 2914 2926 2932 2934 2947 2966 3012 3018 3021 3038 3045 3050 3074 3078 3079 3081 3083 3097 3099 3106 3116 3119 3123 3127 3131 3136 3145 3147 3159 3161 3162 3163 3164 3170 3174 3177 3179 3192 3195 3197 3202 3205 3209 3210 3215 3268 3271 3277 3278 3285 3290 3295 3312 3386 3408 3455 3669 3681 3682 3685 3687 3707 3788 3792 3825 3894 3919 3925 3939 3963 3968 4315 4335 4362 4363 4482 5896 6899 7196 7680 8019 8446 9028 10112 10136 11007 11032 12309 13214 13328 13369 13438 13444 13896 15156 15763 16284 16371 17904 18482 18601 18956 19056 19059 19072 19078 20984 21731 24293 24338 24812 25276 25430 25471 25970 26352 26354 27140 27580'

# or:
processes.grep('israel').fields(1).s

# or:
processes.grep('israel', field=0).fields(1)
