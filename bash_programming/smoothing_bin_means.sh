#!/bin/bash

# smoothing by bin means
# width determines the number of elements by bin
# mean is the average in a numeric attribute which has been previously sorted

set -o errexit
set -o nounset

arrayNumbers=(15 21 8 34 9 21 26 24 25 28 4 29 34)
arrayLength=${#arrayNumbers[*]}
arraySorted=()

# building array with sorted numbers:
while read line
do
	arraySorted+=(${line})
done < <(echo ${arrayNumbers[*]} | tr ' ' '\n' | sort -nk 1)

echo "arraySorted elements --> ${arraySorted[*]} -- length --> ${#arraySorted[*]} elements"

# bin depth and id for first Bin array:
depth=4
idBin=1
count=0

for (( i=0 ; i<${arrayLength} ; i++ ))
do
	if [[ $count < $depth ]]
	then
                eval "bin${idBin}+=(`echo ${arraySorted[$i]}`)"
		let count++
	else
		let idBin++
                eval "bin${idBin}+=(`echo ${arraySorted[$i]}`)"
		count=1
	fi
done

echo "testing ... bin1 --> ${bin1[*]} bin2 --> ${bin2[*]} bin3 --> ${bin3[*]} bin4 --> ${bin4[*]}"

# displaying bin by bin with elements:
#for (( i=1 ; i<=${idBin} ; i++ ))
#do
#	echo "Bin with id $i contains elements: ${bin$i[*]}"
#done
