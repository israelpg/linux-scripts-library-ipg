#!/bin/bash
#
# IF ERROR WHEN CONVERTING  (no user) error,
# CHANGE ALL AUTHORS (no user) IN SVN LOG:
#
# svn log -q  file:///home/m999hfo/Documents/svn/dmg-modules | grep '(no author)' | cut -f 1 -d' '  | xargs -n1 svnadmin setrevprop /home/m999hfo/Documents/svn/dmg-modules  svn:author xxx.txt -r

# File Structure:
# 
# Current Directory: 
# 	convertsvn2git.sh 
#	svn-migration-scripts.jar
#	authors-dmg.txt (This will be generated)
#	/svn-repos-csv (Directory which contains all SVN csv repos files)
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
$0 -f <filename> for passing a CSV repo filename as argument. Example: conversvn2git.sh -f svn-nippin.csv
EOF
}

# This function uses "svn-migration-scripts" jar file to extract authors information from SVN
function getAuthors()
{
	java -jar "${CUR_DIR}/svn-migration-scripts.jar" authors $repo > "$AUTHORS-TMP-$$.txt"
        cat "${AUTHORS-TMP-$$}.txt" >> "${AUTHORS}.txt" 
}

# hv are options, do not have colon at the end, whereas f has colon : (expects an argument: filename)
while getopts "hvf:" OPTION
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
	f)
		filename=$OPTARG
		echo "Script $0 called passing CSV repo filename: $filename"
		echo "Checking if the file exists..."
		;;
	*)
		echo "No valid option passed when calling script $0"
		usage
		exit 1
		;;
	esac
done

PID=${$$}
UID=$(id -u)
ROOT_UID=0 # to check in case we require to run script as root
CREATE_AUTHORS=0
PUSH_TO_BITBUCKET=1
CUR_DIR="${PWD}"
AUTHORS="${CUR_DIR}/authors-dmg"
GIT_ROOT_DIR="/home/israel/git/svn-repos"

# SVN="file:///home/m999hfo/Documents/svn/dmg-modules/"
# SVN="svnrepos-nippin2.csv"

# In this directory are stored the different csv files, one for each SVN project
SVN_CSV_DIR="${CUR_DIR}/svn-repos-csv/"

# Checking if CSV file with list of SVN repos exists in the CSV directory
if [[ -f ${SVN_CSV_DIR}/${filename} ]]
then
    SVN_CSV_FILE="${SVN_CSV_DIR}/$1"
else
    echo "Filename $1 does not exist in dir $SVN_CVS_DIR"
    echo "Stopping $0 execution, please try with a valid filename"
    exit 1 
fi

# Create output dir if not exists
if [[ ! -d ${GIT_ROOT_DIR} ]]
then
    mkdir -p ${GIT_ROOT_DIR}
fi

cd ${GIT_ROOT_DIR}

#SVN="https://c501java@svn.oz501.be/svn/$PROJECT"
#BITB="{\"name\": \"$GIT_PROJECT_NAME\" , \"scmId\": \"git\"}"
#GITPROJECT="NIP2"

while IFS='|' read -r repo jenkins;
do
    cd "$GIT_ROOT_DIR"

    project="${repo##*/}"
    svnroot="${repo%/trunk/*}"

    echo "Converting $project ..."

    if [[ -d ${project} ]]; then
        rm -rf ${project}
    fi

#    mkdir "$project"
#    cd $project

    if [[ $CREATE_AUTHORS -eq 1 ]]; then
	getAuthors
    else

        git svn clone --authors-file="$AUTHORS.txt" --trunk="trunk/$project" --branches="branches/$project" --tags="tags/$project" $svnroot $project
        
	# If cloning operation is interrupted due to the size of the repository, execute a fetch command
	if [[ $? -ne 0 ]]
	then
		cd $project
		git svn fetch
	fi
	
	if [[ ${PWD} != "${$GIT_ROOT_DIR}/${project}" ]]
	then
		cd "$project"
	fi
	
	# Generating a .gitignore file based on Subversion's metadata
	git svn show-ignore >> .gitignore
        
	# Cleaning Subversion repository from Git
	java -Dfile.encoding=utf-8 -jar "$CUR_DIR/svn-migration-scripts.jar" clean-git --force
        
	# Convert git-svn tag branches to real tags
	for tag in `git branch --all | grep "tags/" | sed 's_remotes/origin/tags/__'`; do
            git tag -a -m"$tag" $tag remotes/origin/tags/$tag
        done

#	git init
        git add --all
        git commit -m "Initial commit to GIT"

        if [ $PUSH_TO_BITBUCKET -eq 1 ]; then
            BITB="{\"name\": \"$project\" , \"scmId\": \"git\"}"
            curl -X POST -u SVN:SVNPass "http://git.sdlc.gfdi.be/rest/api/1.0/projects/$GITPROJECT/repos" -H "Content-Type: application/json" -d "$BITB"
            git remote add origin ssh://git@git.sdlc.gfdi.be:7999/$GITPROJECT/$project.git
            git push -u origin master --tags
        fi
    fi

done <"$SVN_CSV_FILE"
