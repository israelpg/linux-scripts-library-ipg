#!/bin/bash

sudo usermod -a -G group1,group2 username

sudo gpasswd -a username group1 group2
