#!/bin/bash

# LSOF: To list open files by processes

# 1. Check who has a file opened (sometimes useful if it blocks an execution or service):

lsof <filename>

# 2. Check all open files by a process (PID):

lsof -p `pgrep firefox`

# 3. Listing logs, or so libraries, and so on for a specific process:

lsof -p <pid> | grep '*.log'
lsof -p <pid> | grep '*.so'
lsof -p <pid> | grep 'bin'

# 4. Listing open files by one specific user:

lsof -u <username>

# 5. Network Monitoring:

lsof -i :80 # monitors port 80

lsof -i tcp
lsof -i udp

# No matter the port ... or the protocol, just Internet file type:

lsof -i -P
