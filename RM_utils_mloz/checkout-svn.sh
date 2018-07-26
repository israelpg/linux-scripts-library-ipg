#!/bin/bash
# This script checkout in the output dir all projects listed in repolist file
repolist="./svnrepos.csv"
outputdir="/mnt/svnifs"

mount -t cifs //gfdi.gfdi.be/ROOT/home/ARCAD/MT "$outputdir" -o rw,noperm,user=m999hfo,password=welcome01,vers=1.0

cp $repolist $outputdir
cd $outputdir

while IFS='|' read repo project
do
    echo "$repo"
    svn checkout $repo
done <"$repolist"

umount "$outputdir"
