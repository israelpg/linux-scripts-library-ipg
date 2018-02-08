#!/bin/bash

# if you have an application installed in /opt (like maven), you must export some values to env variables, concerning path for instance

# check: mavenenv.sh
# setup env variables for Maven and export them so that are used by system

if ! echo $PATH | grep -q /opt/maven/bin ; then
  export M2_HOME=/opt/maven
  export PATH=${M2_HOME}/bin:${PATH}
fi


#Then you execute:
source mavenenv.sh
#as root!!!
