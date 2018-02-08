#!/bin/bash

touch test.txt

chattr +i test.txt

cat test.txt

chattr -i test.txt

cat test.txt
