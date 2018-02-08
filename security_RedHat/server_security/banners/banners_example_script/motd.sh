#!/bin/bash
# placed in /etc/profile.d/motd (profile.d for execution with any user, motd = message of the day)
# Functions:

function sshSession()
{
echo -e "${WHITE}******************************************************************************"
echo -e "${WHITE}*                                                                           **"
echo -e "${WHITE}     Powered by:"
echo -e "${WHITE}     $DISTRO"
echo -e "${WHITE}     $KERNEL"
echo -e "${WHITE}*                                                                           **"
echo -e "${RED}********************************************************************************"

CPUMOD=$(cat /proc/cpuinfo | grep -m 1 -w 'model name' | awk -F: '{print $2}')
HOSTNAME=$(uname -n)
KERNEL=$(uname -r)
MEMTOTAL=$(cat /proc/meminfo | grep -m 1 -w 'MemTotal' | awk -F: '{print $2}')
MEMFREE=$(cat /proc/meminfo | grep -m 1 -w 'MemFree' | awk -F: '{print $2}')
SWAPTOTAL=$(cat /proc/meminfo | grep -m 1 -w 'SwapTotal' | awk -F: '{print $2}')
SWAPFREE=$(cat /proc/meminfo | grep -m 1 -w 'SwapFree' | awk -F: '{print $2}')

echo -e ""
echo -e "${WHITE} Welcome ${YELLOW}${USER} ${WHITE}to $HOSTNAME"
echo -e ""

echo -e "${WHITE} Date: "`date`
echo -e ""

echo -e "${WHITE} Hostname:   ${HOSTNAME}"
echo -e "${WHITE} CPU Model: ${CPUMOD}"

echo -e "${WHITE} Total Memory: ${MEMTOTAL}"
echo -e "${WHITE} Free Memory: ${MEMFREE}"
echo -e ""
echo -e "${WHITE} Swap Total:    ${SWAPTOTAL}"
echo -e "${WHITE} Swap Free:    ${SWAPFREE}"

echo -e ""

echo -e "${RED}******************************************************************************"
# Reset Terminal Colour Back to Normal
echo -e "$tecreset"
}

function ttySession() # pts session via screen terminal is also applicable in this case
{
echo -e ""
echo -e "${WHITE} Welcome ${YELLOW}${USER} ${WHITE}to $HOSTNAME"
echo -e "${RED}$DISTRO - $KERNEL"
echo -e "$tecreset"
}

# Variables:
# Colours
red="\033[00;31m"
RED="\033[01;31m"

green="\033[00;32m"
GREEN="\033[01;32m"

brown="\033[00;33m"
YELLOW="\033[01;33m"

blue="\033[00;34m"
BLUE="\033[01;34m"

purple="\033[00;35m"
PURPLE="\033[01;35m"

cyan="\033[00;36m"
CYAN="\033[01;36m"

white="\033[00;37m"
WHITE="\033[01;37m"

# NC="\033[00m"
# reset prompt values@
tecreset=$(tput sgr0)

# Server Info
DISTRO=$(hostnamectl | grep -i 'operating system:')
KERNEL=$(hostnamectl | grep -i 'kernel:')

# connection type: either ssh or an internal login session from server itself by checking whether process sshd is ongoing with established conn:
connectionLine=$(ps -ef | grep -i 'sshd.*.@.*' | grep -v 'color')  # checking for user conn, not the command itself in the ps output (colored)
myUser=$(whoami)
tokenConn=$(echo $connectionLine | grep $myUser | wc -l) # returns 0 if you are in the server itself (tty), otherwise returns 1 (ssh)

if [[ $tokenConn -gt 0 ]]
then
       	sshSession
else
	ttySession
fi
