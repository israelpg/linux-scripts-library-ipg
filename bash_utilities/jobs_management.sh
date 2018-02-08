#!/bin/bash

# an example of a job running in the background:

sleep 200 &

jobs -l

# [1] is for element 1 of the jobs list

# focus in that job means to see its execution:

fg %1

# bringing it back to background:

bg %1

# killing a job ... well, kill a process mate:

kill -9 <pid>
