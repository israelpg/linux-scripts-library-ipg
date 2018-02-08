#!/bin/bash

# list the shell var options (on/off):

set -o

# if on, then unset: eg: history

set +o history

# set again:

set -o history
