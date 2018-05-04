#!/bin/bash

# -n 15 iterations, overwriting the file with -z (zeroes):

shred -n 15 -z filename.txt

# shred is also useful for volumes (devices):
# a volume is like a file in a Linux System, whereas shred cannot be used in a folder:

shred -v -n 2 /dev/mapper/vg-local_home

