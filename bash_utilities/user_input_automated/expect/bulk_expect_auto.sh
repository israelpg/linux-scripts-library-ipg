#!/usr/bin/expect

spawn ./interactive.sh
expect "Enter a number: "
send "$i\n"
expect "Enter a name: "
send "$i-user\n"
expect eof
