#!/bin/bash
# USAGE
#     - on one directory:     ./set_acl.sh dir_name
#     - on more directories:  ./set_acl.sh 'dir_nam*'
#

# Path of the file that contains the ACL
ACL_FILE_PATH=/home/m999ipa/bcmpch-acl

# Directories onto the ACLs have to be set
dirs=$1

# Recursive function that sets ACL to files and directories
set_acl () {
  curr_dir=$1
  for args in $curr_dir/*
  do
    if [ -f $args ]; then
      echo "ACL set on file $args"
      setfacl --restore=$ACL_FILE_PATH
      if [ $? -ne 0 ]; then
        echo "ERROR: ACL not set on $args"
        exit -1
      fi
    fi
    if [ -d $args ]; then
      # Set Default ACL in directory
      setfacl --restore=$ACL_FILE_PATH
      if [ $? -ne 0 ]; then
        echo "ERROR: Default ACL not set on $args"
        exit -1
      fi
      echo "Default ACL set on directory $args"
      # Set ACL in directory
      setfacl --restore=$ACL_FILE_PATH
      if [ $? -ne 0 ]; then
        echo "ERROR: ACL not set on $args"
        exit -1
      fi
      echo "ACL set on directory $args"
      setfacl --restore=$ACL_FILE_PATH
    fi
  done
}
for dir in $dirs
do
  if [ ! -d $dir ]; then
    echo "ERROR: $dir is not a directory"
    exit -1
  fi
  set_acl $dir
done
exit 0