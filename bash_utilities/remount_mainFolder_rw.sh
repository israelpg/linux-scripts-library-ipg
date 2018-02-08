#!/bin/bash
# useful if you start with systemd runlevel multi-user.target without writing permissions in / (isolate)

sudo mount / -o remount,rw
