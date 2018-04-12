#!/bin/bash

To start inserting code, type key Insert

To stop inserting and have the options menu, type key Esc

# delete a line
# after esc: considering you are in the line, type:
dd

#- To save a file:
:wq

# To import code from another file:
:r /path/thisfile.sh

#Executing a command and inserting the output in the file:
:r !<command>
# example:
:r !date

## template file for map key, for instance: F2 will insert bash initial line, insert author and date
# in ~/.vimrc

map <F2> i#!/bin/bash<ESC>o#This file was created on <ESC>:r!date "+\%x" <ESC> by <ESC>:r!whoami<ESC>kJ

# Better to make it available for any logged in user, copy .vimrc as vimrc file in:
/etc/profile.d/vimrc
# reference this file in the /etc/vim/vimrc config file

