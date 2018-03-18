#!/bin/bash

# the ownership of 1.txt is the reference which will be applied to 2.txt:

chown --reference=1.txt 2.txt
