#!/bin/bash

# cutting caracters:

cut -c 5-10 thisfile.txt # from character 5 to 10 included

# cutting columns, not indicating delimiter, default is tab space:
cat /tmp/prueba.txt | cut -f2
#or:
cut -f2 /tmp/prueba.txt

# cutting columns, indicating delimiter:

# example 1: var1="34%56"
echo $var1 | cut -d % -f1 # 34
echo $var1 | cut -d % -f2 # 56

#example 2:

cut -d ' ' -s -f5 interrupt.sh # -s for not displaying lines without delimeter

[ip14aai@02di20161554187 tests]$ cut -d ' ' -s -f5-7 interrupt.sh
and script will
0 ]]


-1 ]]

[ip14aai@02di20161554187 tests]$ cut -d ' ' -s -f5,7 interrupt.sh
and will
0


-1

