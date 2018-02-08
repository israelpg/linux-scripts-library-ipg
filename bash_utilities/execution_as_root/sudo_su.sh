#!/bin/bash

# We need sudo, then su superuser executes -c command ...

sudo su -c 'echo "8021q" >> /etc/modules' # this example loads a module in the kernel permanently

