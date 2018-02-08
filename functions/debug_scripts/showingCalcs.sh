#!/bin/bash
# normal calculation using vars declared and values
num1=5
num2=6
let resultA=num1+num2
echo "num1 $num1 + num2 $num2 = "$resultA

# another way
num11=5
let num11=num11+6
echo "Same values, different way to proceed and get "$num11

set -x
# increments and so on ...
var44=10
let var44++
var55=20
let var55--
echo $var44
echo $var55

# Using the bc calculator ... via echo
numberTest=50
calcTest=`echo "$numberTest * 1.5" | bc` # if using var, needs ``
echo $calcTest

# Something similar
echo "50 * 1.5" | bc

set +x

cmd # this will break in the debug
