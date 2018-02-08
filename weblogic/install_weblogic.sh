#!/bin/bash

# JAVA_HOME must point to /usr

# /usr/bin/java is a link to java installation folder, therefore, change link:

$ readlink -f /usr/bin/java

# this points to a folder, if is correct, do not change, otherwise, update it:

$ link -s <folder> /usr/bin/java
