#!/bin/bash

echo 'Your terminal is main shell, you can declare a globar var there: var1=2'

var1=2

echo 'This var can be read inside a subshell:'

(echo $var1)

echo 'Modify this global var, which inside subshell is local:'

(let var1=$var1+1;  echo $var1)

echo 'In the main shell, the value of var1=2 never changed, because update was inside subshell'
echo $var1
