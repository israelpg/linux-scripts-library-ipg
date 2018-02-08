#!/bin/bash

cat filename | tr 'd' 'a' # changing d for char a

# very useful for tr a space into a new line

cat filename | tr '[:space:]' '\n'
