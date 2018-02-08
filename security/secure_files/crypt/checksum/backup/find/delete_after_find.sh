#!/bin/bash

# similar to use xargs

echo 'Using -delete option in the find command: '
echo '\n'

find . -type f \( -iname '*.html' -o -iname '*.css' \) -delete

# in xargs

echo 'Using xargs instead of -delete option: '

find . -type f \( -iname '*.jpg' -o -iname '*.png' \) | xargs /bin/rm -f
