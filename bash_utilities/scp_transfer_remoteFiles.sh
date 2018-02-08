#!/bin/bash

# connecting to machine B, specified in IP, using of its users, to transfer files to your machine A

sudo scp user@IP:/pathname/filename . # transfering to your machine A in current folder you are

# or copying from remote machine to my machine:

sudo scp /toMyFolder/ user@host:/thisRemote/*.sh
