#!/bin/bash

sudo umount -a -f /mnt/loopback

# or try this if busy:

lsof | grep '/mnt/loopback' # we get the pid

sudo kill -9 pid

sudo umount -a /mnt/loopback
