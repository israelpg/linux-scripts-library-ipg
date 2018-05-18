#!/bin/bash

# the GPG Public Key checks the signature for a package before installing it

# the rpm GPG Keys are located under folder:

/etc/pki/rpm-gpg

# if you need to import the GPG again, say from the Installation CD for CentOS 7, run:

rpm --import /mnt/cdrom/RPM-GPG-KEY

# now the GPG Key may sign packages before installing them in the system, making sure are official or approved packages

######## checking all installed gpg keys:
[ip14aai@localhost security_RedHat]$ rpm -qa gpg-pubkey*
gpg-pubkey-ef8d349f-57b6233e
gpg-pubkey-f4a80eb5-53a7ff4b
gpg-pubkey-4bd6ec30-4c37bb40

# checking one of the gpg keys for details:
[ip14aai@localhost security_RedHat]$ rpm -qi gpg-pubkey-ef8d349f-57b6233e
Name        : gpg-pubkey
Version     : ef8d349f
Release     : 57b6233e
Architecture: (none)
Install Date: Mon 11 Dec 2017 16:17:54 CET
Group       : Public Keys
Size        : 0
License     : pubkey
Signature   : (none)
Source RPM  : (none)
Build Date  : Thu 18 Aug 2016 23:06:06 CEST
Build Host  : localhost
Relocations : (not relocatable)
Packager    : Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>
Summary     : gpg(Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>)
Description :
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: rpm-4.11.3 (NSS-3)

mQINBFe2Iz4BEADqbv/nWmR26bsivTDOLqrfBEvRu9kSfDMzYh9Bmik1A8Z036Eg
h5+TZD8Rrd5TErLQ6eZFmQXk9yKFoa9/C4aBjmsL/u0yeMmVb7/66i+x3eAYGLzV
FyunArjtefZyxq0B2mdRHE8kwl5XGl8015T5RGHCTEhpX14O9yigI7gtliRoZcl3

## RPM Update and Install with -h (hash option)
## safe Update of package will proceed with this command:
sudo rpm -Uvh <package>

#for kernel packages installation:
sudo rpm -ivh <kernel-package> # once rebooted, you may remove old-kernel-package
sudo rpm -e <old-kernel-package> # because you have -ivh the newer package kernel version

# list all files for an installed package:
rpm -ql <package-name>

# remove a package:
rpm -ev <package-name>

### important before installing, checking the Key:
#Scenario: you have downloaded an rpm package with download only option enabled, now you proceed to check the Key:

yum install --downloadonly --downloaddir=/root/mypackages/ sqllite

[ip14aai@localhost security_RedHat]$ rpm -K /tmp/sqlite-3.7.17-8.el7.i686.rpm
/tmp/sqlite-3.7.17-8.el7.i686.rpm: rsa sha1 (md5) pgp md5 OK

# then install, still checking hash as a good practice:
rpm -ivh /tmp/sqlite-3.7.17-8.el7.i686.rpm

#### YUM
## for automatic gpg check in yum, enable the option in 
vim /etc/yum.conf:
gpgcheck=1

# --> this can be confirmed by checking yum configuration via:
sudo yum-config-manager
gpgcheck = True

# and proceed as usual

sudo yum install <package-name>

## Creating your own GPG Keys using the command line:

gpg2 --gen-key
# Select options, important to type your real name and email address
# eg: Israel <israelpg@gmail.com>
# gpg key is located here:
/root/.gnupg/trustdb.gpg

# displaying fingerprint:
gpg2 --fingerprint israelpg@gmail.com

pub   2048R/E2A6B6C7 2018-05-16
      Key fingerprint = 54A7 4ABB E252 5C93 EAEA  C27A 1384 8826 E2A6 B6C7
uid                  Israel (gpg key) <israelpg@gmail.com>
sub   2048R/E0036804 2018-05-16

# This is the id:
E2A6B6C7
# Normally append this at the beginning of the value: 0x
0xE2A6B6C7


