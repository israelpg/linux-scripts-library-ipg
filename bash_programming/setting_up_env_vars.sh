#!/bin/bash

# Scenario: For Maven setup of env variables, as an initial step, we can run this script:

# setup env variables for Maven and export them so that are used by system

# -q silent mode, only within script, not displaying anything to user

if ! echo $PATH | grep -q /opt/maven/bin ; then
  export M2_HOME=/opt/maven
  export PATH=${M2_HOME}/bin:${PATH}
fi

