#!/bin/bash

# find all files in this directory . which has name non sensitive
# whatever with extension .txt -o OR! extension pdf, only files!

find . \( -iname '*.txt' -o -iname '*.pdf' -type f \) -print0

# searching for a path, including file names or path itself

find /home/israel/ -path '*slynux*' -print
# it will start finding as from indicated path /home/israel
