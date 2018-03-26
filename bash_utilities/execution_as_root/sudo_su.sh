#!/bin/bash

# We need sudo, then su superuser executes -c command ...

sudo su -c 'echo "8021q" >> /etc/modules' # this example loads a module in the kernel permanently

# to execute as another regular user:

sudo su pepe -c "touch /tmp/pepefile.txt"

# login as another user with home dir and so on:

su -l pepe

# keeping session on main user instead of the one you change to:

su pepe

