#!/bin/bash

# -b for taking snapshot, -n 1 for taking just one:

top -b -n 1 > top_snapshot.log

# from a specific process only:

top -p 3258 -b -n 1 > top_pid_3258.log

# a script can be created to monitor activity of this process in a sequence:

for i in {1..4}
do
	sleep 2 && top -p 3258 -b -n 1 | tail -1 > 3258_activity.log
done
