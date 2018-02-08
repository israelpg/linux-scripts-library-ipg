#!/bin/bash

# You can combine ... du with several options: -a for all (combining everything, including subdirs), -c for total

# I prefer to use -a ... combined with -h humanized ... you can do something like:

du -ah /home/ --max-depth=1

# In case you want to exclude particular extension:

du -ah /home/ --max-depth=1 --exclude='*.img'

# Combined with find, in order to find particular files, then with xargs for compressing, deleting, or simply listing with du:

sudo find /home/ip14aai -type f -iname '*.zip' -size +10M | xargs -I {} du -ah --max-depth=1 {} | sort -nrk 1 | head -n 10
