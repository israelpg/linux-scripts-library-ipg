#!/bin/bash

# to add a directory in the list of dir path:

pushd ~ # home directory is saved, it will be position 0 when using dirs

# adding another path:

pushd /etc/apache2

# listing directories: 

dirs

# displays: ~ /etc/apache2

pushd +1 # --> changes dir to /etc/apache2, which is in position 1

# position is changing all the time, in 0 will be the current one, therefore
# now /etc/apache2 is in position 0 when typing command dirs:

dirs

# /etc/apache2 ~

pushd +1 # it will change dir to ~

# remove is by typing command popd:

popd 0
