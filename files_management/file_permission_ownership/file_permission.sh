#!/bin/bash

chmod 755 folder1

chmod g+w folder2

chmod u-x folder3

chmod ugo=rwx folder4

chmod g=rw folder5

# current directory, apply permissions recursively, to all subfolders and files
chmod 755 . -R

