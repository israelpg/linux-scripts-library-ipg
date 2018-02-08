#!/bin/bash

tar -cvf - files/ | ssh ip14aai@192.168.56.101 "tar -xvf -C Documents/"
