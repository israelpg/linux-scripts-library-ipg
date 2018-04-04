#!/bin/bash
# regex:
# files are:
ls -l
createbackup.sh         list.sh         lspace.sh       speaker.sh
listopen.sh             lost.sh         rename-file.sh  topprocs.sh
# using regex patterns:
ls -l l* # list.sh, lspace.sh, listopen.sh
ls -l l?st.* # list.sh, lost.sh
ls -l ??st* # list.sh, lost.sh, listopen.sh
ls [clst]* # createbackup.sh, list.sh, lspace.sh, speaker.sh, listopen.sh, lost.sh, topprocs.sh
ls [clst][io]?t* # list.sh, listopen.sh, lost.sh

# ranges:
ls -l users[0-9].txt # users0.txt, users1.txt ...
ls -l filename_[a-cA-C]?t*.log # filename_aptitude.log, filename_Bmtmodules.log ...
ls -l filename_[a-cA-C][0-9][a-cA-C]?t*.log # filename_a9aptitude.log, filename_C5Btmodules.log ...

# to negate, use the ! in front of the regex: ![a-c] ... ![0-5] ...

# regex, uses egrep:
cat filename | egrep '[a-z]+'

