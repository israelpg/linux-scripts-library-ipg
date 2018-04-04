#!/bin/bash

cat test1.txt | tail -n 5 # it shows the last 5 lines

cat test1.txt | tail -n +2 # it shows all the lines except the first line 

# in the case of head:

cat test1.txt | head -n 5 # displaying the first five lines of the file

cat test1.txt | head -n -2 # displaying all the lines except the last two lines
