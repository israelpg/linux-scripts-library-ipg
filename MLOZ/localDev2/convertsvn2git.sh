#!/bin/bash
#
# Script name: convertsvn2git.sh
# Version 1.2
# Rationale: Convert svn repos into git in order to migrate source control tool
# Notes: Compared with Version 1.1 this script deals with modules folders related with release jobs like projects, 
#        instead of processing all project itself
# 
# Example: http://svn.gfdi.be/svn/FOA/trunk/big_leap_project/wcm_ws_modules
# For SVN the project is big_leap_project (dealt as so in version 1.1)
# In version 1.2, the project is wcm_ws_modules, which is actually built via Jenkins job, and not the whole SVN project
# 
# File Structure:
# 
# Execution Directory: (Git repo will be created in another directory) 
# 	convertsvn2git.sh
#	cloneStatus.sh
#	syncSVN2git.sh 
#	svn-migration-scripts.jar
#	/authors
#	/svn-repos-csv (Directory which contains all SVN csv repos files)
#       /logs
# 
# Git Root Directory, e.g.: /home/israel/git/svn-repos (If doesn't exist, script will create it)
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
$0 -f <filename> for passing a CSV repo filename as argument. Example: convertvn2git.sh -f svn-nippin.csv
$0 -s <project> Sync & Push: To sync SVN/Git cloned repos, fetching latest commits and pushing remotely: convertsvn2git.sh -s CHAP4
EOF
}

# enter SVN credentials:
loginSVN()
{
read -p "Enter your SVN username: " usernameSVN
read -sp "Type your SVN password: " passwordSVN
echo "Checking credentials..."
}

# This function uses "svn-migration-scripts" jar file to extract authors information from SVN
function getAuthors()
{
echo "Getting Authors for $project..."
projectLog=$(echo $project | awk -F '/' '{print $(NF-1)}')
java -jar "$EXECUTION_DIR/svn-migration-scripts.jar" authors $repo $usernameSVN $passwordSVN > "$AUTHORS_DIR/$projectLog-authors.txt"
if [[ $? -ne 0 ]]
then
	echo "Wrong credentials, stopping $0 execution..."
	exit 1
fi
}

# hvl are options, do not have colon at the end, whereas f has colon : (expects an argument: filename)
while getopts "hvlcf:s:" OPTION
do
	case $OPTION in
	h)
		echo "Listing help"
		usage
		exit 0
		;;
	v)
		echo "$0 Version 1.1"
		exit 0
		;;
	
	l)
		echo "Listing CSV repo files:"
		ls -lah svn-repos-csv/
		echo -e "\n"
		echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv"
		exit 0
		;;
	c)
		./cloneStatus.sh && exit 0 || echo "Script cloneStatus.sh has failed" ; exit 1
		;;
	f)
		filename=$OPTARG
		echo "Script $0 called passing CSV filename with repos to clone: $filename"
		echo "Checking if file exists..."
		;;
	s)
		syncName=$OPTARG
		echo "Script $0 called passing CSV filename $syncName to sync cloned repos in batch mode"
		echo "Checking if each repo/project exists and has already been cloned... only cloned repo/projects are synced"
		;;
	*)
		echo "No valid option passed when calling script $0"
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
# In this directory are stored the different csv files, one for each SVN project
SVN_CSV_DIR="$EXECUTION_DIR/svn-repos-csv"

if [[ $# -eq 0 ]]
then
    echo "You haven't passed any argument when calling script"
    echo "Type $0 -h for displaying help info"
    exit 1
fi

# For option -f : Checking if CSV file with list of SVN repos exists in the CSV directory
# repos in the file will be cloned in a batch mode process (while loop)
if [[ -n ${filename} ]]
then
	if [[ -f ${SVN_CSV_DIR}/${filename} ]]; then
    	echo "File $filename is a valid option, proceeding..."
    	SVN_CSV_FILE="$SVN_CSV_DIR/$filename"
   
		# checking if SVN credentials have been input
        if [[ -z ${usernameSVN} && -z ${passwordSVN} ]]
        then
            loginSVN
        fi
 
    	# Create output dir if not exists
    	if [[ ! -d ${GIT_ROOT_DIR} ]]
    	then
        	mkdir -p ${GIT_ROOT_DIR}
    	fi

		if [[ ${PWD} != ${GIT_ROOT_DIR} ]]
    	then
	    	cd "$GIT_ROOT_DIR"
    	fi	

    	# Start processing CSV repo file:
    	echo "Executing script $0 [cloning batch process] with PID $PID launched on $TIMESTAMP by $UID"

		listProjects=()
    	
		while IFS='|' read -r repo jenkins;
    	do
   			# SVN repository name , e.g.: FOA
   			svnroot="${repo%/trunk/*}"

   			# SVN project name, e.g.: Nippin, or project/modules_folder: big_leap_project/wcm_ws_modules
   			project="${repo##*trunk/}"
 
  			LOGFILE="$project.cloned.$TIMESTAMP.log"
   			(
    		echo "Converting SVN project $project into Git local repository..."

    		if [[ -d ${project} ]]; then
            	echo "Project $project was already cloned or attempted to be cloned, re-executing cloning operation..."
            	rm -rf ${project}
    		fi

    		if [[ ! -f ${AUTHORS_DIR}/${project}-authors.txt} ]]; then
        		getAuthors
    		fi

    		echo "svn clone for project $project in progress..."
    		git svn clone --authors-file="$AUTHORS_DIR/$projectLog-authors.txt" --trunk="trunk/$project" --branches="branches/$project" \
    		--tags="tags/$project" ${svnroot} ${project}

    		# If cloning operation is interrupted due to the size of the repository, execute a fetch command
    		if [[ $? -ne 0 ]]
    		then
        		echo "Fetching SVN repository for $project..."
        		cd $project
        		git svn fetch
    		fi
	
	    	echo "$project cloned/fetched ..."  
    		cd "$project"

    		echo "Generating a .gitignore file based on Subversion's metadata"
    		git svn show-ignore >> .gitignore

			listProjects+="$project"
    		echo "Logs for project $project are available here: /logs/$LOGFILE"
    		exit 0

    		) 2>&1 | tee -a "$EXECUTION_DIR/logs/$LOGFILE"
		done <"$SVN_CSV_FILE"
		echo "All projects specified under file $filename have been cloned"
		echo "Projects cloned are listed below:"
		echo "${listProjects[*]}"
		echo ""
    else
   		echo "Filename $syncName does not exist in dir $SVN_CVS_DIR"
   		echo "Listing available CSV repo files:"
   		ls -lah ${SVN_CSV_DIR}
   		echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv"
   		exit 0
	fi
fi

# For option -s <filename>: Checking for each listed repo if it has been cloned, if so then sync batch processing
if [[ -n ${syncName} ]]
then 
	if [[ -f ${SVN_CSV_DIR}/${syncName} ]]
	then
		echo "Sync file $syncName is a valid option, proceeding..."
    	SYNC_FILE="$SVN_CSV_DIR/$syncName"
		echo "Checking for repos already cloned to be synced..."
    	# checking if SVN credentials have been input
    	if [[ -z ${usernameSVN} && -z ${passwordSVN} ]]
    	then
        	loginSVN
    	fi
	
		if [[ ${PWD} != ${GIT_ROOT_DIR} ]]
    	then
    		cd "$GIT_ROOT_DIR"
   	 	fi

        listProjects=()

		while IFS='|' read -r repo jenkins;
    	do			
        	# SVN project name, e.g.: Nippin, or project/modules_folder: big_leap_project/wcm_ws_modules
        	project="${repo##*trunk/}"

			# if project was cloned, can be synced:
			checkProject=$(find ~/git/svn-repos-v_1_2/ -maxdepth 2 | grep ${project})
			
			if [[ -n ${checkProject} ]]
			then
				LOGFILE="$project.synced.$TIMESTAMP.log"
				(
				echo "Project $project will be synced..."
				# getAuthors done if already cloned, but is always good to check for updates (new authors)
	    		getAuthors
				
				#cd ${GIT_ROOT_DIR}/${projec}
    			# update Git repository's remote branches
				echo "Updating Git repository's remote branches for project $project..."
    			#git svn fetch $usernameSVN $passwordSVN || echo "Error while updating Git repository's remote branches" ; exit 1

    			echo "# sync with the fetched commits, rebase fetched commits onto local branches, matching remote counterparts..."
    			#java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" sync-rebase $usernameSVN $passwordSVN
    			#if [[ $? -ne 0 ]]
				#then
    			#	echo "Error during sync-rebase fetching commits onto local branches"
    			#	exit 1
				#fi
				
				listProjects=(${listProjects[@]} ${project})
				) 2>&1 | tee -a "$EXECUTION_DIR/logs/$LOGFILE"
			fi
    	done <"$SYNC_FILE"
		
		echo "All cloned projects specified under file $filename have been synced"
        echo "Projects synced are listed below:"
        echo "${listProjects[*]}"
        echo ""

	else    
		echo "The CSV sync file $syncName does not exist !" 
    	echo "$0 -l <filename> for listing valid CSV repo files"
    	exit 1
	fi
fi

echo "$0 execution with PID $PID launched on $TIMESTAMP by $UID has been completed."
