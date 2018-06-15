#!/bin/bash

# Sample script to demonstrate the creation of an HTML report using shell scripting

# exit in case of error, stop script execution
set -o errexit
# error in case of non-declared var being used
set -o nounset

# passing as argument the filename, and checking if exists
#function checkFileExists()
#{
#	cd /var/www/html
#	if [ -e $1 ]
#	then
#		rm $1
#		cd -
#	fi
#}

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
	if [ $numberPercentage -ge 75 ]
	then
		alertLine="</td><td class='alert' align='center'>"
	else
		alertLine="</td><td class='noalert' align='center'>"
	fi
}

# formatting total line, with capital letters and specific color in the table
function formatTotalLine()
{
	# adding class to <tr> where totals are specified (last line):
	# get number of line where total is written
	#getNumberLine=$(cat $WEB_DIR/$FILENAME | grep -n 'total' | cut -c -2)
	getNumberLine=$(cat $WEB_DIR/$FILENAME | grep -n 'total' | cut -d ':' -f 1)
	let getNumberLine-- #to get the <tr> line instead of the total itself
	sed -i "s/total/TOTAL/" $WEB_DIR/$FILENAME
	sed -i "$getNumberLine s/<tr>/<tr class='colored'>/" $WEB_DIR/$FILENAME
}

# date
readonly date=$(date +"%d-%m-%y")

# Web directory
readonly WEB_DIR=/var/www/html
readonly FILENAME=$date.report.html
checkFileExists $FILENAME

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
.colored
{
font-weight: bold;
color: black;
background: orange;
}
</style>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
</HEAD>
<BODY>" > $WEB_DIR/$FILENAME # creating the report file
# View hostname and insert it at the top of the html body
HOST=$(hostname)
echo "Filesystem usage for host <strong>$HOST</strong><br>
Last updated: <strong>$(date)</strong><br><br>
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
#echo "</td><td id='alert' align='center'>" >> $WEB_DIR/$FILENAME
echo "$alertLine" >> $WEB_DIR/$FILENAME
echo "$percentage" >> $WEB_DIR/$FILENAME
echo "</td></tr>" >> $WEB_DIR/$FILENAME
done < <(df -h --total | grep -vi filesystem)
echo "</table></BODY></HTML>" >> $WEB_DIR/$FILENAME

formatTotalLine
