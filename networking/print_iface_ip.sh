#!/bin/bash

ifconfig enp0s8 | egrep -o "inet addr:[^ ]*" | grep -o "[0-9.]*"
