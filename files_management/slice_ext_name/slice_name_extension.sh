#!/bin/bash

filename='example.jpg'

# slice and keep in a var only the name of the file in $filename declared above:

only_name=${filename%.*}

echo $only_name

# slice and keep only extension jpg:

only_extension=${filename#*.}

echo $only_extension
