#!/bin/bash

sudo apt-get install git

# I have git setup as server, and then the ubuntu client pushes code changes ... via ssh

#CLIENT:
# config global variables in client

ip14aai@02DI20161542844:~$ git config --global user.name "ip14aai"
ip14aai@02DI20161542844:~$ git config --global user.email "israelpg@gmail.com"
ip14aai@02DI20161542844:~$ git config --list

# manual configuration of global vars via file instead of command line as above:
~/.gitconfig
# cat ~/.gitconfig
[user]
	name = israelpg
	email = israelpg@gmail.com

### server - init .git folder (server is a bare):
mkdir -p /home/ip14aai/project.git && cd /home/ip14aai/project.git
git --bare init

### client, initialize local repo (is not a bare):
git init

# we need to create our stream/server and workspace environment/client:
# Server Stream:
mkdir -p /git/stream_test1

# Client Workspace
mkdir -p ~/git/stream_test1 ; cd ~/git/stream_test1

# Add files to the client repo: cp or whatever you want ... simply creating a file with touch ... etc

# initialize the repository you have just created:
git init

# add files you created or copied to git, and then you will be able to commit the changes, initial baseline, etc ... :
git add .

# In server, you make init, and a git add .

############ everything setup ... start using it!


# client
# commit message to be created:
git commit -m "Initial Commit" -a
# careful, -a will apply same commit message to all added/modified files, better specify file by file:
git commit -m "Initial Commit:" file1 file2

# push changes to remote server:
# the server will be identified as the sync stream, named stream_t1 in our example:
git remote add stream_t1 ssh://ip14aai@10.57.122.196/git/stream_test1
git remote -v

# Client: push to remote server

git push stream_t1 master

# if there is an error concerning master ... use this command to make stream as core.bare in server:
git config --bool core.bare true

# try again to push

git push stream_t1 master

# But in any case ... create the content folder for the server so that this can also add changes:

git clone stream_test1 stream_test1_b # in the cloned folder we have the actual files, the other is .git

# now we have the folder with the content, sync with client

# PULL from client ... a change which is in the Server:

# 1. After cloning server core.bare to work tree, we have a work key/stream, add here files (git add .)
# 2. Commit changes
# 3. push this changes to core.bare (no worries, it looks invisible, but checking objects gives the idea): git push (no need for more arguments)
# 4. pull, the client fetches changes from the server: git pull stream_t1 master

# to see status: git status
# to see remote conn: git remote -v


# SCENARIO: We decide some changes we planned to deliver, are no longer necessary, and are erased after commit, but not push ...
ip14aai@02DI20161542844:/git/stream_test1_b$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    pepito.txt
	deleted:    pull_this_from_server.txt
	deleted:    pull_this_too.txt

no changes added to commit (use "git add" and/or "git commit -a")
ip14aai@02DI20161542844:/git/stream_test1_b$ git add .
ip14aai@02DI20161542844:/git/stream_test1_b$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	deleted:    pepito.txt
	deleted:    pull_this_from_server.txt
	deleted:    pull_this_too.txt

ip14aai@02DI20161542844:/git/stream_test1_b$ git reset HEAD pepito.txt pull_this_from_server.txt pull_this_too.txt
Unstaged changes after reset:
D	pepito.txt
D	pull_this_from_server.txt
D	pull_this_too.txt



