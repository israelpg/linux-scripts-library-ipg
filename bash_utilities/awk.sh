#!/bin/bash

# normal usage:

# printing second column:
cat /dir/filename.txt | awk '{print $2}'

# indicating a delimiter: -F (for instance a double colon :)
cat /dir/filename.txt | awk -F ':' '{print $2}'

# using a condition to evaluate to decide if printing or not:
[ip14aai@02DI20161235444 bash_programming]$ cat tests/input.txt 
column1:column2:column3
[ip14aai@02DI20161235444 bash_programming]$ cat tests/input.txt | awk -F ':' '{if ($2 != "ip14aai")  print $2}'
column2
