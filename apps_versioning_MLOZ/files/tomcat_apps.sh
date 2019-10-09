#!/bin/bash

# Script Name: tomcat_apps.sh
# author: Israel Palomino Garcia (RM Team)
# Tomcat Applications: (incrond service enabled and checking in each instance app folder):
# /data/*/tomcat/webapps/
# For instance, an event for iris (new war) here /data/tomcat85_iris-next_21100/tomcat/webapps/
# or for catng (new war) here /data/tomcat85_catng-viewer_22000/tomcat/webapps/
# triggers this script tomcat_apps.sh as follows:
# /opt/tomcat/*/webapps/ IN_CREATE,IN_MODIFY /opt/scripts/tomcat_apps.sh


# Detect environment for this server
thisHostname=$(hostname)
if echo "$thisHostname" | grep -i "integ"; then
    destinationServer="s598li2wseb01.integ.gfdi.be"
elif echo "$thisHostname" | grep -i "ref"; then
	destinationServer="s598lr2wseb01.ref.cpc998.be"
elif echo "$thisHostname" | grep -i "beagle"; then
	destinationServer="s598lb2wsxx01.beagle.cpc998.be"
elif echo "$thisHostname" | grep -i "jablux" | grep -i 'lp1'; then
	destinationServer="s598lp1wsrp02.jablux.cpc998.be"
elif echo "$thisHostname" | grep -i "jablux" | grep -i 'lp2'; then
	destinationServer="s598lp2wsrp01.jablux.cpc998.be"	
fi

rm /tmp/${thisHostname}_listTomcatApps.txt
for instance in $( ps -eaf | grep tomcat | awk -F'.base=' '{print $2}'  | awk '{print $1}' ); 
do
	nbwebapps=$(ls ${instance}/webapps |  sed '/^$/d'  | wc -l )
	if [[ $nbwebapps -gt 0 ]]; then
		# application name
		applicationName = $(ls ${instance}/webapps | grep '.war' | sed 's/.war//')
		# version number
		versionNumber = $(ls -la ${instance}/webapps | grep '^l' | awk -F '/' '{print $2}' | sed 's/.war//' | sed "s/$applicationName-//")
		# append application's version to file
		echo "$applicationName - $versionNumber" >> /tmp/${thisHostname}_listTomcatApps.txt
	fi
done
scp /tmp/${thisHostname}_listTomcatApps.txt root@${destinationServer}:/data/scripts/
# destination server will read the list of files in a loop and will generate the html report
