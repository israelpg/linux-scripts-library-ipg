#!/bin/bash

# connect to a server which uses a specific port, eg: 422

sudo ssh username@hostname -p 422

# running commands in the server but displaying output in your machine acting as a terminal:

sudo ssh username@hostname 'ls -lah ~/pruebas/scripts'

sudo ssh ip14aai@10.57.122.196 "echo user: $(whoami) ; echo OS: $(uname)"

# possible to connect with compression capabilities:

sudo ssh -C user@host
