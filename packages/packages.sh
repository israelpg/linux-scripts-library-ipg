#!/bin/bash

# To find modules related to a topic:
apt-cache search name_topic

# To get more details for the package found in the search:
apt-cache show module_name

sudo apt-get install module_name

# or aptitude:

sudo aptitude install module_name

# To list the packages installed in the system:

sudo dpkg -l | less

# to list files installed for a particular package:

dpkg -L package_name # example: dpgk -L apache2-utils


# To uninstall

sudo aptitude purge package_name

# Which package installed a particular file:

dpkg -S /etc/host.conf

# Install a .deb file:

sudo dpkg -i package_name.deb
