#!/bin/bash

# Name: automatizing_workspace_creation_setup.sh
# Version: 1.0
# Description: Initial workspace setup, and connection to remote stream
# Maven is setup, thefore there is an initial setup plus pushing to remote stream

read -p "Please enter name for the workspace in your local machine" workspaceName

mkdir -p ~/git/$workspaceName ; cd ~/git/$workspaceName
ssh ip14aai@10.57.122.196 "mkdir -p /git/$workspaceName"

echo "Workspace folder has been created \n"
pwd

echo "Setup for Maven archetype project:"
read -p "Enter DgroupId: " DgroupId
read -p "Enter DartifactId: " DartifactId
read -p "Enter DarchetypeArtifactId: (It might be maven-archetype-quickstart): " DarchetypeArtifactId

# A correct mvn setup is:
#mvn archetype:generate -DgroupId=com.ip.app -DartifactId=another-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

mvn archetype:generate -DgroupId=$DgroupId -DartifactId=$DartifactId -DarchetypeArtifactId=$DarchetypeArtifactId -DinteractiveMode=false

echo "Maven project has been setup \n"
echo "Setting up Git workspace in our local machine \n"
echo "Initializing git local repository ... \n"
git init
echo "Adding files for commiting \n"
git add.
git status
echo "Adding remote stream/server connection: \n"
read -p "Enter name for stream: " streamName
git remote add $streamName ssh://ip14aai@10.57.122.196/git/$workspaceName
git remote -v
echo "Commit for initial setup ... \n"
git commit -m "Initial commit in order to setup stream with content from local workspace" -a
echo "Push changes to stream ... \n"
git push $streamName master
echo "We are done!"
