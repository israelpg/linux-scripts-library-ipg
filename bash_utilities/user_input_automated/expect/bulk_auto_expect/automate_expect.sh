#!/usr/bin/expect
#Filename: automate_expect.sh , to automate input to interactive.sh in this same folder:

spawn ./interactive.sh
expect "Enter a number: "
send "$1\n"
expect "Enter a name: "
send "$2\n"
expect eof
