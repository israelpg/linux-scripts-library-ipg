#!/bin/bash

nano -c /etc/apt/sources.list

# you can also use a .deb package to update the /etc/apt/sources.list.d/<app> :

curl -O <url.deb>

sudo dpkg -i <package.deb>

sudo apt-get update
