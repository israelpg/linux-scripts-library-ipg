#!/bin/bash

# Synchronization SVN / Git: Fetching latest commits from SVN into Git repo, then clean SVN and push changes

# update authors file
git config snv.authorsfile ${AUTHORS_DIR}/${project-authors}.txt

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

