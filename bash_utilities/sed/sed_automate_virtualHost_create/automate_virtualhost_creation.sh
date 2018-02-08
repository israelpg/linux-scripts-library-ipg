#!/bin/bash
# Script Name: automate_virtualhost_creation.sh
# Date: 09/072017 - Author: Israel Palomino Garcia
# Description: Automating the creation of Apache Virtual Hosts with prompt input by Administrator

ORIGINALDIR="/var/www/html"
TEMPLATE="/etc/apache2/sites-available/000-default.conf"

token=0

while [ $token -eq 0 ]
do
	read -p "Please, enter a Virtual Host Name: " virtualHost
	if [  -z "$virtualHost" ]
	then
		echo 'Empty value not accepted'
	else
		WEBDIR="$ORIGINALDIR/$virtualHost/public_html"
		if [[ ! -d $WEBDIR ]]
		then
        		mkdir -p $WEBDIR
		fi

		CONF_FILE="/etc/apache2/sites-available/$virtualHost.conf"
		echo "Virtual Host name is: " $virtualHost
		let token++
	fi
done

sed "s/#ServerName www.example.com/ServerName www.$virtualHost/" $TEMPLATE > $CONF_FILE

MAINROOTFOLDER="\/var\/www\/html"
sed -i "s/DocumentRoot $MAINROOTFOLDER/DocumentRoot $MAINROOTFOLDER\/$virtualHost\/public_html/" $CONF_FILE

echo "Virtual Host $virtualHost configuration:" ; cat $CONF_FILE
