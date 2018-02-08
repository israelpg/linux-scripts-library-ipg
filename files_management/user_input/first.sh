#!/bin/bash

echo 'Hello, type your username and password:'

read -p 'Username: ' uservar 	#p prompt
read -sp 'Password: ' passvar	#sp silent prompt

echo "Thanks $uservar. You are now logged in!"
