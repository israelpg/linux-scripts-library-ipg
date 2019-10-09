#!/bin/bash

#MUST BE DEPLOYED ON SERVER WITH apache running (available on port 80)

# parameters
workDir=/data/scripts
outputFile=apps-status.html
templateFile=template.html
listWASApps=applications_running.txt
environnement="INTEG P8" 

if [[ ${PWD} != ${workDir} ]]; then
	cd $workDir
fi

# Fetching IIB list from server 598:
scp root@s598li2iib03.integ.gfdi.be:/opt/HA/scripts/*.lst .

# Fetching IIB list from server 298:
scp root@s298li2iib03.integ.gfdi.be:/opt/HA/scripts/*.lst .

listIIB=`ls *.lst`

#########################################
# create html output file
#########################################

# create header in html output file
echo "<html><head><meta http-equiv=\"Content-Style-Type\" content=\"text/css\" /><title>" > $workDir/$outputFile
echo  $environnement >> $workDir/$outputFile
echo "</title></head><body bgcolor=\"#ffffff\"><div id=\"page-logo\">" >> $workDir/$outputFile
echo  "Running Applications in "$environnement >> $workDir/$outputFile
# update with timestamp
echo "</div></br> last update: " >> $workDir/$outputFile
echo  `date +%d/%m/%y-%H:%M`'</br>' >> $workDir/$outputFile

# create table with all running WAS apps
echo "<table border=\"1\" style=\"float: left\"><tr><th>WAS Application Name</th></tr>"  >> $workDir/$outputFile
sort $workDir/$listWASApps |uniq |sed 's/^/<tr><td>/' |sed 's/$/<\/tr><\/td>/'  >> $workDir/$outputFile
echo "</table>"  >> $workDir/$outputFile

#cat ${listIIB} >> $workDir/$outputFile

# create table for each IIB
for i in $listIIB; do
    echo "<table border=\"1\" style=\"float: left\"><tr><th>"  >> $workDir/$outputFile
        echo $i |cut -d'.' -f 1 >> $workDir/$outputFile
        echo "</th></tr>"  >> $workDir/$outputFile
        cat $i |sed 's/^/<tr><td>/' |sed "s/.bar'//" |sed 's/''$/<\/tr><\/td>/'  >> $workDir/$outputFile
        echo "</table>"  >> $workDir/$outputFile
done


# complete the html output file
echo "</body></html>" >> $workDir/$outputFile

mv  $workDir/$outputFile  /var/www/html/logs/
