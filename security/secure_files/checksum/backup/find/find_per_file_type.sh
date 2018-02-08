#!/bin/bash

# searching file is f , directory is d, symlink is l

find / -maxdepth 3 -type f \( -iname '*.sh' -o -iname '*.html' \)

find / -mindepth 6 -type d -path '*slynux*'
