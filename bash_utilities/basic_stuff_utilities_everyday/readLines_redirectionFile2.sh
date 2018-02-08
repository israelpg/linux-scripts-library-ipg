#!/bin/bash

File=/etc/fstab
numberLines=$(cat $File | wc -l)
echo "Number of lines: $numberLines"

for (( i=1; i<=$numberLines; i++ ))
do
lineNumber="line$i"
echo $lineNumber
{
read lineNumber
} < $File
echo "line $i in $File is: $lineNumber"
done

exit 0
