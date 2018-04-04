#!/bin/bash

echo $var1

echo "var1"

echo "${var1}plusthis" 

echo 'This does not process special chars as $, then pizza costs $5.25'
echo "Or you can use backslash using double quotes: pizza costs \$5.25"

# to process backslashed special chars:

echo -e "First line \n Second line"
echo -e "First column \t Second column"
echo -e "First value \r Second value"

# Therefore, you can use double quotes and backslash to take adv of special chars !!!

# Color output:
# dark red color:
echo -e "\e[0;31m text \e[0m"
# light red color, note the number 1 instead of 0 before ;
echo -e "\e[1;31m text \e[0m"
# other colors: 33 yellow, 36 blue ... from 40 to 47 are background colors
