#!/bin/bash
# find everythin which is not extension txt nor pdf
find . ! \( -iname '*.txt' -o -iname '*.pdf' \) -print
