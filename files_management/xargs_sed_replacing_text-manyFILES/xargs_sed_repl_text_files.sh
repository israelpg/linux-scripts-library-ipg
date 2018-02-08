#!/bin/bash

find . -type f -iname '*.txt' -print0 | xargs -I {} -0 sed -i 's/Copyleft/Copyright/' {}
