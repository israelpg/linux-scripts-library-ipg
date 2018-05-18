#!/bin/bash

# When the system generates a key, it uses a random number generator, pulling from:

crw-rw-rw-. 1 root root 1, 8 May 15 18:09 /dev/random
crw-rw-rw-. 1 root root 1, 9 May 15 18:09 /dev/urandom

# We can install a package called: rng-tools, in order to improve the options of getting unique stronger keys:

yum install rng-tools

# Normally, in Red Hat CentOS it comes by default:
[root@02DI20161235444 ip14aai]# rpm -qa rng-tools
rng-tools-5-11.el7.x86_64
[root@02DI20161235444 ip14aai]# rpm -qi !$
rpm -qi rng-tools
Name        : rng-tools
Version     : 5
Release     : 11.el7
Architecture: x86_64
Install Date: Thu 05 Apr 2018 17:46:10 CEST
Group       : System Environment/Base
Size        : 69623
License     : GPLv2+
Signature   : RSA/SHA256, Thu 10 Aug 2017 21:41:17 CEST, Key ID 24c6a8a7f4a80eb5
Source RPM  : rng-tools-5-11.el7.src.rpm
Build Date  : Fri 04 Aug 2017 12:55:04 CEST
Build Host  : c1bm.rdu2.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://sourceforge.net/projects/gkernel/
Summary     : Random number generator related utilities
Description :
Hardware random number generation tools.

# it is a daemon service:

systemctl status rngd.service

● rngd.service - Hardware RNG Entropy Gatherer Daemon
   Loaded: loaded (/usr/lib/systemd/system/rngd.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-05-15 18:09:25 CEST; 16h ago
 Main PID: 726 (rngd)
   CGroup: /system.slice/rngd.service
           └─726 /sbin/rngd -f

May 15 18:09:25 02DI20161235444 systemd[1]: Started Hardware RNG Entropy Gatherer Daemon.
May 15 18:09:25 02DI20161235444 systemd[1]: Starting Hardware RNG Entropy Gatherer Daemon...
May 15 18:09:25 02DI20161235444 rngd[726]: read error
May 15 18:09:25 02DI20161235444 rngd[726]: hwrng: no available rng
May 15 18:09:25 02DI20161235444 rngd[726]: Unable to open file: /dev/tpm0

# no config file for this daemon, just type commands for changing options,
# for instance: Using another source for our random numbers other than: random, urandom (eg: /dev/hwrng)

rngd --rng-device=/dev/hwrng
# or:
rngd --random-device=/dev/hwrng

# testing level of random number generation in our system, for instance using /dev/random location:
cat /dev/random | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 999
rngtest: FIPS 140-2 failures: 1
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 1
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=102.612; avg=263.399; max=398.475)Kibits/s
rngtest: FIPS tests speed: (min=43.847; avg=166.897; max=196.634)Mibits/s
rngtest: Program run time: 74265965 microseconds
# only one failure, it is ok.


