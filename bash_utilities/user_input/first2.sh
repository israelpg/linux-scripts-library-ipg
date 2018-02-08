#!/bin/bash

echo 'Hello, type your username and password:'
set -x
read -p 'Username: ' uservar 	#p prompt
read -sp 'Password: ' passvar	#sp silent prompt
set +x
echo "Thanks $uservar. You are now logged in!"
