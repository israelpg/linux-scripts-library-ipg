#!/bin/bash

## user env variable, within ~
.bashrc --> effective when a new local terminal is opened just for ~ user who has this setup
.bash_profile --> applicable for remote login
.bash_login
.profile

# system wide env variables
/etc/bash.bashrc --> for all users but only local sessions
/etc/environment --> for every user, local and remote sessions (e.g.: defining proxy var settings)
/etc/profile --> better use profile.d
/etc/profile.d --> this is related with applications/scripts execution, like for instance: vim.sh

# setting vars in a shell:
set varname
# or:
export varname
# to take effect/refresh:
source .bashrc # or the applicable var name
# unset a var:
unset varname

# in a terminal you can also temp unset env vars:
env -i bash
# to restore env vars in this session again:
exit

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
