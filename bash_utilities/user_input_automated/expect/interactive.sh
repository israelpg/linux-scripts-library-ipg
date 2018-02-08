#!/bin/bash

read -p 'Enter a number: ' num
read -p 'Enter a name: ' name

echo "You have entered number $num and name $name"

# now, you can call the script interactive.sh passing the arguments with echo -e, see below:

# echo -e "1\nhello\n" | /.interactive.sh
