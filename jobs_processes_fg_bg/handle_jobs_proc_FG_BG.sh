#!/bin/bash

# an example of executing a process is:

ping -i 5 10.57.122.74

# this is executed in the foreground ... it can be cancelled: Ctrl+C, or paused/stopped with Ctrl+Z

# if Stopped ... then it can be moved to BG background:

# list jobs:

jobs -l

# move to BG

bg %2 # if job is ID number 2

# move again to FG

fg %2

# to kill or cancel the process/job:

kill %2
