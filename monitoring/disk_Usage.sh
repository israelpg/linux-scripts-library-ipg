#!/bin/bash

# disk usage for one specific folder, let's say /mnt

du -sh /var # h is for humanized, s is for sumarize and omit subdirs, and get the sum in main folder

# but if we want to go one level down on regards a main folder:

du -sh /var/*

# with some more info, with details of content itself (not subfolders)

du -c /var # adding m for getting info in megabytes:
du -cm /var

# from / one level down:

sudo du -cm /* --max-depth=1 | sort -nrk 1 | head 2>/dev/null

# if we need to get all details, going to the latest file, use -a:

du -ah /var

# or controlling levels:

du -ah --max-depth=3 /var

# showing time as well:

du -ah --max-depth=3 --time /var

# to exclude particular files, by indicating extension, eg: .log:

du -ah --exclude=*log /root/imagefiles/

# DISK USAGE TOTAL, AND SORTED:

du -sh /* 2>/dev/null | sort -rh 





