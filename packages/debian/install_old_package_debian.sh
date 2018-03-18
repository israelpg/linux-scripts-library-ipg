#!/bin/bash

apt-cache policy firefox
apt-get install firefox=<older_version than current one>

# as follows:
israel@israel-N56JN:~/git/workspace_linux_scripts/packages$ apt-cache policy firefox
firefox:
  Installed: 58.0.1+build1-0ubuntu0.16.04.1
  Candidate: 59.0.1+build1-0ubuntu0.16.04.1
  Version table:
     59.0.1+build1-0ubuntu0.16.04.1 500
        500 http://be.archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages
        500 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages
 *** 58.0.1+build1-0ubuntu0.16.04.1 100
        100 /var/lib/dpkg/status
     45.0.2+build1-0ubuntu1 500
        500 http://be.archive.ubuntu.com/ubuntu xenial/main amd64 Packages
israel@israel-N56JN:~/git/workspace_linux_scripts/packages$ apt-get install firefox=45.0.2+build1-0ubuntu1 500

