#!/bin/bash

File=/etc/fstab

{
read line1
read line2
} < $File

echo "line 1 in $File is: $line1"
echo "line 2 in $File is: $line2"

exit 0
