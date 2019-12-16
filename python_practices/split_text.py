#!/usr/bin/python3

import re

# split() is useful for splitting text into a list based on a passed delimiter:
# def split(pattern, string, maxsplit=0, flags=0)

text = """Ross McFluff: 834.345.1254 155 Elm Street

Ronald Heathmore: 892.345.3428 436 Finley Avenue
Frank Burger: 925.541.7625 662 South Dogwood Way


Heather Albrecht: 548.326.4584 919 Park Place"""

# split by pattern when there is a new line + something else (non-empty line)

entries = re.split("\n+", text)

print (entries)

# output below:
# In [191]: python3 split_text.py
# ['Ross McFluff: 834.345.1254 155 Elm Street', 'Ronald Heathmore: 892.345.3428 436 Finley Avenue', 
# 'Frank Burger: 925.541.7625 662 South Dogwood Way', 'Heather Albrecht: 548.326.4584 919 Park Place']

# Refining to get a list with different elements splitted indicating a maxsplit: 
# pattern ":? " means the : are out of output and get (text and space) delim
# pattern is text and space without : with maxsplit 3 as max index in the list, 0 to 3 
[re.split(":? ", entry, 3) for entry in entries]
# Out:
#[['Ross', 'McFluff', '834.345.1254', '155 Elm Street'],
# ['Ronald', 'Heathmore', '892.345.3428', '436 Finley Avenue'],
# ['Frank', 'Burger', '925.541.7625', '662 South Dogwood Way'],
# ['Heather', 'Albrecht', '548.326.4584', '919 Park Place']]
# split is based on 3, then from 0 to 3 we have 4 elements
# meaning if based on 4, the address number can also be obtained
