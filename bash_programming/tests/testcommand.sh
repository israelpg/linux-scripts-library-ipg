#!/bin/bash

set -o errexit
set -o nounset

read -p "Enter a filename: " iopt

if [[ ! -z $iopt ]]
then
{
wd=$(pwd)
echo "pwd is $wd"
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
echo "ls -lah /tmp/scriptname"
ls -lah /tmp/scriptname
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
touch scriptname
# create as root su -c the binary for execution:
#su -c "cp $scriptname /usr/bin/monitor" root && echo "Congratulations! Script Installed, now run monitor Command" || echo "Installation failed"
}
fi

