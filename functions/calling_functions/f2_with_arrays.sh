#!/bin/bash

function function2()
{
	echo "index is $1"
	echo "value is $2"
	array1[$1]=$2
	echo ${array1[*]}
}

token=0
array1=()
index_array=-1

while [ $token -eq 0  ]
do
	let index_array++
	read -p 'Enter a number for the array: ' num
	function2 $index_array $num
	if [ $num -eq 5  ]
	then
		echo 'End of your array'
		token=1
	fi
done

num_items_array=${#array1[*]}
echo "The array you have built contains $num_items_array number of items"
echo 'These are the values:'
#echo ${array1[*]} | tr [':space:'] '\n'
echo ${array1[*]} | tr ' ' '\n'
