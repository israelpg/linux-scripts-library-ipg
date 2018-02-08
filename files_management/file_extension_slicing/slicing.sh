#!/bin/bash

# declare a var to use:

file_jpg='sample.jpg'

# to slice and save in a var only the name without the extension of the file:

name=${file_jpg%.*}

echo $name

# to slice and save in a var only the extension:

extension=${file_jpg#*.}

echo $extension
