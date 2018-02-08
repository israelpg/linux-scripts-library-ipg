#!/bin/bash

count=1
for i in $(find . -maxdepth 1 -type f \( -iname '*.txt' -o -iname '*.html' \))
do
	new=document-$count.${i##*.} # slice and keep extension
	echo "Renaming $i to $new"
	mv "$i" "$new"
	let count++
done
