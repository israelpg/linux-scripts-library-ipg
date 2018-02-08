#!/bin/bash

# intersection between two SORTED files to check differences, then we can list different outputs:

echo '# 1. Sorting both files'

sort A.txt -o A.txt ; sort B.txt -o B.txt # output is the file itself, sorted of course

echo '# 2. Then we can make a simple output of 3 columns (1st is only in A, 2nd in B, 3rd INTERSECTION):'

comm A.txt B.txt

echo '# 3. Now the output with INTERSECTIONS (similarities, same lines in both files):'

comm A.txt B.txt -1 -2 # remove column 1 and column 2 (1st and 2nd)

echo '# 4. Only output with lines that are only in A.txt 1st file:'

comm A.txt B.txt -2 -3

echo '# 5. Only output with lines only in B.txt or 2nd file:'

comm A.txt B.txt -1 -3

echo '# 6. Output with differences:'

comm A.txt B.txt -3

echo '# SAME but in a single column instead of col 1 and col 2:'

comm A.txt B.txt -3 | sed 's/^\t//'

