#!/bin/bash

var='This is a line of text'

echo 'var: ' $var

echo 'Replacing line for REPLACED:'

echo ${var/line/REPLACED}

var2='abcdefghijklmnopqrstuvwxyz'

echo 'Now print var2 which is the abecedary, but from fifth character onwards:'

echo ${var2:4}

echo 'Now print from fifth character but only 8 chars:'

echo ${var2:4:8}

echo 'Or printing specifying from the last character, 2 chars:'

echo ${var2:(-2)}
