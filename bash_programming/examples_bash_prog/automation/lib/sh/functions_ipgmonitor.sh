#!/bin/bash

set -o errexit
set -o nounset

# functions declaration

# this loop controls if arguments -i or -v have been passed calling the script:
# -i installs the script (basically copying it into /bin), whereas -v displays the version
checkArguments()
{
       while getopts iv name
       do
              case $name in
              i)iopt=1;;
              v)vopt=1;;
              *)echo "Invalid argument when calling the script, pass -i (install) or -v (version)" ; exit 1;;
              esac
       done

	# checking if -i argument has been passed when calling the script for installation:
	if [[ ! -z $iopt ]]
	then
    		if [ -f /usr/bin/$0 ] # if the file does not exist, has not been installed, proceeding:
	        then
        	    	echo "Script $0 is already installed in this host. Run with command: ipg_monitoring"
	        else
	            	scriptname=$0
        	        su -c "cp $scriptname /usr/bin/$0" root &&
                	echo "Script $0 installed, run with command: ipgmonitoring" || echo "Error while installing" ; exit 1
	        fi
	fi

	if [[ ! -z $vopt ]]
	then
    		echo -e "ipgmonitoring version 1.0\nDesigned by Israel PG\nGPL 2017"
	fi
}

# checking that percentage of used disk in specific filesystem does not exceed 75% of total capacity
checkPercentage()
{
        numberPercentage=$(echo $1 | tr -d '%')
        if [ $numberPercentage -gt 75 ]
        then
		limitDisk=1
	else
		limitDisk=0
        fi
}

# install package
installPackages()
{
	# first check whether is already installed in host
	checkPack=$(yum list installed | grep "$1" | wc -w)
	if [[ $checkPack -gt 0 ]]
	then
		echo "$1 package already installed."
	else
		yum install -y "$1"
	fi
}
