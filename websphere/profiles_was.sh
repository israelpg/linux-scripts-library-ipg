#!/bin/bash

# the main profiles in WAS: [used to manage servers, eg: a node has its own profile as well]
# 1) AppServer Profile
# 2) Cell Profile
# 3) Custom Profile
# 4) Management -- Deployment Manager, Job Manager, and Admin Agent
# 5) Secure proxy

## profiles can be defined via GUI --> /opt/IBM/WebSphere/Appserver/bin/ProfileManagement/pmt.sh
## or using command line tool --> /opt/IBM/WebShpere/AppServer/bin/manageprofiles.sh

WAS_HOME=/opt/IBM/WebSphere/Appserver

# our machine (hostname) can have multiple servers/nodes, therefore, several profiles

# checking the system applications installed in our host:
ls -lah /opt/IBM/WebSphere/Appserver/systemApps
# several *.ear files are displayed

## CREATING A USER IN GUI: easy ... just complete name for server/node, ports, and so on ...
# checking server/node configuration:
cd /opt/IBM/WebSphere/Appserver/profiles/<node_name>







