#!/bin/bash

echo 'Answer these questions, please: '
read -p 'Your favourite car: ' car1
read -p 'Your second favourite car: ' car2
read -p 'Your third favourite car: ' car3

echo "These are your top 3 cars: $car1, $car2 and $car3 "

# to call this script, automated: echo -e "F40\nAventador\nLFA" | ./interactive2.sh
