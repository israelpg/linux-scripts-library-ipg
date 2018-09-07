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
if [[ -n ${filename} ]]
then
	if [[ -f ${SVN_CSV_DIR}/${filename} ]]; then
    	echo "File $filename is a valid option containing SVN repos, syncing only for already cloned repos..."
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
            listProjects=(${listProjects[@]} ${project})
  			LOGFILE="$project.synced.$TIMESTAMP.log"

   			(
    		if [[ -d ${project} ]]; then
           
			 	echo "Project $project was already cloned, syncing operation will be executed..."
			
				echo "Updating authors list for $project ..."
	   			getAuthors

    			echo "Fetching latest SVN commits for project $project in progress..."
        		cd ${project} && git svn fetch
				
				if [[ $? -eq 0 ]]; then
					#echo "Generating a .gitignore file based on Subversion's metadata svn:ignore properties if applicable:"
    				#git svn show-ignore >> .gitignore_synced &&	git add .gitignore_synced ; git commit -m "add .gitignore_synced for sync operation"
					echo "Synchronize with the fetched commits..."
					java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" sync-rebase || errorSync=1
				else
					echo "Error fetching new SVN commits for $project !" && errorSync=1
				fi
    		
				if [[ -z ${errorSync} ]]; then
					java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" clean-git --force
					echo "Push to Bitbucket remote repository:"
					# project name in Bitbucket has max length, leaving last part only:
					project=$(echo $project | awk -F '/' '{print $(NF)}')
					git add --all
					git commit -m "Syncing Git repo with latest SVN commits"
            		git push -u origin master --tags || echo "error when pushing changes to Bitbucketm check logs !"
					echo "Logs for project $project are available here: /logs/$LOGFILE"
				fi
			fi
    		) 2>&1 | tee -a "$EXECUTION_DIR/logs/$LOGFILE"
		done <"$SVN_CSV_FILE"
		echo -e "Projects specified under file $filename have been processed.\n"
		echo "Projects synced are listed below:"
		echo "${listProjects[*]}"
    else
   		echo "Filename $filename does not exist in dir $SVN_CSV_DIR !"
   		echo "Listing available CSV repo files:"
   		ls -lah ${SVN_CSV_DIR}
   		echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: syncsvn2git.sh -f svn-nippin.csv"
   		exit 0
	fi
fi

echo "$0 execution with PID $PID launched on $TIMESTAMP by $UID has been completed."
