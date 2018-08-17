#!/bin/bash

# Script Name: cloneStatus.sh
# Version: 1.0
# Author: Israel (RM Team)
# Rationale: This script finds all csv files containing SVN repos details, and reports whether have been cloned or not
# All CSV files shall be located in the same folder "svn-repos-csv" within execution directory
# All Git repositories already cloned are in the same directory, specified as a string in one variable

echo -e "\e[31;43m***** SVN Repositories Cloned Status *****\e[0m"
echo ""
printf "\e[1;34m%-20s %-45s %-55s %-15s %-15s %-s\e[m\n" "SVN REPO" "PROJECT NAME" "JENKINS JOB" "CLONED STATUS" "CLONED DATE";
echo ""

GIT_ROOT_DIR="/home/israel/git/svn-repos-v_1_2"

while read line
do
    jenkinsJob=$(echo $line | awk -F '|' '{print $2}') 
    SVNrepoLine=$(echo $line | awk -F '|' '{print $1}')
    SVNrepoName=$(echo $line | awk -F '/' '{print $5}')
    projectName="${SVNrepoLine##*trunk/}"

    if [[ `find ${GIT_ROOT_DIR} -maxdepth 2 -type d | grep ${projectName}` ]]; then
   		cd $GIT_ROOT_DIR/$projectName
 
    	if [[ `git branch --all | grep 'trunk'` ]]
    	then
			clonedStatus="OK"
			clonedDate=$(ls -lah ${GIT_ROOT_DIR}/${projectName} | sed -n '2p' | awk '{print $7,$6,$8}')
		fi    	
	else
		clonedStatus="NO"
		clonedDate=""
    fi

   	if [[ $clonedStatus == "OK" ]]
   	then
   		printf "\e[0;32m%-20s %-45s %-55s %-15s %-15s %-s\e[m\n" "$SVNrepoName" "$projectName" "$jenkinsJob" "$clonedStatus" "$clonedDate";
   	else
   		printf "%-20s %-45s %-55s %-15s %-15s %-s\n" "$SVNrepoName" "$projectName" "$jenkinsJob" "$clonedStatus" "$clonedDate";
   	fi
done< <(find svn-repos-csv/ -type f | xargs -I {} cat {} | sort -nk1)
