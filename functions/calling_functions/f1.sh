#!/bin/bash

# declare function

function function1()
{
	let result=$1*2 # takes parameter number 1 which is $1, if number 2 then $2...
}

read -p 'Enter a number to multiply by 2: ' num1

function1 $num1 # passing arg to function function1

echo "The result is: $result"
