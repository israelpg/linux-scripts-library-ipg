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

# it is possible to change the url of the remote repository (stream): eg: with origin
git remote set-url origin https://github.com/user/repo.git

# cloning a workspace (local):
git clone https://github.com/israelpg/linux-scripts-library-ipg /localFolder # destination folder must be empty

# push and pull changes:
git push origin master # pushing changes to remote repository (stream): "origin" , branch "master"

git pull origin master # to get files from repository workspace into our local repo
# in case we do not want a merge with our current changes: fetch
git fetch

# status in GIT:
# untracked --> changes in local code / workspace, not staged in workspace (add . not performed yet)
# staged with: git add <filename> | <dir> | --all (eg: git add .)
# see delta: what have changed in the code, untracked, workspace vs stream
git diff
# if staged, but not yet committed, see changes with:
git diff --cached

# commit:
git commit -m "this message about update" -a
# for a specific file: git commit -m "only one file" filename.txt

# checking commits/ids:
git log

# checking info for last commit, still pending to be pushed:
git show HEAD

# checking diff between commits:
git diff COMMIT1_ID COMMIT2_ID

# see the differences in files between two commits:
git diff --name-only COMMIT1_ID COMMIT2_ID

# see the files changed in a specific commit:
git diff-tree --no-commit-id --name-only -r COMMIT_ID
# or:
git show --pretty="format:" --name-only -r COMMIT_ID

## CHECKING DIFF BETWEEN LOCAL WORKSPACE/REPO AND REMOTE/STREAM:
git diff origin/master # note: origin/master is a shorthand for refs/remotes/origin/master

# removing a file from workspace, and stream:
rm <filename>
git rm <filename>
# + commit and push

# moving files with buil-in-function git mv:
git mv <file1.txt> <filenow.txt>
# + commit and push

# since code is already there (manually updated via browser), make a pull to fetch scripts
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git pull origin master

# commit changes and push code
# you have updated code, push it:
git status
git add --all # for adding a specific file: git add <filename>
git commit -m "message goes here"
git push origin master
git status

# commit only some files, not all workspace changes:
git commit -m "Updating file{1,2,3,4}.txt" file1.txt file2.txt file3.txt file4.txt


### SCENARIOS: adding a .txt file in workspace, untracked:

[ip14aai@02DI20161235444 workspace_linux_scripts]$ git status
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	testing.txt
nothing added to commit but untracked files present (use "git add" to track)

[ip14aai@02DI20161235444 workspace_linux_scripts]$ git add testing.txt
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	new file:   testing.txt
#

[ip14aai@02DI20161235444 workspace_linux_scripts]$ git diff --cached
diff --git a/testing.txt b/testing.txt
new file mode 100644
index 0000000..d00491f
--- /dev/null
+++ b/testing.txt
@@ -0,0 +1 @@
+1

###### I HAVE DECIDED TO ADD MORE MODIFICATIONS TO THE SAME FILE, back from staging to untracked code:
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git reset testing.txt
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git status
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	testing.txt
nothing added to commit but untracked files present (use "git add" to track)

## I have added a new line at 16:12h

[ip14aai@02DI20161235444 workspace_linux_scripts]$ git add testing.txt
[ip14aai@02DI20161235444 workspace_linux_scripts]$ git diff --cached
diff --git a/testing.txt b/testing.txt
new file mode 100644
index 0000000..f416431
--- /dev/null
+++ b/testing.txt
@@ -0,0 +1,2 @@
+1
+adding this as well at 16:12h

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
D       pepito.txt
D       pull_this_from_server.txt
D       pull_this_too.txt
