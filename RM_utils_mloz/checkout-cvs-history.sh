#!/bin/bash
#
# Checkout CVS file changed since a given date
#
# Author m999hfo
# Date 30/05/2018  Initial version
# TODO inject repo
# TODO do not checkout utilities repos (bdc modules for example)
# TODO do not checkout pom.xml files
#
 
repo=$1
outputdir="$PWD/src"
history="history.txt"

# create output dir if not existing
if [ ! -d $outputdir ]; then
    mkdir "$outputdir"
fi

# ask CVS for changes since yesterday
histdate="$(date -d '-1 day' +%Y-%m-%d)"
echo "Searching for changes since $histdate"

# check all changes for repo
export CVSROOT=$repo
cvs history -a -c -D "$histdate" -l > "$outputdir/$history"
cd $outputdir

# checkout each file
# M 2018-05-28 15:31 +0000 m999mdh 1.51       index.html               bdc2_modules/IDS_Home_Page/src                                                                                                                       == <remote>
while IFS=' ' read -r status date time timezone user version filename filepath remotepath
do
    cvs checkout "$filepath/$filename"
done <"$history"
