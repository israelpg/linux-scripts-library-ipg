#!/bin/bash

# better to use tabs for separating columns, in the example, 4 columns

# columns 2 and 4 displayed:
cut -f 2,4 student_data.txt

# all columns except 3 are displayed:
cut -f 3 --complement student_data.txt

# to specify a delimiter like ; instead of tabs
cut -f 2,4 -d";" student_data.txt

# CHARACTERS:

# range_fields.txt contains: abcdefghijklmnopqrstuvwxyz

cut -c 1-5 range_fields.txt # displays: abcde

# displays the first n chars:

cut range_fields.txt -c -2 # displays: ab




