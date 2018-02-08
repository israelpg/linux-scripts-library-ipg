#!/bin/bash

#echo "Argument 1 passed when calling script is: $1"

#echo "Argument 1 still is: ${1}"

# using applicability above, here it goes:

path="${1:?Error, no argument has been passed as path when calling the script}"

echo "Path is: $path"



