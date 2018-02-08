#!/bin/bash

# we have files with format name: file_<number>.txt
# we need to paste the content, using paste leaves content in horizontal ... perfect for comparison in a single output

ls file_[0-9].txt | xargs paste

# instead of making xargs with {}, for processing each content individually, here is a block process, all files are pasted
