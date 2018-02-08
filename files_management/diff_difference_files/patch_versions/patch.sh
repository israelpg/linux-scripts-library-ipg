#!/bin/bash

diff -u test1.txt test2.txt > version.patch # you get the diff in a file with .patch extension

patch test1.txt < version.patch # now you apply patch version to the first file, so that is same as 2
