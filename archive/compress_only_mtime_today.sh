#!/bin/bash

date=$(date +%d-%m-%Y)
echo $date
echo "Backup ongoing ..."
tar -cvf "$date"_bkp.tar $(find . -type f -mtime -1)
