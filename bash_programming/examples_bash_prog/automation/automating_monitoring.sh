#!/bin/bash
# Sample script written for Part 4 of the RHCE series
# This script will return the following set of system information:
# -Hostname information:
echo -e "\e[31;22m***** HOSTNAME INFORMATION *****\e[0m"
hostnamectl
echo ""
# -File system disk space usage:
echo -e "\e[31;22m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
df -h
echo ""
# -Free and used memory in the system:
echo -e "\e[31;22m ***** FREE AND USED MEMORY *****\e[0m"
free -m
echo ""
# -System uptime and load:
echo -e "\e[31;22m***** SYSTEM UPTIME AND LOAD *****\e[0m"
uptime
echo ""
# -Logged-in users:
echo -e "\e[31;22m***** CURRENTLY LOGGED-IN USERS *****\e[0m"
w
echo ""
# -Top 5 processes as far as memory usage is concerned
echo -e "\e[31;22m***** TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
ps -eo pmem,pcpu,comm,tty,user --sort=-pmem | head -n 6
# or using the line below with similar output:
#ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
echo ""
echo -e "\e[31;22m***** TOP 5 BIGGEST FILES IN /HOME/$USER FOLDER *****\e[0m"
sudo find /home/$USER -type f -size +1M | xargs -I {} du -ah {} | sort -nrk 1 | head -n 5
echo ""
echo -e "\e[1;32mDone.\e[0m"

