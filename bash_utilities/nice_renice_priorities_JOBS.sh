#!/bin/bash

# nice 0 is default value, default priority ... you can set higher priority before executing a process by selecting a lower value
# less nice, because consumes more resources, demaning more effort to machine, anyway, sometimes is needed, right

nice -2 myprog # this value is 2 ... not -2 ... for -2 you type --2

# if we need to change the value, we use renice, for even higher priority:

renice --6 -p `pgrep myprog`
