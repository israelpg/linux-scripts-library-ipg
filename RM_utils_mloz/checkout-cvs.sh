#!/bin/bash
# This script checkout in the output dir all projects listed in repolist file
repolist="./cvsrepos.csv"
outputdir="/mnt/cvsifs"

mount -t cifs //gfdi.gfdi.be/ROOT/home/ARCAD/MT "$outputdir" -o rw,noperm,user=m999hfo,password=welcome01,vers=1.0

cd "$outputdir"

while IFS='|' read -r repo module project
do
    repo="${repo/hudson/m999hfo}"
    echo "$repo"
    cvs -d $repo checkout $module
done <"$repolist"

umount "$outputdir"
