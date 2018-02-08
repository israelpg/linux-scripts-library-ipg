#!/bin/bash

# check number
function f_check_num()
{
echo $1
echo $2
	if [ $1 -gt $2 ]
	then
                let num_guesses++
                echo 'Too big, try again.'
	elif [ $1 -lt $2 ]
	then
		let num_guesses++
		echo 'Too small, try again.'
	else
		let token++
		echo 'Well done! You got it! :)'
	fi
}

# generate random number to guess
num=$(shuf -i 1-10 -n 1)
echo $num

token=0
num_guesses=1

while [ $token -eq 0 ]
do
	read -p 'Guess the number with range 1-10: ' guess
	f_check_num $guess $num
done

echo "You needed $num_guesses times to got it."
