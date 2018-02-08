#!/bin/bash

# mounting USB devices as read only:

# /etc/udev/rules.d/80-readonly-removables.rules

SUBSYSTEM=="block",ATTRS{removable}=="1",RUN{program}="/sbin/blockdev --setro %N"
