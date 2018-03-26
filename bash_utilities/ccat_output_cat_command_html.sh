#!/bin/bash

# This tool gives a colourful output to files, including html report generation:

wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz

tar -zxvf linux-amd-64-1.1.0.tar.gz -C /Downloads

cp /Downloads/linux-amd64-1.1.0/ccat /usr/local/bin

ccat /etc/resolv.conf >/tmp/resolv.log

# in case you want to generate the log or report in html format:

ccat --html /etc/passwd >/tmp/passwd.html
