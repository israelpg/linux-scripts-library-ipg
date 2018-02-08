#!/usr/bin/expect
#Filename: automate_expect.sh , to automate input to interactive.sh in this same folder:

spawn ./interactive.sh
expect "Enter a number: "
send "23\n"
expect "Enter a name: "
send "Israel\n"
expect eof
