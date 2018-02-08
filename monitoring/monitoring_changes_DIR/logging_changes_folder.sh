#!/bin/bash

# install inotify-tools

# when calling the script, we will pass a folder path as argument, which in bash is $1, if 2 arguments, then $2 as well

path=$1

# command inotifywait, -m monitoring, -r recursive to all subdirs, -e events: create, move, delete
# passing $path with option -q to reduce verbose messages:

inotifywait -m -r -e create,move,delete $path -q
