#!/bin/bash

# hard link is literally a copy of the original file, with the same inode, you remove one, you have the other one:
ln thisFile hardlink

# symb link, is simply a link:
ln -s thisFile symbLink

# in case the link exists, recreate with:
ln -sf thisFile symbLink

