#!/bin/bash

sudo lsof -i -N -P
sudo lsof -i -N -P | grep 'firefox'
