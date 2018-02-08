#!/bin/bash

# Sample script to demonstrate the creation of an HTML report using shell scripting

# exit in case of error, stop script execution
set -o errexit
# error in case of non-declared var being used
#set -o nounset

function checkFileExists()
{
	if [ -f $WEB_DIR/$1 ]
	then
		rm $WEB_DIR/$1
	fi
}

# check percentage, in order to use css class to display red color (alert) or not
function checkPercentage()
{
	#filesystem=$(echo $line | awk '{print $1}')
	numberPercentage=$(echo $1 | tr -d '%')
	#if [ $numberPercentage -ge 75 ]
	if [ $(echo "$numberPercentage > 75" | bc) -ne 0 ]
	then
		alertLine="</td><td class='alert' align='center'>"
	else
		alertLine="</td><td class='noalert' align='center'>"
	fi
}

# date
readonly date=$(date +"%d-%m-%y")

# Web directory
readonly WEB_DIR=/var/www/html
readonly FILENAME=$date.report.html
checkFileExists $FILENAME

# vars declared:
# clear formatting:
tecreset=$(tput sgr0)

# A little CSS and table layout to make the report look a little nicer
echo "<HTML>
<HEAD>
<style>
.titulo{font-size: 1em; color: white; background:#0863CE; padding: 0.1em 0.2em;}
table
{
border-collapse:collapse;
}
table, td, th
{
border:1px solid black;
}
.alert
{
font-weight: bold;
color: red;
}
.noalert
{
color: black;
}
.statusOK
{
color: green;
}
.colored
{
font-weight: bold;
color: black;
background: orange;
}
.vl {
    border-left: 2px solid black;
    height: 100vh;
    position: absolute;
    left: 50%;
    margin-left: -3px;
    top: 0;
}
</style>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
</HEAD>
<BODY>" > $WEB_DIR/$FILENAME # creating the report file

# testing lines
echo "<h4>Last updated: <strong>$(date)</strong></h4>
<div id='hostnamectl'>" >> $WEB_DIR/$FILENAME
echo "<h3>Hostname Details:</h3>" >> $WEB_DIR/$FILENAME
while read line
do
	echo "$line<br/>" >> $WEB_DIR/$FILENAME
	#echo "<br>" >> $WEB_DIR/$FILENAME
done < <(hostnamectl)
echo "</div>" >> $WEB_DIR/$FILENAME

echo "<div id='connectivity_status'><h3>Internet Connectivity Status:</h3>" >> $WEB_DIR/$FILENAME
# change localhost by an Internet address like google.com:
internetAddress="localhost"
ping -c 1 $internetAddress &>/dev/null && extIPOK="true" && statusConn="Internet: Connected" || statusConn="Internet: Disconnected"

if [[ ! -z $extIPOK ]] # if Internet connection is ok, we check for external IP
then
	# Connected to the Internet:
	echo "<p class='statusOK'>$statusConn .. ping to $internetAddress successful</p>" >> $WEB_DIR/$FILENAME
	# Check External IP
	externalip=$(curl -s ipecho.net/plain ; echo)
	echo "External IP: $externalip" >> $WEB_DIR/$FILENAME
else
	echo "<p class='alert'>$statusConn .. ping to $internetAddress not transmitted</p>" >> $WEB_DIR/$FILENAME
fi
echo "</div>" >> $WEB_DIR/$FILENAME

# detect iface which is active (RX > 0)
echo "<h3>Main Interface Details:</h3>" >> $WEB_DIR/$FILENAME
netstat -i > /tmp/listIfaces.log
grep -vi 'lo' /tmp/listIfaces.log > /tmp/activeIface.log # removing lo (localhost) from active option
sed -i '1,2d' /tmp/activeIface.log # removing header lines in file
while read line;
do
       	rxTrans=$(echo $line | awk '{print $3}')
        if [[ $rxTrans -gt 0 ]]
        then
            	ifaceName=$(echo $line | awk '{print $1}')
        fi
done < /tmp/activeIface.log
echo "<div id='iface_info'>" >> $WEB_DIR/$FILENAME
while read line
do
	echo "$line<br/>" >> $WEB_DIR/$FILENAME
done < <(ifconfig $ifaceName)
echo "</div>" >> $WEB_DIR/$FILENAME

# detect iface which is active (RX > 0)
echo "<div id='loggedUsers'><h3>Logged in users:</h3>" >> $WEB_DIR/$FILENAME
summaryLogs=$(w | grep -i 'users') # keeping just first summary line:
echo "$summaryLogs<br/>" >> $WEB_DIR/$FILENAME
# now printing table with main header, and all lines related to login sessions:
echo "<table border='1'>
<tr><th class='titulo'>USER</th>
<th class='titulo'>TTY</th>
<th class='titulo'>FROM</th>
<th class='titulo'>LOGIN@</th>
<th class='titulo'>IDLE</th>
<th class='titulo'>JCPU</th>
<th class='titulo'>PCPU</th>
<th class='titulo'>WHAT</th>
</tr>" >> $WEB_DIR/$FILENAME
while read line;
do
echo "<tr><td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $1}' >> $WEB_DIR/$FILENAME
echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $2}' >> $WEB_DIR/$FILENAME
echo "<td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $3}' >> $WEB_DIR/$FILENAME
echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $4}' >> $WEB_DIR/$FILENAME
echo "<td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $5}' >> $WEB_DIR/$FILENAME
echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $6}' >> $WEB_DIR/$FILENAME
echo "<td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $7}' >> $WEB_DIR/$FILENAME
echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
echo $line | awk '{print $8}' >> $WEB_DIR/$FILENAME
echo "</td></tr>" >> $WEB_DIR/$FILENAME
done < <(w | grep -vi user) # redirecting command output except first line
echo "</table></div>" >> $WEB_DIR/$FILENAME

echo "<div id='infoUsers'><h4>Details about active users</h4>" >> $WEB_DIR/$FILENAME
while read line
do
	thisUserDetails=$(id $line)
	echo "Details for active user: $line <br/> $thisUserDetails <br/>" >> $WEB_DIR/$FILENAME
done < <(who | awk '{print $1}' | uniq)
echo "</div>" >> $WEB_DIR/$FILENAME

HOST=$(hostname)
iostat -c 1 1 >/tmp/iostat.log
sed -i '5d' /tmp/iostat.log # removing last line which is empty
sed -i '1,3d' /tmp/iostat.log # removing headers

echo "<div id='hostPerformance'><h3> $Host Performance</h3><h4>CPU Performance:</h4>" >> $WEB_DIR/$FILENAME
echo "<table border='1'>
<tr>
<th class='titulo'>avg-cpu:</td>
<th class='titulo'>%user</td>
<th class='titulo'>%nice</td>
<th class='titulo'>%system</td>
<th class='titulo'>%iowait</td>
<th class='titulo'>%steal</td>
<th class='titulo'>%idle</td>
</tr>" >> $WEB_DIR/$FILENAME
while read line
do
	echo "<tr><td></td><td>" >> $WEB_DIR/$FILENAME
	echo $line | awk '{print $1}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
	echo $line | awk '{print $2}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
	echo $line | awk '{print $3}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
	echo $line | awk '{print $4}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
	echo $line | awk '{print $5}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
	echo $line | awk '{print $6}' >> $WEB_DIR/$FILENAME
	echo "</td></tr>" >> $WEB_DIR/$FILENAME
done < /tmp/iostat.log
echo "</table>" >> $WEB_DIR/$FILENAME
echo "</div>" >> $WEB_DIR/$FILENAME

echo "<div id='memUsage'>
<h4>Free and Memory Usage:</h4>
<table border='1'>
<tr><th class='titulo'>Memory</td>
<th class='titulo'>total</td>
<th class='titulo'>used</td>
<th class='titulo'>free</td>
<th class='titulo'>shared</td>
<th class='titulo'>buff/cache</td>
<th class='titulo'>available</td>
</tr>" >> $WEB_DIR/$FILENAME
while read line;
do
  	echo "<tr><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $1}' >> $WEB_DIR/$FILENAME
  	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $2}' >> $WEB_DIR/$FILENAME
        echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $3}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $4}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $5}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $6}' >> $WEB_DIR/$FILENAME
	echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $7}' >> $WEB_DIR/$FILENAME
	echo "</td></tr>" >> $WEB_DIR/$FILENAME
done < <(free -m | grep -vi total)
echo "</table>" >> $WEB_DIR/$FILENAME
echo "</div>" >> $WEB_DIR/$FILENAME

# top 5 processes running in the system:
echo "<h4>Top 5 processes in terms of memory usage:</h4>" >> $WEB_DIR/$FILENAME
echo "<table border='1'>
<tr><th class='titulo'>Process/Command</td>
<th class='titulo'>Terminal</td>
<th class='titulo'>User</td>
<th class='titulo'>%CPU</td>
<th class='titulo'>%MEMORY</td>
</tr>" >> $WEB_DIR/$FILENAME
while read line;
do
        echo "<tr><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $1}' >> $WEB_DIR/$FILENAME
        echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $2}' >> $WEB_DIR/$FILENAME
 	echo "<td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $3}' >> $WEB_DIR/$FILENAME
        percentage=$(echo $line | awk '{print $4}')
       	checkPercentage $percentage
        echo "$alertLine" >> $WEB_DIR/$FILENAME
        echo "$percentage" >> $WEB_DIR/$FILENAME
	percentage=$(echo $line | awk '{print $5}')
        checkPercentage $percentage
        echo "$alertLine" >> $WEB_DIR/$FILENAME
        echo "$percentage" >> $WEB_DIR/$FILENAME
        echo "</td></tr>" >> $WEB_DIR/$FILENAME
done < <(ps -eo comm,tty,user,pcpu,pmem --sort=-pmem | head -n 6 | grep -vi 'command')
echo "</table></div>" >> $WEB_DIR/$FILENAME

###### DISK
iostat -d 1 1 > /tmp/iostatdisk.log
sed -i '1,3d' /tmp/iostatdisk.log # removing headers
lastLine=$(cat /tmp/iostatdisk.log | wc -l)
sed -i "$lastLine d" /tmp/iostatdisk.log # removing last line
echo "<div id='diskIO'>
<h4>Disk I/O Performance</h3>
<table border='1'>
<tr><th class='titulo'>Device</th>
<th class='titulo'>tps</th>
<th class='titulo'>KB read/s</th>
<th class='titulo'>KB written/s</th>
<th class='titulo'>KB read</th>
<th class='titulo'>KB written</th>
</tr>" >> $WEB_DIR/$FILENAME
while read line;
do
  	echo "<tr><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $1}' >> $WEB_DIR/$FILENAME
        echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $2}' >> $WEB_DIR/$FILENAME
	echo "<td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $3}' >> $WEB_DIR/$FILENAME
        echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $4}' >> $WEB_DIR/$FILENAME
	echo "<td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $5}' >> $WEB_DIR/$FILENAME
        echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $6}' >> $WEB_DIR/$FILENAME
        echo "</td></tr>" >> $WEB_DIR/$FILENAME
done </tmp/iostatdisk.log
echo "</table></div>" >> $WEB_DIR/$FILENAME



echo "<div id='diskUsage'>
<h3>Filesystem usage for host <strong>$HOST</strong></h3>
<table border='1'>
<tr><th class='titulo'>Filesystem</td>
<th class='titulo'>Size</td>
<th class='titulo'>Use %</td>
</tr>" >> $WEB_DIR/$FILENAME
while read line;
do
  	echo "<tr><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $1}' >> $WEB_DIR/$FILENAME
        echo "</td><td align='center'>" >> $WEB_DIR/$FILENAME
        echo $line | awk '{print $2}' >> $WEB_DIR/$FILENAME
        percentage=$(echo $line | awk '{print $5}')
        checkPercentage $percentage
        echo "$alertLine" >> $WEB_DIR/$FILENAME
        echo "$percentage" >> $WEB_DIR/$FILENAME
        echo "</td></tr>" >> $WEB_DIR/$FILENAME
done < <(df -h --total | grep -vi 'filesystem')
echo "</table></div>" >> $WEB_DIR/$FILENAME

# listing the 5 biggest files in this machine
ls -lah /home/ | awk '{print $9}' >/tmp/usersHome.log
sed -i '1,3d' /tmp/usersHome.log # remove blank line and dirs references . ..
echo "<h4>Listing the 5 biggest files in /home for each user with a folder:</h4>" >> $WEB_DIR/$FILENAME
while read user
do
	echo "<strong>$user:</strong><br/>" >> $WEB_DIR/$FILENAME
	while read file
	do
		#listFiles=$(find /home/$line -type f -size +500k ! -ipath "/home/$line/.*/*" | xargs -I {} du -sh {} 2>/dev/null)
		echo "$file <br/>" >> $WEB_DIR/$FILENAME
	done < <(find /home/$user -type f -size +500k ! -ipath "/home/$user/.*/*" | xargs -I {} du -sh {} 2>/dev/null)
	echo "<br/>" >> $WEB_DIR/$FILENAME
done < /tmp/usersHome.log

# vertical line in css to break the page in two sides
echo "<div class="vl">" >> $WEB_DIR/$FILENAME

# end of testing

echo "</BODY></HTML>" >> $WEB_DIR/$FILENAME
