#!/bin/bash

var1=/tmp/pepito

echo 'This is a test' > $var1

# now doing this:

cat /tmp/pepito # returns 'This is a test'. We have referenced a file with a variable.
