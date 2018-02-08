#!/bin/bash

# to see the pid of a running application:

pgrep firefox

# if pid is 2356, then use the pmap to see the memory usage:

pmap -x 2356 #extended -x info
