#!/bin/bash
# This script checkout in the output dir all projects listed in repolist file
repolist="./svnrepos.txt"
outputdir="~/Documents/workspace/cvstest"

cd "$output"

while IFS= read repo 
do
    echo "$repo"
    svn checkout $repo
done <"$repolist"
