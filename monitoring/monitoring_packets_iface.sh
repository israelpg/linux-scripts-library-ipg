#!/bin/bash

sudo iftop -i enp0s3

# statistics with vnstat:

sudo vnstat -i enp0s3 -d # -d daily -m monthly ...
