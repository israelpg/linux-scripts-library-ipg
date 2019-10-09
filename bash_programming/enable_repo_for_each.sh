#!/bin/bash

# Enable repo in a for loop:
for each in $(cat test); do
	sudo ssh $each 'yum-config-manager --enable epel'
done

# Checking:

for each in $(cat test); do echo "---- "$each" ----";ssh $each 'sudo yum repolist enabled | grep -i epel';done
---- s535li2tcat01.integ.gfdi.be ----
!M-team_EPEL_EPEL_7_x86_64 EP 13,326
---- s535li2tcat02.integ.gfdi.be ----
!M-team_EPEL_EPEL_7_x86_64 EP 13,326
---- s535lr2tcat01.ref.cpc998.be ----
!M-team_EPEL_EPEL_7_x86_64 EP 13,326

...
