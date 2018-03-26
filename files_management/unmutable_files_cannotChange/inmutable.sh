#!/bin/bash

touch test.txt

# set inmutable attribute, even for root
sudo chattr +i test.txt

# unset inmutable attribute:
sudo chattr -i test.txt

## to list special attributes, like inmutable, in a file:
lsattr <filename>

# to setup dir and all its files as inmutable:
sudo chattr +i -R /backups/
