#!/bin/bash

# Date: 21/11/2017
# Author: Israel Palomino Garcia
# Version: 1.0
# Description: Automation of perfomance monitoring in localhost

# if script encounters an error, it will exit 1
set -o errexit

# unset any variable which system may be using concerning this script:
unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

while getopts ihv name
       do
              case $name in
              i)iopt=1;;
	      h)hopt=1;;
              v)vopt=1;;
              *)echo "Invalid argument when calling the script, pass -i (install) -v (version) or -h (help)" ; exit 1;;
              esac
       done

# checking if -i argument has been passed when calling the script for installation:
if [[ ! -z $iopt ]] # iopt not empty: -i has been passed as argument
then
	if [ -f /usr/bin/$0 ] # if the file does not exist, has not been installed, proceeding:
	then
            	echo "Script $0 is already installed in this host. Run with command: ipgmonitoring"
	else
		scriptname=$0
                su -c "cp $scriptname /usr/bin/$0" root &&
               	echo "Script $0 installed, run with command: ipgmonitoring" || echo "Error while installing" ; exit 1
	fi
fi

# if argument -h has been passed when calling the script, then help is provided
if [[ ! -z $hopt ]]
then
    	echo "Installation with argument -i: ipgmonitoring -i"
    	echo "Script Version with argument -v: ipgmonitoring -v"
	echo -e "Run the script with command: ipgmonitoring if already installed, otherwise ./ipgmonitoring.sh or bash ipgmonitoring.sh"
	exit 0
fi

# if argument -v has been passed when calling the script, then version will be displayed:
if [[ ! -z $vopt ]]
then
	echo -e "ipgmonitoring version 1.0\nDesigned by Israel PG\nGPL 2017"
	echo -e "Run the script with command: ipgmonitoring if installed via -i, otherwise ./ipgmonitoring.sh or bash ipgmonitoring.sh"
	exit 0
fi

# reset arguments indexes
shift $((OPTIND-1))

# functions library
. lib/sh/functions_ipgmonitor.sh

# install packages needed for monitoring hosts
echo "Checking for required packages before proceeding with monitoring tasks ..."
packagesRequired=(pcp-import-iostat2pcp.x86_64 nmap.x86_64)
arrayElements=${#packagesRequired[*]}
for ((i=0; i<$arrayElements; i++))
do
	packageName="${packagesRequired[$i]}"
	installPackages $packageName
done

# declare variable which stores value of resetting rich format in terminal (no bold, no color ...) with value sgr0
tecreset=$(tput sgr0)

echo -e "\E[32m***** HOSTNAME INFORMATION *****\e[0m"
hostnamectl
echo ""

echo -e "\E[32m***** CONNECTIVITY STATUS *****\e[0m"
#ping -c 1 google.com &>/dev/null && echo -e '\E[32m'"Internet: Connected $tecreset" || echo -e '\e[31;22m'"Internet: Disconnected"
echo ""

# detect iface which is active (RX > 0)
netstat -i > /tmp/activeIface.log
sed -i '1,2d' /tmp/activeIface.log # removing header lines in file
while read line;
do
	rxTrans=$(echo $line | awk '{print $3}')
	if [[ $rxTrans -gt 0 ]]
	then
		ifaceName=$(echo $line | awk '{print $1}')
		echo -e '\E[32m'"Interface $ifaceName details: $tecreset"
		ifconfig $ifaceName
	fi
done < /tmp/activeIface.log
echo ""

echo -e '\E[32m'"Open Ports by System Processes: $tecreset"
lsof -i -P
echo ""

# Check External IP
externalip=$(curl -s ipecho.net/plain;echo)
echo -e '\E[32m'"External IP : $tecreset $externalip"
echo ""

# Firewall Rules
#echo -e '\E[32m'"FIREWALL RULES (IPTABLES) : $tecreset"
#iptables -L

# -Logged-in users:
echo -e "\E[32m***** CURRENTLY LOGGED-IN USERS *****\e[0m"
w
echo ""

# -System uptime and load:
echo -e "\E[32m***** SYSTEM UPTIME AND LOAD *****\e[0m"
uptime
echo ""

# CPU Performance
echo -e "\E[32m***** CPU PERFORMANCE LOAD *****\e[0m"
iostat -c 1 1
echo ""

# Free and used memory in the system:
echo -e "\E[32m ***** FREE AND USED MEMORY *****\e[0m"
headerMem=$(free -m | grep -i 'total')
echo -e "$headerMem"
# echo rest of free -m lines, checking mem limit to alert user
while read line;
do
  	total=$(echo $line | awk '{print $2}')
        used=$(echo $line | awk '{print $3}')
        limit=$(echo "$total * 75 / 100" | bc)
        if [ $used -ge $limit ]
        then
               	echo -e '\e[31;22m'"$line $tecreset"
        else
               	echo "$line"
        fi
done < <(free -m | grep -vi 'total')
echo ""

# -Top 5 processes as far as memory usage is concerned
echo -e "\E[32m***** TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
ps -eo pmem,pcpu,comm,tty,user --sort=-pmem | head -n 6
# or using the line below with similar output:
#ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
echo ""

# I/O Disk Performance
echo -e "\E[32m***** I/O DISK PERFORMANCE *****\e[0m"
iostat -d 1 1
echo ""

# -File system disk space usage, calling function checkDisks which checks percentages as well:
echo -e "\E[32m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
dfHeaderLine=$(df -h --total | grep -i 'filesystem')
echo "$dfHeaderLine"
# displaying rest of df lines checking percentages
while read line;
do
        percentage=$(echo $line | awk '{print $5}')
        numberPercentage=$(echo $percentage | tr -d '%')
        if [[ $numberPercentage -gt 75 ]]
        then
                echo -e '\e[31;22m'"$line $tecreset"
       	else
            	echo "$line"
        fi
done < <(df -h --total | grep -vi 'filesystem')
echo ""

# FILES SIZE
echo -e "\E[32m***** TOP 5 BIGGEST FILES IN /HOME/$USER FOLDER *****\e[0m"
sudo find /home/$USER -type f -size +1M | xargs -I {} du -ah {} | sort -nrk 1 | head -n 5
echo ""
echo -e "\e[1;32mDone.\e[0m $tecreset"
echo ""
echo -e "\E[32m***** TOP 5 BIGGEST FOLDERS IN /HOME/$USER FOLDER *****\e[0m"
sudo find /home/$USER -type d -size +1M | xargs -I {} du -sh {} | sort -nrk 1 | head -n 5
echo ""
echo -e "\e[1;32mDone.\e[0m $tecreset"

# Unset variables
unset resetPerc tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

# delete tmp files
rm /tmp/activeIface.log

# resetting arguments index, so that next argument will be again $1
shift $(($OPTIND -1))
