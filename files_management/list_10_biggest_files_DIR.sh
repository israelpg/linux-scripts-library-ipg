#!/bin/bash

find . -type f -user israel -size +10M -exec du -cm {} \; | sort -nrk 1 | head
