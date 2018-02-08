#!/bin/bash

sudo apt-get install iotop

# only active processes are monitored
sudo iotop -o 

# if we need to specify just a process
sudo iotop -p <pid> # get the pid doing: pgrep 'firefox'

