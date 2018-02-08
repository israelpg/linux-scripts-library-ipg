#!/bin/bash

sudo ifdown --force enp0s3 && sudo ip addr flush dev enp0s3 && sudo ifup --force enp0s3

