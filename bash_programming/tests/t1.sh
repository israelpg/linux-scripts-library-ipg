#!/bin/bash
#File created on 2018-04-02
#Author: israel

if (( $1 > 5  ))
then
	echo "You have passed the exam"
else
	echo "You failed, try again please"
fi

exit 0
