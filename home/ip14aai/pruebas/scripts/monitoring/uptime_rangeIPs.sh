#!/bin/bash

#sudo fping -a 192.168.56.0/24 -g 1>/tmp/alive.txt 2>/dev/null
sudo fping -a 192.168.56.100 192.168.56.101 192.168.56.102 1>/tmp/alive.txt 2>/dev/null
# better to redirect logs like this, redirecting sterror to stdout, and stdout to log file:
sudo fping -a 192.168.56.100 192.168.56.101 192.168.56.102 2>&1 | tee /tmp/alive.txt

cat /tmp/alive.txt

# this only needed if you use -g in the fping for a network selection like: 192.168.56.0/24
#cut -f 1 /tmp/alive.txt > /tmp/alive.txt

number_IPs=`cat /tmp/alive.txt | wc -l`

echo "Number of IPs alive: $number_IPs "

ip_list=$(cat /tmp/alive.txt)

echo "Checking this list of IPs alive:"
echo "$ip_list"

for ip in $ip_list
do
	#utime=$(sudo ssh ip14aai@${ip} uptime | awk '{ print $3 }' )
	utime=`sudo ssh ip14aai@${ip} uptime | awk '{ print $3 }' | tr -d ','`
	echo $ip uptime: $utime
done

#array_IPs=()
#index_array=0

#for i in {1..$numberIPs}
#do
#	array_IPs[$index_array]=`cat /tmp/alive.txt | sed -n 1p ; echo $i`
#	let index_array++
#done
#
#echo ${array_IPs[*]}




