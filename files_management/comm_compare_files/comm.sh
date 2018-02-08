#!/bin/bash

# FIRST YOU NEED TO SORT THE FILES!!! AND PROBABLY DO A UNIQ AS WELL!!!

sort test1.txt -o test1.txt

cat test1.txt | uniq > test1.txt

sort test2.txt -o test2.txt

cat text2.txt | uniq > text2.txt

# now you can compare

comm test1.txt test2.txt

# first column is the uniq values in first file, 2nd column in the 2nd file, 3rd are the coincidences

# to get only the coincidence, remove 1st and 2nd columns

comm test1.txt test2.txt -1 -2
