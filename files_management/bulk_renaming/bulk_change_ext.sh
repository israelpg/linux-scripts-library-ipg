#!/bin/bash

# either using the for loop with find:

for i in $(find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' \))
do
	mv $i ${i%.*}.gif 
done

ls -lah

# either using a find with xargs to process one by one:
