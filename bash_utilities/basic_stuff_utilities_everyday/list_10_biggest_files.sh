#!/bin/bash

# -a to count all, subdirs and files
# -m in Megabytes

sudo du -am ~/pruebas | sort -nrk 1 | head -n 10
