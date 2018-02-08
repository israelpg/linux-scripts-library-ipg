#!/bin/bash

read -p "used space is: " used_space

case $used_space in
  [1-9]|[1-7][0-9]|8[0-4]) # range 1-84
    echo "OK - $used_space% of disk space used."
    exit 0
    ;;
  85)
    echo "WARNING - $used_space% of disk space used."
    exit 1
    ;;
  8[6-9]|9[0-9]|100)        # range 86-100
    echo "CRITICAL - $used_space% of disk space used."
    exit 2
    ;;
  *)
    echo "$used_space% of disk space used."
    exit 3
     ;;
esac
