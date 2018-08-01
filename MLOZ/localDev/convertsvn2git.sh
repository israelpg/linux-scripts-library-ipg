#!/bin/bash
#
# Script name: convertsvn2git.sh
# Version 1.1
# Rationale: Convert svn repos into git in order to migrate source control tool
#
# HANS
# IF ERROR WHEN CONVERTING  (no user) error,
# CHANGE ALL AUTHORS (no user) IN SVN LOG:
# 
# svn log -q  file:///home/m999hfo/Documents/svn/dmg-modules | grep '(no author)' | cut -f 1 -d' '  | xargs -n1 svnadmin setrevprop /home/m999hfo/Documents/svn/dmg-modules  svn:author xxx.txt -r
# HAND-END

# File Structure:
# 
# Execution Directory: (Git repo will be created in another directory) 
# 	convertsvn2git.sh 
#	svn-migration-scripts.jar
#	authors-dmg.txt (This will be generated)
#	/authors
#	/svn-repos-csv (Directory which contains all SVN csv repos files)
#       /logs
# 
# Git Root Directory, e.g.: /home/israel/git/svn-repos (If doesn't exist, script will create it)
#

# Instructions
usage()
{
cat << EOF
Script $0 help instructions:
$0 -h for help
$0 -v for version number
$0 -l for listing CSV repo files
$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv
EOF
}

# enter SVN credentials:
loginSVN()
{
read -p "Enter your SVN username: " usernameSVN
read -sp "Type your SVN password: " passwordSVN
}

# This function uses "svn-migration-scripts" jar file to extract authors information from SVN
function getAuthors()
{
	echo "Getting Authors for $project..."
	java -jar "$EXECUTION_DIR/svn-migration-scripts.jar" authors $svnroot/trunk/$project $usernameSVN $passwordSVN > "$AUTHORS_DIR/$project-authors-tmp-$$.txt"
        cat "$AUTHORS_DIR/$project-authors-tmp-$$.txt" >> "$AUTHORS_DIR/$project-authors.txt" 
}

# hvl are options, do not have colon at the end, whereas f has colon : (expects an argument: filename)
while getopts "hvlf:" OPTION
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
		echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv"
		exit 0
		;;
	f)
		filename=$OPTARG
		echo "Script $0 called passing CSV repo filename: $filename"
		echo "Checking if file exists..."
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
TIMESTAMP=$(date)
LOGFILE="$CURRENT_DATE.svnrepos.$$.log"
PUSH_TO_BITBUCKET=0
EXECUTION_DIR="$PWD"
AUTHORS_DIR="$EXECUTION_DIR/authors"
# Define the Git directory:
GIT_ROOT_DIR="/home/israel/git/svn-repos"

# In this directory are stored the different csv files, one for each SVN project
SVN_CSV_DIR="$EXECUTION_DIR/svn-repos-csv"

if [[ $# -eq 0 ]]
then
    echo "You haven't passed any argument when calling script"
    echo "Type $0 -h for displaying help info"
    exit 1
fi

# Checking if CSV file with list of SVN repos exists in the CSV directory

if [[ -f ${SVN_CSV_DIR}/${filename} ]]
then
    SVN_CSV_FILE="$SVN_CSV_DIR/$filename"
else
    echo "Filename $filename does not exist in dir $SVN_CVS_DIR"
    echo "Stopping $0 execution, please try with a valid filename"
    exit 1
fi

# Create output dir if not exists
if [[ ! -d ${GIT_ROOT_DIR} ]]
then
    mkdir -p ${GIT_ROOT_DIR}
fi

cd ${GIT_ROOT_DIR}

loginSVN

# Start processing CSV repo file:

echo "Executing script $0 with PID $PID launched on $TIMESTAMP by $UID"
while IFS='|' read -r repo jenkins;
do
    if [[ ${PWD} != ${GIT_ROOT_DIR} ]]
    then	
	cd "$GIT_ROOT_DIR"
    fi

    #project=$(echo $repo | awk -F '/' '{print $(NF-1)}')
    
    project=$(echo "${repo##*trunk}" | awk -F '/' '{print $2}')
    svnroot="${repo%/trunk/*}"

    echo "Converting $project ..."

    if [[ -d ${project} ]]; then
        rm -rf ${project}
    fi

    if [[ ! -f ${AUTHORS_DIR}/${project}-authors.txt} ]]; then
	getAuthors
    fi

    echo "svn clone for project $project in progress..."
    git svn clone --authors-file="$AUTHORS_DIR/$project-authors.txt" --trunk="trunk/$project" --branches="branches/$project" \
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
        
    echo "Cleaning Subversion repository from Git"
    java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" clean-git --force
       
    echo "Convert git-svn tag branches to real tags"
    for tag in `git branch --all | grep "tags/" | sed 's_remotes/origin/tags/__'`; do
        git tag -a -m"$tag" ${tag} remotes/origin/tags/${tag}
    done

    echo "Git: Adding code and initial commit for pushing changes"
    git add --all
    git commit -m "Initial commit to GIT - importing SVN repo from file $filename"

    #if [ $PUSH_TO_BITBUCKET -eq 1 ]; then
    #    BITB="{\"name\": \"$project\" , \"scmId\": \"git\"}"
    #    curl -X POST -u SVN:SVNPass "http://git.sdlc.gfdi.be/rest/api/1.0/projects/$GITPROJECT/repos" -H "Content-Type: application/json" -d "$BITB"
    #    git remote add origin ssh://git@git.sdlc.gfdi.be:7999/$GITPROJECT/$project.git
    #    git push -u origin master --tags
    #fi

done <"$SVN_CSV_FILE"
#) 2>&1 | grep -v 'm999' | tee -a "$EXECUTION_DIR/logs/$LOGFILE"
