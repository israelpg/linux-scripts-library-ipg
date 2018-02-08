#!/bin/bash

# if is the input, we can use /dev/zero special char to generate 0's, and output to of

dd if=/dev/zero of=junk.data bs=20M count=1 # if count is 2 then 20*2=40M

# other units are: c for bytes, w for word, b for block, k kilobyte, M, G 
