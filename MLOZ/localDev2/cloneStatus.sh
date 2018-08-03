#!/bin/bash

#find svn-repos-csv/ -type f | xargs -I {} cat {} > /tmp/completeRepoList.txt

echo -e "\e[31;43m***** SVN Repositories Cloned Status *****\e[0m"
echo ""
printf "%-15s %-60s %-60s %-15s %-s\n" "SVN REPO" "PROJECT NAME" "JENKINS JOB" "CLONED STATUS";
echo ""

while read line
do
    GIT_ROOT_DIR="/home/israel/git/svn-repos-v_1_2"
    jenkinsJob=$(echo $line | awk -F '|' '{print $2}') 
    SVNrepoLine=$(echo $line | awk -F '|' '{print $1}')
    SVNrepoName=$(echo $line | awk -F '/' '{print $5}')
    projectName="${SVNrepoLine##*trunk/}"
    
    if [[ `find ${GIT_ROOT_DIR} -maxdepth 2 -type d | grep ${projectName}` ]]
    then
	clonedStatus="OK"
    else
	clonedStatus="NO"
    fi

    printf "%-15s %-60s %-60s %-15s %-s\n" "$SVNrepoName" "$projectName" "$jenkinsJob" "$clonedStatus";
done< <(find svn-repos-csv/ -type f | xargs -I {} cat {} | uniq | sort -nk1)
