#!/bin/bash

# list only symb links:

ls -l | grep '^l'

# files

ls -l | grep '^-'

# dirs

ls -l | grep '^d'

# or using find:

find . -type l -print0
