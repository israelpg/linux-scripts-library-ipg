#!/bin/bash
ls -lah
date "+%D"
time
read -p 'Guess a number, please: ' var1
token=0
num_guesses=1

while [ $token -eq 0 ]
do
	if [ $var1 -eq 5 ]
	then
		token=1
		echo "Well done! With $num_guesses number of guesses"
	else
		let num_guesses++
		read -p 'Wrong number. Try again: ' var1
	fi
done
