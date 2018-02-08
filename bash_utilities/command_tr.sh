#!/bin/bash
echo $PATH | tr '\:' '\n'

# remove character in a string:

cat file.txt | tr -d 'x'

# tr blank space by a new line \n:

cat file.txt | tr ' ' '\n'
