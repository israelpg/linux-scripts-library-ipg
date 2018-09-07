#!/bin/bash
#
# Script name: syncsvn2git.sh
# Version 1.0
# Rationale: Sync SVN repo with counterparter Git repo, fetching latest commits to SVN from developers and pushed to Git
# 

# Functions Declaration
#
# Instructions
usage()
{
cat << EOF
Script $0 help instructions:
$0 -h for help
$0 -v for version number
$0 -l for listing CSV repo files
$0 -c for checking SVN to Git Clone Status and latest Sync date
$0 -f <filename> :: SYNC/PUSH :: passing a CSV repo filename as argument. Example: convertsvn2git.sh -f svn-nippin.csv
EOF
}

# enter SVN credentials:
loginSVN()
{
read -p "Enter your SVN username: " usernameSVN
read -sp "Type your SVN password: " passwordSVN
echo "Checking SVN credentials..."
}

# check if a project has been previously cloned and can proceed to be updated witn new SVN commits
checkProject()
{
jenkinsJob=$(echo $1 | awk -F '|' '{print $2}')
SVNrepoLine=$(echo $1 | awk -F '|' '{print $1}')
SVNrepoName=$(echo $1 | awk -F '/' '{print $5}')
projectName="${SVNrepoLine##*trunk/}"

if [[ `find ${GIT_ROOT_DIR} -maxdepth 2 -type d | grep ${projectName}` ]]; then
    cd $GIT_ROOT_DIR/$projectName
	if [[ `git branch --all | grep 'trunk'` ]]
    then
        clonedStatus="OK"
    fi
else
    clonedStatus="NO"
fi
}

# This function uses "svn-migration-scripts" jar file to extract authors information from SVN
function getAuthors()
{
echo "Updating Authors list for project $project..."
projectLog=$(echo $project | awk -F '/' '{print $(NF-1)}')

java -jar "$EXECUTION_DIR/svn-migration-scripts.jar" authors $repo $usernameSVN $passwordSVN > "$AUTHORS_DIR/$projectLog-authors.txt"

if [[ $? -ne 0 ]]; then
	echo "Wrong credentials, stopping $0 execution..."
	exit 1
fi

echo "List of authors completed under file: $AUTHORS_DIR/$projectLog-authors.txt"
}

# hvl are options, do not have colon at the end, whereas f has colon : (expects an argument: filename)
while getopts "hvlcf:" OPTION
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
	
	l)
		echo "Listing CSV repo files:"
		ls -lah svn-repos-csv/
		echo -e "\n"
		echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: syncsvn2git.sh -f svn-nippin.csv"
		exit 0
		;;
	c)
		./cloneStatus.sh && exit 0 || echo "Script cloneStatus.sh has failed" ; exit 1
		;;
	f)
		filename=$OPTARG
		echo "Script $0 called passing argument CSV filename: $filename"
		echo "Checking if file exists and contains valid SVN repos...only cloned repos will be synced..."
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
AUTHORS_DIR="$EXECUTION_DIR/authors"
# Define the Git directory:
GIT_ROOT_DIR="/home/israel/git/svn-repos-v_1_2"
GITPROJECT="IS"
# In this directory are stored the different csv files, one for each SVN project
SVN_CSV_DIR="$EXECUTION_DIR/svn-repos-csv"

if [[ $# -eq 0 ]]
then
    echo "You haven't passed any argument when calling script !"
    echo "Type $0 -h for displaying help info"
    exit 1
fi

# For option -f : Checking if CSV file with list of SVN repos exists in the CSV directory
# repos in the file will be synced and pushed to Bitbucket in batch processing mode one by one (while loop)
if [[ -z ${filename} ]]; then
	echo "A CSV filename containing repo list is required. Listing available CSV repo files below:"
    ls -lah ${SVN_CSV_DIR}
    echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: syncsvn2git.sh -f svn-nippin.csv"
    exit 0
fi

if [[ -f ${SVN_CSV_DIR}/${filename} ]]; then
    echo "File $filename is a valid option containing SVN repos, only syncing repos already cloned:"
    SVN_CSV_FILE="$SVN_CSV_DIR/$filename"
   
	# checking if SVN credentials have been input
    if [[ -z ${usernameSVN} && -z ${passwordSVN} ]]; then
    	loginSVN
    fi
 
	if [[ ${PWD} != ${GIT_ROOT_DIR} ]]
    then
	   	cd "$GIT_ROOT_DIR"
    fi	

    # Start processing SVN repos:
    echo "Executing script $0 [syncing batch process] with PID $PID launched on $TIMESTAMP by $UID"

	listProjects=()
    	
	while IFS='|' read -r repo jenkins;
    do
   		# SVN repository name , e.g.: FOA, or Nippin_app
   		svnroot="${repo%/trunk/*}"
   		# SVN project name, e.g.: CHAP4, or combination project/modules name: big_leap_project/wcm_ws_modules
   		project="${repo##*trunk/}"
  		LOGFILE="$project.synced.$TIMESTAMP.log"
 		(
		checkProject "$repo"
        if [[ ${clonedStatus} == "OK" ]]; then
		 	echo "Project $project was already cloned, syncing operation will be executed:"
        	listProjects=(${listProjects[@]} ${project})
			cd "$GIT_ROOT_DIR/$project"
			
			# in case Git repo is already being used, activate this --rebase operation:
			#echo "git pull origin master --rebase in progress..."
			#git pull origin master --rebase
			#if [[ $? -ne 0 ]]; then
		    #	echo "Error during pull --rebase operation !" ;	errorSyncing=1
			#fi
    		
			if [[ -z $errorSyncing ]]; then
				echo "Updating authors list for $project ..."
	   			getAuthors
				echo "Fetching latest SVN commits for project $project in progress..."
        		git svn fetch && echo "svn fetch operation completed" || errorSyncing=1
			fi				

			if [[ -z $errorSyncing ]]; then
				#echo "Generating a .gitignore file based on Subversion's metadata svn:ignore properties if applicable:"
   				#git svn show-ignore >> .gitignore_synced &&	git add .gitignore_synced ; git commit -m "add .gitignore_synced for sync operation"
		
				echo "sync-rebase operation: Synchronize with the fetched commits..."
				java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" sync-rebase || errorSync=1
    		fi	
			
			# in case remove SVN branches and tags is needed, activate this clean-git operation (for 1 to 1 subrepo operation not needed: default!) 
			#if [[ -z ${errorSync} ]]; then
			#	echo "clean-git operation in progress..."
			#	echo "Notice that errors related with branches or tags not found are due to use sub-repo (repo/trunk/subrepo) instead of repo/trunk."
			#	java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" clean-git --force || errorSync=1
			#fi

			checkChanges=$(sudo git status | grep -i 'to be commited' | wc -l)
		    if [[ ${checkChanges} -gt 0 ]]; then	
				echo "Push to Bitbucket remote repository:"
				# project name in Bitbucket has max length, leaving last part only:
				project=$(echo $project | awk -F '/' '{print $(NF)}')
				git add --all
				git commit -m "Syncing Git repo with latest SVN commits"
           		git push -u origin master --tags || echo "error when pushing changes to Bitbucketm check logs !"
			else
				echo "There were no changes in the repo, nothing committed, therefore no push to Bitbucket was necessary" 
			fi
			echo "Logs for project $project are available here: /logs/$LOGFILE"
			echo "#############################################################################################################################"
		fi
    	) 2>&1 | tee -a "$EXECUTION_DIR/logs/$LOGFILE"
	done <"$SVN_CSV_FILE"
	echo -e "Projects specified under file $filename have been processed.\n"
	echo "Projects synced are listed below (if any):"
	echo "${listProjects[*]}"
else
	echo "Filename $filename does not exist in dir $SVN_CSV_DIR !"
	echo "Listing available CSV repo files:"
	ls -lah ${SVN_CSV_DIR}
	echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: syncsvn2git.sh -f svn-nippin.csv"
	exit 0
fi

echo "$0 execution with PID $PID launched on $TIMESTAMP by $UID has been completed."
