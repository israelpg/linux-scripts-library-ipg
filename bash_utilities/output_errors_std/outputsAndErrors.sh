#!/bin/bash

# 2 is for error output, and 1 for standard output/correct

# example, forcing an error with wrong command ls +

ls + 2> error.txt 1> output.txt # output.txt will be empty, error.txt has error

ls -lah 2> error.txt 1> output.txt # opposite, output has result of command, error empty

# same by doing this:

ls -lah &> anyOutput.txt # either error or correct, output is here anyway

# another option ... just put in output file the correct output stdout, avoid stderr

echo a1 > a1
cp a1 a2
cp a1 a3
chmod 000 a1 # nobody can read it, a cat will give error
cat a* | tee -a output.txt | cat -n # tee just redirects stdout no stderr into the file

### best for programming output:::
2>&1 | tee -a $pathLog # stderror redirected to stdout in the screen, plus tee redirection of correct output to log file

# creating a file descriptor with exec to use as input in a command

exec 5<input.txt
# no I am able to use this file descriptor 5 with input.txt content to run a command
cat<&5

# same, file descriptor,  but for writing mode:

exec 5>output.txt # does not exist, anyway, exec to write there as from now on
echo newline >&5
cat output.txt
# displays: newline

# for append in writing mode:
exec 6>>output.txt
echo appended line >&6
cat output.txt
# displays:
# newline
# appended line
