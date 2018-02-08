# setup env variables for Maven and export them so that are used by system

if ! echo $PATH | grep -q /opt/maven/bin ; then
  export M2_HOME=/opt/maven
  export PATH=${M2_HOME}/bin:${PATH}
fi


