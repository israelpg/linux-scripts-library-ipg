#!/bin/bash
#
# Script name: fullproject_convertsvn2git.sh
# Version 1.0
# Rationale: Clone SVN repo/subrepos onto Git repo in order to migrate source control Dev projects
#
# How it works: SVN has the following structure: REPO / Subrepo1, Subrepo2 ...
# Example: FOA|
#			  | trunk   | cms_project, foa_modules ...
#			  | branches| *** a lot of branches ***
#		      | tags    | *** a lot of tags ***
#
# When calling this script, the SVN repo is indicated as follows: fullproject_convertsvn2git.sh -r <SVN_reponame> (e.g.: -r FOA)
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
$0 -l for listing SVN repo names
$0 -c for checking SVN to Git Clone Status and latest Sync date
$0 -r <SVN_reponame> :: Example: fullproject_convertsvn2git.sh -r FOA
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
echo "Getting Authors list for project $project..."
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
	r)
		reponame=$OPTARG
		echo "Script $0 called passing argument SVN reponame: $reponame"
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

if [[ -n ${reponame} ]]
then
	# checking if SVN credentials have been input
    if [[ -z ${usernameSVN} && -z ${passwordSVN} ]]; then
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

   	# Start processing SVN repos:
   	echo "Executing script $0 [cloning batch process] with PID $PID launched on $TIMESTAMP by $UID"

		listProjects=()
    	
		while IFS='|' read -r repo jenkins;
    	do
   			# SVN repository name , e.g.: FOA, or Nippin_app
   			svnroot="${repo%/trunk/*}"
   			# SVN project name, e.g.: CHAP4, or combination project/modules name: big_leap_project/wcm_ws_modules
   			project="${repo##*trunk/}"
            listProjects=(${listProjects[@]} ${project})
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

    		echo "SVN clone for project $project in progress..."
    		git svn clone --prefix="" --authors-file="$AUTHORS_DIR/$projectLog-authors.txt" --trunk="trunk/$project" --branches="branches/$project" \
    		--tags="tags/$project" ${svnroot} ${project}

    		# If cloning operation is interrupted due to the size of the repository, execute a fetch command
    		if [[ $? -ne 0 ]]; then
        		echo "Clone initially failed, fetching SVN repository for $project..."
        		cd ${project}
        		git svn fetch || echo "Error fetching code for $project !"
    		else
	    		echo "$project successfully cloned/fetched"  
			fi
	
    		cd ${project}

    		echo "Generating a .gitignore file based on Subversion's metadata svn:ignore properties if applicable:"
    		git svn show-ignore >> .gitignore
			if [[ $? -eq 0 ]]; then
				git add .gitignore ; git commit -m "Convert svn:ignore properties to .gitignore"
			fi
			
			echo "Clean the new Git repository, turning SVN branches/tags into local Git branches/tags:"
			java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" clean-git --force
			if [[ $? -ne 0 ]]; then
                echo "Clean operation for project $project returns errors !"
			fi
    		
			echo "Push to Bitbucket remote repository:"
			# project name in Bitbucket has max length, leaving last part only:
			project=$(echo $project | awk -F '/' '{print $(NF)}')
			git add --all
			git commit -m "Initial commit to Git repository"
			BITB="{\"name\": \"$project\" , \"scmId\": \"git\"}"
            curl -X POST -u SVN:SVNPass "http://git.sdlc.gfdi.be/rest/api/1.0/projects/$GITPROJECT/repos" -H "Content-Type: application/json" -d "$BITB"
            git remote add origin ssh://git@git.sdlc.gfdi.be:7999/$GITPROJECT/$project.git
            git push -u origin master --tags

			echo "Logs for project $project are available here: /logs/$LOGFILE"
    		
			exit 0

    		) 2>&1 | tee -a "$EXECUTION_DIR/logs/$LOGFILE"
		done <"$SVN_CSV_FILE"
		echo -e "Projects specified under file $filename have been processed.\n"
		echo "Projects cloned are listed below:"
		echo "${listProjects[*]}"
    else
   		echo "Filename $filename does not exist in dir $SVN_CSV_DIR !"
   		echo "Listing available CSV repo files:"
   		ls -lah ${SVN_CSV_DIR}
   		echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv"
   		exit 0
	fi
fi

echo "$0 execution with PID $PID launched on $TIMESTAMP by $UID has been completed."
