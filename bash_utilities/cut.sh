#!/bin/bash

# cutting caracters:

cut -c 5-10 thisfile.txt # from character 5 to 10 included

# cutting columns, not indicating delimiter, default is tab space:
cat /tmp/prueba.txt | cut -f2
#or:
cut -f2 /tmp/prueba.txt

# cutting columns, indicating delimiter:

# example 1: var1="34%56"
echo $var1 | cut -d % -f1 # 34
echo $var1 | cut -d % -f2 # 56

#example 2:

cut -d ' ' -s -f5 interrupt.sh # -s for not displaying lines without delimeter

# from 5 to 7
[ip14aai@02di20161554187 tests]$ cut -d ' ' -s -f5-7 interrupt.sh
and script will
0 ]]


-1 ]]

# 5 and 7
[ip14aai@02di20161554187 tests]$ cut -d ' ' -s -f5,7 interrupt.sh
and will
0


-1

####### Below a list of examples based on other exercises within my repository:
[ip14aai@02DI20161235444 security_RedHat]$ grep 'cut -c' -R -n ../

# here we use a delimiter : to extract the number of line when doing a grep -n 
../bash_programming/examples_bash_prog/automation/reports_html/generatingHTML_report_v2.sh:48:	getNumberLine=$(cat $WEB_DIR/$FILENAME | grep -n 'total' | cut -d ':' -f 1)

../bash_utilities/cut.sh:5:cut -c 5-10 thisfile.txt # from character 5 to 10 included

../files_management/cut_columns/cut.sh:18:cut -c 1-5 range_fields.txt # displays: abcde

../monitoring/detect_ip_intruders.sh:40:		cut -c-16 /tmp/$$.log > $$.time

# 2- is from second last to end ... -2 from second first to end
../myAutomation/backup_scripts/detectNewHosts.sh:51:	hostnameChecking=$(echo $hostnameChecking | rev | cut -c 2- | rev) # removing last character  .

../myAutomation/tests/detectNewHosts2.sh:30:        hostnameChecking=$(nslookup $host | awk '{print $4}' | tr -d '\n' | rev | cut -c 2- | rev)

../myAutomation/detectNewHosts.sh:116:        hostnameChecking=$(nslookup $host | awk '{print $4}' | tr -d '\n' | rev | cut -c 2- | rev)

# from first to 16th:
../myAutomation/detect_ip_intruders.sh:46:		cut -c-16 /tmp/userFailed_$$.log > /tmp/$$.time

../networking/print_iface_list_names.sh:3:ifconfig | cut -c-10 | tr -d ' ' | tr -s '\n'

../security/detect_ip_intruders.sh:39:		cut -c-16 /tmp/$$.log > $$.time

../security_RedHat/detect_ip_intruders.sh:53:		cut -c-16 /tmp/userFailed_$$.log > /tmp/$$.time

../nexus/nexus:188:FIRST_CHAR=`echo $NEXUS_HOME | cut -c1,1`

../nexus/nexus:202:FIRST_CHAR=`echo $PIDDIR | cut -c1,1`
