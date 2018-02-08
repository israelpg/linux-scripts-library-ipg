#!/bin/bash
if [ $UID -ne 0 ]; then
	echo 'Non root user right now. You must login as root to run this script.y
'
else
	echo 'Root User'
fi
