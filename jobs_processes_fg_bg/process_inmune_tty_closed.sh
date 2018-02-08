#!/bin/bash

# Example: You need to run a process which takes longer than expected, and you might close tty, to make process inmune:

nohup ping -5 10.57.122.74 &
