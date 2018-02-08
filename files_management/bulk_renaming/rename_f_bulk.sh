#!/bin/bash

count=1
# i contiene el resultado de cada file encontrado en el find:
for i in $(find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' \)) # find files, 1 by 1 in i
do
	new=image-$count.${i##*.} # var for new filename incl slice and keep extension
	echo "Renaming $i to $new"
	mv "$i" "$new"
	let count++
done
