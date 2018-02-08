#!/bin/bash

# My master branch is:
# https://github.com/linux-scripts-library-ipg

# installation of git:

sudo yum install git.x86_64

mkdir -p ~/git/workspace_linux_scripts/

# init workspace as .git:
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git init
Reinitialized existing Git repository in /home/ip14aai/git/workspace_linux_scripts/.git/

# add remote origin master branch:
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git remote add origin https://github.com/israelpg/linux-scripts-library-ipg
# list if fetch/push is available:
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git remote -v
origin	https://github.com/israelpg/linux-scripts-library-ipg (fetch)
origin	https://github.com/israelpg/linux-scripts-library-ipg (push)

# since code is already there (manually updated via browser), make a pull to fetch scripts
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git pull origin master

# commit changes and push code
