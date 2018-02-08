#!/bin/bash

# either by editing: /etc/apt/sources.list (and adding source at the end of the file)

# Adding the source from shell with this command:
sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu saucy universe multiverse"

sudo apt-get update

sudo apt-get install <app>

# or with this command (underground sources/repositories) PPA Personal Package Archive:

sudo add-apt-repository ppa:<repository name>

