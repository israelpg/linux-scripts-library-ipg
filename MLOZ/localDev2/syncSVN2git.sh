#!/bin/bash

# Script Name: syncSVN2git.sh
# Version: 1.0
# Author: Israel (RM Team)
# Rationale: Synchronization SVN / Git: Fetching latest commits from SVN into Git repo, then clean SVN 
# and push changes to remote Git repo

# Functions Declaration:

# Instructions
usage()
{
cat << EOF
Script $0 help instructions:
$0 -h for help
$0 -v for version number
$0 -l for listing SVN repo projects to be synchronized
$0 -c for checking SVN to Git Sync Status for each project cloned
$0 -p <project> for passing a project name as argument. Example: syncSVN2git.sh -p CHAP4
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
                echo"Listing SVN repo projects to be synchronized"
                ls -lah svn-repos-csv/
                echo -e "\n"
                echo "$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv"
                exit 0
                ;;
        c)
                ./syncStatus.sh && exit 0 || echo "Script syncStatus.sh has failed" ; exit 1
                ;;
        p)
                project=$OPTARG
                echo "Script $0 called passing project name argument as: $project"
                echo "Checking if project exists..."
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
LOGFILE="$TIMESTAMP.svnrepos.log"
PUSH_TO_BITBUCKET=0
EXECUTION_DIR="$PWD"
AUTHORS_DIR="$EXECUTION_DIR/authors"
# Define the Git directory:
GIT_ROOT_DIR="/home/israel/git/svn-repos-v_1_2"
# In this directory are stored the different csv files, one for each SVN project
#PROJECTS_DIR="$EXECUTION_DIR/svn-repos-csv"

if [[ $# -eq 0 ]]
then
    echo "You haven't passed any argument when calling script"
    echo "Type $0 -h for displaying help info"
    exit 1
fi

# checking if SVN credentials have been input
if [[ -z ${usernameSVN} && -z ${passwordSVN} ]]
then
    loginSVN
fi

# updating authors file, same operation as with cloning script, in case there are new authors
getAuthors

# fetching new SVN commits
git svn fetch

# cleaning SVN from Git repo
echo "Cleaning Subversion repository from Git"
java -Dfile.encoding=utf-8 -jar "$EXECUTION_DIR/svn-migration-scripts.jar" clean-git --force

# pushing changes to Git remote repo
echo "Git: Adding code and initial commit for pushing changes"
git add --all
git commit -m "Initial commit to GIT - importing SVN repo from file $filename"

echo "pushing to bitbucket temporarily disabled ... script ends here for now !!!"
#if [ $PUSH_TO_BITBUCKET -eq 1 ]; then
#    BITB="{\"name\": \"$project\" , \"scmId\": \"git\"}"
#    curl -X POST -u SVN:SVNPass "http://git.sdlc.gfdi.be/rest/api/1.0/projects/$GITPROJECT/repos" -H "Content-Type: application/json" -d "$BITB"
#    git remote add origin ssh://git@git.sdlc.gfdi.be:7999/$GITPROJECT/$project.git
#    git push -u origin master --tags
#fi

