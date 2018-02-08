#!/bin/bash

echo'Files accessed within the last 7 days: '

sudo find / -maxdepth 6 -type f -atime -7 \( -iname '*.txt' -o -iname '*.pdf' \) 

echo '\n'

echo 'Directories created more than 5 days ago: '

sudo find / -maxdepth 6 -type d -ctime +5

echo '\n'

echo 'Symlinks modified more than 1 day ago: '

sudo find / -type l -mtime +1 
