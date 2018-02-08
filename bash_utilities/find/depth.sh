#!/bin/bash

sudo find / -maxdepth 6 \( -iname '*.txt' -o -iname '*.pdf' \) -print

sudo find / -mindepth 1 \( -iname '*.sh' -o -iname '*.html' \) -print
