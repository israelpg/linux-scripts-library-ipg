#!/bin/bash

find . -type f -user israel -size +10M -exec du -sh {} \; | sort -nrk 1 | head -n 10

# a total can be given with option: du -cm (c is for total, m for MB)

find /etc/ -type f ! -user ip14aai -size +100M | xargs -I {} du -sh {} | sort -nrk 1 | head -n 5
