#!/bin/bash

# concatenate file and displays content in a single line

cat example.txt | xargs

# listing elements in specified number per line

cat example.txt | xargs -n 2

# using a delimiter like x

echo 'firstxsecondxthirdxfourth' | xargs -d 'x'
