#!/bin/bash
echo Reading file ...
dpkg -l | grep -f library_names.txt --color
