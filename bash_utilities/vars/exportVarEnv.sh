#!/bin/bash
VAR232='First word' # I use single quotes because I enter more than one word
export VAR232 # export, now it is an env var
VAR232="$VAR232 plus this text" # Doble quotes, so that I get var value
env | grep 'VAR232'
echo $VAR232

# another way

export var55="this var"

# or still:

declare -x var55="this test var"

# we can list all exported variables with this command:

export -p
