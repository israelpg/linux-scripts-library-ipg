#!/bin/bash

# below it will crash, var1 is not defined
${var1?Error var1 is not defined}

# declaring a var, no value ... no problem, is defined at least, exists!
var2
${var2?Error var2 is not defined} # no error will be displayed, var2 exists

