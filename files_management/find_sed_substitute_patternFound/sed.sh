#!/bin/bash

find . -type f -exec sed -i 's/888/error/g' {} +

# substitute all 888 for error in the files of our current directory.
