#!/bin/bash

var1=2

echo "$var1"

# you can do also:

echo "${var1}"

# it seems more complex, but it has more sense when doing something like example below:

myshell="/bin/bash"
# want to add code at the end of var value
echo "${myshell}code"
# displays: /bin/bashcode

# another example:

find "${HOME}/pruebas/scripts" -iname '*.txt'

# unset variable

unset varname
