#!/bin/bash

# temp file will be deleted after rebooting the system/restart

filename=`mktemp`
echo $filename
# it will be something like: /tmp/tmp.8xvjjshF7dH --> this is the location and filename
# when working with this temp file, we can refer to it using var name

# this will also work:

filename1=$(mktemp)

# a temp dir:

dirname=`mktemp -d`
echo $dirname
# tmp.NI88s7dCVD
