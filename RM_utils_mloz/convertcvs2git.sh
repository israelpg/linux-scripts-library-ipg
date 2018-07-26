#!/bin/bash
repolist="./cvsrepos-nippin.csv"
outputdir="/home/m999hfo/Documents/workspace/git_nippin"
gitproject="NIP2"


# create output dir if not existing
if [ ! -d $outputdir ]; then
    mkdir "$outputdir"
fi

cp "$repolist" "$outputdir"
cd "$outputdir"

while IFS='|' read -r repo module project
do
    repo="${repo/hudson/m999hfo}"
    gitrepo="$module"
    # take cvs module name as GIT repo name (2d parameter)
    git cvsimport -v -a -k -i -d $repo -C $gitrepo $module
    # git cvsimport -v -a -k -i -d $CVSROOT -C $GIT -A $AUTHORS $CVSMODULES

    if [ $? -eq 0 ]; then
        if [ -d $gitrepo ]; then

            echo "$module converted"

            cd $gitrepo

#            git add --all
#            git commit -m "Initial push to GIT"

            # create git repos
            BITB="{\"name\": \"$gitrepo\" , \"scmId\": \"git\"}"
            curl -X POST -u SVN:SVNPass "http://git.sdlc.gfdi.be/rest/api/1.0/projects/$gitproject/repos" -H "Content-Type: application/json" -d "$BITB"

            git remote add origin ssh://git@git.sdlc.gfdi.be:7999/$gitproject/$gitrepo.git
            git push -u origin master --tags

            echo "Pushed to GIT."
        fi
    fi


done <"$repolist"
