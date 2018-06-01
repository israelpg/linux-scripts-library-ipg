#!/bin/bash

# smoothing by bin means
# width determines the number of elements by bin
# mean is the average in a numeric attribute which has been previously sorted

set -o errexit
set -o nounset

arrayNumbers=(15,21,8,34,9,21,26,24,25,28,4,29,34)

# sorting numbers:

sortedNumbers=$(echo ${arrayNumbers[*]} | tr ',' '\n' | sort -nk 1)

# sorted elements in an array:

elementsArray=$(echo $sortedNumbers | tr ' ' ',')

arrayNSorted=(`echo ${elementsArray}`)

echo "echo ${arrayNSorted[*]} with ${#arrayNSorted[*]} elements"

# bin depth:
depth=4


