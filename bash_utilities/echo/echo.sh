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
