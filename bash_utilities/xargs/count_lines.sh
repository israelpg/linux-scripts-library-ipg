#!/bin/bash

find . -maxdepth 2 ! -type d -perm 644 -iname '*.c' -print0 | xargs -0 wc -l
