#!/bin/bash

locate <filename>

# a good idea is to update locate db first, with command:

sudo updatedb /usr

# a script can do this:

updatedb_locate.sh
