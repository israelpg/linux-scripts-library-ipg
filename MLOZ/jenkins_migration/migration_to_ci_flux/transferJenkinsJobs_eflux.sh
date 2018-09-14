#!/bin/bash

# Script name: transferJenkinsJobs_ebus.sh
# Version: 1.0
# Date: 12/09/2018
# Author: Israel Palomino Garcia
# Rationale: Migration of Jenkins jobs from ci-release server to ci-ebus, with a newer version of Jenkins installed
# Requisites: 
# 	1. Execute the script within ci-release server
#	2. Before migrating a job, is better to have the SVN repo migrated to Git, for this use the convertsvn2git.sh script
#	3. SSH: Add the public key of ci-release to the rest of Servers: ci-ebus, and Git/Bitbucket server

# How it works:
# ci-release jobs with a valid remote Git available on Bitbucket are modified to use Git instead of SVN, then jobs are compressed, and transferred to ci-ebus server

# File Structure
# transferJenkins.sh
# /log :: containing log files with generated list of jobs for each Jenkins server

# Some useful operations:
#
# compressing the jobs folder in ci-releasem excluding workspace which takes too much space:
# tar -jcvf foa_release_dev_migrated.tar.bz2 foa_release_dev/ --exclude *workspace*

# transfering the compressed file with ci-release jenkins jobs to ci-ebus Jenkins server
# the public key for ci-release has been copied into /root/.ssh/authorized-keys
# scp foa_release_dev_migrated.tar.bz2 root@s999lq2jkeb01.sdlc.gfdi.be:/log/
 
# fetching Git info about projects and repos
# get repositories info, ensemble:
# find /data/atlassian/application-data/bitbucket/shared/data/repositories -mindepth 2 -maxdepth 2 -type f -name repository-config -print0 | xargs -0 cat {} | egrep 'project|repository'
# projects:
# cat /log/testing.txt | grep 'project' | awk '{print $(NF)'} | sort | uniq | grep -v '^~'
# repos:

# Getting ci-ebus jobs list: JOBS MIGRATED TO CI-EBUS :
# find /opt/jenkins/jobs/ -maxdepth 1 -type d | awk -F '/' '{print $(NF)}' | sort
# Getting ci-release jobs list: ALL JOBS OLD JENKINS :
# find /opt/jenkins/jobs/ -maxdepth 1 -type d | awk -F '/' '{print $(NF)}' | sort

# Functions Declaration

# Instructions
usage()
{
cat << EOF
Script $0 help instructions:
$0 -h for help
$0 -v for version number
$0 -c for checking SVN to Git Clone Status and latest Sync date [if repo is present in Bitbucket then job to be migrated]
$0 -l for listing Jenkins jobs ready to be transferred to new server
$0 -b to migrate all jobs correlated with Git repos already migrated [batch operation]
$0 -f <filename> :: to migrate a set of jobs specified in a file
EOF
}

# Jenkins job list generation: 
# It compares ci-release jobs and those already present in ci-ebus: If not migrated, is added in the list of pending jobs
getJobsList()
{
# getting current list of jobs in ci-flux server: 
ssh root@10.198.22.157 '(find /opt/jenkins/jobs/ -maxdepth 1 -type d)' | awk -F '/' '{print $(NF)}' > log/${TIMESTAMP}_current_flux_jobs_list.log
# generate the list of Jenkins job in ci-release pending to be migrated to new version in ci-flux after crossmatch current info
while read line
do
	cat log/${TIMESTAMP}_current_flux_jobs_list.log | grep "$line" 1>/dev/null && status=migrated || status=pending
	if [[ ${status} == "pending" ]]; then
		echo ${line} >> log/${TIMESTAMP}_jobsToMigrate_list.log	
	fi	
done< <(cat ${JOBSLISTS_DIR}/${filename} | awk -F '|' '{print $2}')
}

# Git repos status, make sure whether it has been migrated or not
checkGitStatus()
{
ssh root@10.198.22.154 '(find /data/atlassian/application-data/bitbucket/shared/data/repositories -mindepth 2 -maxdepth 2 -type f -name "repository-config" \
| xargs -I {} cat {} | egrep "project|repository")' | tee -a log/${TIMESTAMP}_git_repositories_list.log

while read line
do
	# to check if job uses a template
	templateUsed=$(cat /data/hudson/jobs/"$line"/config.xml | grep 'templateproject')

	# to gather repo list for the job
	repos=()
	while read line
	do
		reponame=$(echo ${line} | sed 's/<[^>]*>//g' | awk -F '/' '{print $(NF)}')
		repos=("${repos[@]}" "$reponame")
	done< <(cat /data/hudson/jobs/${line}/config.xml | egrep '<remote>|<cvsroot>' | sed 's/ /\ /')

	# if repo(s) are all migrated to Git, then status is OK 1, otherwise is 0
	for repo in ${repos[@]}
	do
		echo "Checking if SVN repo name ${repo} exists as a Git remote repo..."
    	cat log/${TIMESTAMP}_git_repositories_list.log | grep "$repo" 1>/dev/null && gitStatus=1 || gitStatus=0
	done
	
	# If all repos for this job are migrated to Git, the job will be migrated as well, in this case to ci-flux	
	if [[ gitStatus -eq 1 ]]; then
    	echo "Jenkins job $line has a remote Git repo named $repo available on Bitbucket, job will be transferred to ci-ebus"
        echo ${line} | tee -a log/${TIMESTAMP}_migrated_jobs.log
    elif [[ gitStatus -eq 0 ]]; then
        echo "Job $line not migrated in this operation. Missing Git repo(s) in Git" | tee -a log/${TIMESTAMP}_jobs_not_migrated_missing_git_repos.log
    fi

	# if a template is used, the job will be migrated (e.g.: JadeR)
	if [[ ! -z ${templateUsed} ]]; then
		echo ${line} | tee -a log/${TIMESTAMP}_migrated_jobs.log
	fi	
done < log/${TIMESTAMP}_jobsToMigrate_list.log
}

transferJob()
{
	echo "job transferred"
}

while getopts "hvclbf:" OPTION
do
	case $OPTION in
	h)
		echo "Listing help"
		usage
		exit 0
		;;
	v)
		echo "$0 Version 1.0"
		exit 0
		;;
	c)
    	./cloneStatus.sh && exit 0 || echo "Script cloneStatus.sh has failed" ; exit 1
        ;;

	l)
		echo "Listing Jenkins jobs ready to be transferred:"
		ls -lah svn-repos-csv/
		echo -e "\n"
		echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv"
		exit 0
		;;
	b)
		echo "Processing in batch mode with all jobs not migrated so far..."
		batchMode="1"
		;;
	f)
		filename=$OPTARG
		echo "Script $0 called passing Jenkins job name: $filename"
		echo "Checking if $filename exists and contains jobs ready to be migrated:"
		;;
	*)
		echo "No valid option passed when calling script $0 !"
		usage
		exit 1
		;;
	esac
done

PID=$(echo "$$")
ROOT_UID=0 # to check in case we require to run script as root
TIMESTAMP=$(date +%F_%H%M)
EXECUTION_DIR="$PWD"
JOBSLISTS_DIR="$EXECUTION_DIR/jobslists"

if [[ $# -eq 0 && -z $batchMode ]]
then
    echo "You haven't passed any argument when calling script, nor invoked batch mode with argument -b !"
    echo "Type $0 -h for displaying help info"
    exit 0
fi

if [[ -n ${filename} && -f ${JOBSLISTS_DIR}/${filename} ]]; then

	# double check each job exists and is valid in ci-release
	# ci-release jobs:
	find /data/hudson/jobs/ -maxdepth 1 -type d | awk -F '/' '{print $(NF)}' | sort > log/${TIMESTAMP}_complete_ci_release_jobs_list.log
	sed -i '1d' log/${TIMESTAMP}_complete_ci_release_jobs_list.log	

	
	while read line
	do
		cat log/${TIMESTAMP}_complete_ci_release_jobs_list.log | grep "$line" 1>/dev/null && checkJob=exists || checkJob=unexisting
    	if [[ ${checkJob} == "exists" ]]; then
        	echo "Jenkins job name: $line is an existing job in ci-release."
			echo "Checking if corresponding Git remote repo is available on Bitbucket, if so job $line will be transferred to ci-flux ..."
    	elif [[ ${checkJob} == "unexisting" ]]; then
        	echo "The jobname ${jobName} does not exist, removing from $filename ..."
			sed -i "/$line/d" ${JOBSLISTS_DIR}/${filename}  
		fi
	done< <(cat ${JOBSLISTS_DIR}/${filename} | awk -F '|' '{print $2}')

	# getting a final list by comparing what has been already migrated to ci-flux
	getJobsList 
	if [[ $? -ne 0 ]]; then
		echo "Error trying to fetch current jobs from ci-flux server, cannot crossmatch info !" ; 
		exit 1
	fi
	echo "List of Jenkins jobs successfully generated" 
    echo "Checking Git/Bitbucket remote repository status for each job pending to be transferred"
    checkGitStatus 
	if [[ $? -ne 0 ]]; then
		echo "Error trying to check Git remote repo status !"
		exit 1
	fi
	transferJob	
else
    echo "Error: Filename $filename does not exist in dir $JOBSLISTS_DIR"
    echo "Listing available Jenkins Jobs list files:"
    ls -lah ${JOBSLISTS_DIR}
    echo "$0 -f <filename> for passing a valid filename as argument. Example: -f svn-nippin.csv"
    exit 0
fi

# batch mode processing

if [[ ${batchMode} -eq 1 ]]; then
	echo "Getting list of Jenkins jobs which have not been migrated yet to ci-ebus server ..."
	getJobsList
	echo "List of Jenkins jobs successfully generated" 
	echo "Checking Git/Bitbucket remote repository status for each job pending to be transferred"
	checkGitStatus
	
fi
