#!/bin/bash
AUTHORS=authors-oz.txt
PROJECT=$1
GIT_PROJECT_NAME=$2
echo "Converting $PROJECT..."

SVN="https://c501java@svn.oz501.be/svn/$PROJECT"
BITB="{\"name\": \"$GIT_PROJECT_NAME\" , \"scmId\": \"git\"}"

if [ -d $GIT_PROJECT_NAME ]; then
 rm -rf $GIT_PROJECT_NAME
fi

#    java -jar /opt/svn-migration-scripts.jar authors $SVN > $AUTHORS
git svn clone --authors-file=$AUTHORS --trunk=/trunk --branches=/branches --tags=/tags $SVN $GIT_PROJECT_NAME

if [ $? -eq 0 ]; then
    echo "Conversion done."
    if [ -d $GIT_PROJECT_NAME ]; then

        cd $GIT_PROJECT_NAME

        git init
        git add --all
        git commit -m "Initial push to GIT"

        echo "Initial commit completed."

        java -Dfile.encoding=utf-8 -jar ../svn-migration-scripts.jar clean-git --force

        echo "svn migration..."

        for tag in `git branch --all | grep "tags/" | sed 's_remotes/origin/tags/__'`; do
            git tag -a -m"$tag" $tag remotes/origin/tags/$tag
        done

        echo "svn tags migration done."

        curl -X POST -u SVN:SVNPass "http://git.sdlc.gfdi.be/rest/api/1.0/projects/OZ/repos" -H "Content-Type: application/json" -d "$BITB"

        git remote add origin ssh://git@git.sdlc.gfdi.be:7999/OZ/$GIT_PROJECT_NAME.git
        git push -u origin master --tags

        echo "Pushed to GIT."
    fi
fi
