#!/bin/bash

find . -type f -user natasa -size +2M -exec du -cm {} \; | sort -nrk 1 | head

# something similar:

sudo du -cm /* --max-depth=1 | sort -nrk 1 | head 2>/dev/null
