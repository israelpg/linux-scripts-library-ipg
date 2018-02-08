#!/bin/bash

SUCCESS=0
E_NOARGS=65

if [[ -z "$1" ]]
then
	echo "No argument has been provided, you must specify a package name when calling this script"
	exit $E_NOARGS
fi

check_package ()
{
	dpkg -l $1
}

echo "Checking availability of package $1"
check_package $1
if [ "$?" -eq 0 ]
then
	echo "Great, you can install package $1"
else
	echo "Nope, you cannot install package $1"
fi
echo "Check logs in /tmp folder"

exit 0
