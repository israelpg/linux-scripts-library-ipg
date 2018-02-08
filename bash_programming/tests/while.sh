#!/bin/bash

# evaluating wheter the script is called with an argument for -i install or -v version-check
while getopts iv name
do
        case $name in
          i)iopt=1;;
          v)vopt=1;;
          *)echo "Invalid arg";;
       	esac
done

if [ ! -z $iopt ]
then
	echo "Yes, iopt exists, you typed -i argument"
fi

if [ ! -z $vopt ]
then
	echo "Well, vopt is the var that exists, -v argument then"
fi
