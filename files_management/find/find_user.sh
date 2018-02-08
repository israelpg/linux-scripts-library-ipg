#!/bin/bash

find . -type f ! -user natasa -perm 644 \( -iname '*.sh' -o -iname '*.html' \)

