#!/bin/bash

declare -i x=10
declare -i x=10
declare -i z=0

z=$(( $x + $y ))
# I could do: let z="$x+$y"
# or: z=$(echo "$x+$y | bc")

# in case x is not declared as integer with -i option, then ... it will have value 0
