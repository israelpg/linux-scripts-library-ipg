#!/bin/bash

# cutting caracters:

cut -c 5-10 thisfile.txt # from character 5 to 10 included

# cutting columns, indicating delimiter:

cut -d ' ' -s -f5 interrupt.sh # -s for not displaying lines without delimeter

[ip14aai@02di20161554187 tests]$ cut -d ' ' -s -f5-7 interrupt.sh
and script will
0 ]]


-1 ]]

[ip14aai@02di20161554187 tests]$ cut -d ' ' -s -f5,7 interrupt.sh
and will
0


-1

