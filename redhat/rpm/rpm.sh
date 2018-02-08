# search for a package (installed):
rpm -qa name* # regex admitted

# if installed, list info:
rpm -qi <package-name>

# know what a package provides:
rpm -q --whatprovides nmap

# list all files for an installed package:
rpm -ql <package-name>

# list config files only:
rpm -qc <package-name>

# install a package:
rpm -ivh <package-name>
# upgrade:
rpm -Uvh <package-name>

# remove a package:
rpm -ev <package-name>

# if you have the rpm, you may check for dependencies/requirements before i:
rpm -qpR /home/ip14aai/Downloads/fping-3.10-1.el7.rf.x86_64.rpm
