#!/bin/bash

# lock control
script_name=$(basename -- "$0")

if pidof -x "$script_name" -o $$ >/dev/null;then
   echo "Another instance of this script is already running"
   exit 1
fi
