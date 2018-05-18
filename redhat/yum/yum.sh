#!/bin/bash

# repositories:

/etc/yum.repos.d # several *.repo files pointing to different urls

# check installed packages in system:

yum list installed
yum list installed mariadb*

# info about a package, let's say installed:
yum info <package_name>

# search for a package (you can use regex):

yum search package-name

# provides: check packages which provide certain functionality, eg: zip

yum provides zip

# update of a specific package:
# 1st check update

yum check-update package-name
yum update package-name

# to check all packages to be updated:

yum check-update
yum update

# just updating security packages:

yum update --security

# to see the vesion of a specific package:

yum version package-name

# to install a package:

yum install package-name

yum -y install package-name # will proceed without asking for confirmation Y/N

# remove package

yum remove package-name

# clean cache

yum clean


### how to update being offline: Using the red hat installation disk copied in the system itself

sudo mkdir -p /mnt/redhat-install-disk

sudo mount -o loop <file.iso> /mnt/redhat-install-disk

cp /mnt/redhat-install-disk/media /etc/yum.repos.d/redhat-install-disk.repo

# edit this file, pointing to mounted directory:

nano -c /etc/yum.repos.d/redhat-install-disk.repo

# add this line:

baseurl-file:///mnt/redhat-install-disk

yum update

# once done, undo the stuff:

umount /mnt/redhat-install-disk

rmdir /mnt/redhat-install-disk

rm /etc/yum.repos.d/redhat-install-disk.repo



### package groups

# to make a summary / statistics:

yum group summary

# to list with some details the different kind of package groups:

yum group list ids

# ... for instance: Development Tools in the list, we can get more info:

yum group info "Development Tools" # listing all packages in this group

# same for a specific group, like php:

yum group info "php"

# install:

yum group install "php"

# or by id:

yum group install groupid

# remove:

yum group remove "groupname"


# checking info about package:

yum whatprovides php
#several packages are listed ... you want info for on of them:
yum info <package_php>

# checking which package is related to a file:
rpm -qf /etc/bashrc
# and reinstalling it if needed:
sudo yum reinstall $(rpm -qf /etc/bashrc)

### history

sudo yum history list all

# by transaction id range:

sudo yum history list all 2..3

# for a specific package:

sudo yum history list package_name

# to sync yumdb with rpmdb:

sudo yum sync

# stats about used history db:

sudo yum history stats

# history of related packages:

sudo yum history package-list <regex>
sudo yum history package-list subscription-manager\*

[ip14aai@localhost ~]$ sudo yum history package-list wget.*
Loaded plugins: fastestmirror, langpacks
ID     | Action(s)      | Package                                              
-------------------------------------------------------------------------------
     2 | Updated        | wget-1.14-13.el7.x86_64                              
     2 | Update         |      1.14-15.el7.x86_64                              
     1 | Install        | wget-1.14-13.el7.x86_64                              
history package-list

# really detailed per transaction:

sudo yum history info <id>

[ip14aai@localhost ~]$ sudo yum history info 3
Loaded plugins: fastestmirror, langpacks
Transaction ID : 3
Begin time     : Thu Oct 19 16:42:10 2017
Begin rpmdb    : 1815:80e3d12235f4f0fcd5e6fd5d7d5b58048e1089fc
End time       :            16:42:12 2017 (2 seconds)
End rpmdb      : 1815:1a41a89050253394f9fc3388e592731b5a206c38
User           : Israel <ip14aai>
Return-Code    : Success
Command Line   : update rpm.x86_64
Transaction performed with:
    Updated       rpm-4.11.3-21.el7.x86_64                      @anaconda
    Installed     yum-3.4.3-150.el7.centos.noarch               @anaconda
    Installed     yum-plugin-fastestmirror-1.1.31-40.el7.noarch @anaconda
Packages Altered:
    Updated rpm-4.11.3-21.el7.x86_64            @anaconda
    Update      4.11.3-25.el7.x86_64            @base
    Updated rpm-build-4.11.3-21.el7.x86_64      @anaconda
    Update            4.11.3-25.el7.x86_64      @base
    Updated rpm-build-libs-4.11.3-21.el7.x86_64 @anaconda
    Update                 4.11.3-25.el7.x86_64 @base
    Updated rpm-libs-4.11.3-21.el7.x86_64       @anaconda
    Update           4.11.3-25.el7.x86_64       @base
    Updated rpm-python-4.11.3-21.el7.x86_64     @anaconda
    Update             4.11.3-25.el7.x86_64     @base
    Updated rpm-sign-4.11.3-21.el7.x86_64       @anaconda
    Update           4.11.3-25.el7.x86_64       @base
history info

### using transaction ids to redo or undo actions concerning packages:

sudo yum history undo id

sudo yum history redo id

# starting new transaction history

sudo yum history new


### YUM CONFIG: /etc/yum.conf (check file as example in this same tutorial)

[main] global config

repo files under: /etc/yum.repos.d

# to view current configuration:

sudo yum-config-manager

# for a specific section, let's say [main]:
sudo yum-config-manager main \*


### ADDING NEW REPO:

# manual, by editing file under yum config folder

add file .repo under folder: /etc/yum.repos.d

# via shell:

sudo yum-config-manager --add-repo http://www.example.com/example.repo

# enabling a yum repo:

sudo yum repolist # it gives repo id for each repo
Repo-id      : updates/7/x86_64
Repo-name    : CentOS-7 - Updates
Repo-revision: 1508536589
Repo-updated : Sat Oct 21 00:12:49 2017
Repo-pkgs    : 1,014
Repo-size    : 3.1 G
Repo-mirrors : http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=updates&infra=stock
Repo-baseurl : http://centos.crazyfrogs.org/7.4.1708/updates/x86_64/ (9 more)
Repo-expire  : 21,600 second(s) (last: Mon Oct 23 16:58:58 2017)
  Filter     : read-only:present
Repo-filename: /etc/yum.repos.d/CentOS-Base.repo

sudo yum-config-manager --enable updates/7/x86_64

# in order to enable all repos defined under /etc/yum.repos.d/<files>:

sudo yum-config-manager --enable \*

# disable:

sudo yum-config-manager --disable <repoId> # one repoId
sudo yum-config-manager --disable \* # all repos


# creating your own repo file:
# use createrepo package

sudo yum install createrepo

# create a dir and copy there all packages you want to include in your repo:

sudo mkdir -p /mnt/ipg_repo

sudo createrepo --database /mnt/ipg_repo


### Download an rpm package, but no installation:

yum install --downloadonly --downloaddir=/root/mypackages/ httpd


# A PRACTICAL EXAMPLE, VIRTUALBOX:

# to avoid package to be updated or upgraded:
# edit /etc/yum.conf [main] global configuration: directive exclude=package_name
# or installonlypkgs=package_name

# installing an old version of a package:
yum --showduplicates list available *mariadb*
yum install <package_name>









