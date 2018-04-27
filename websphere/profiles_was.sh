#!/bin/bash

# Source: Youtube: SVR Technologies
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

# checking the system applications installed by default in our host:
ls -lah /opt/IBM/WebSphere/Appserver/systemApps # default systemApps !!!!!
# several *.ear files are displayed

## CREATING A USER IN GUI: easy ... just complete name for server/node, ports, and so on ...
# checking server/node configuration:
cd /opt/IBM/WebSphere/Appserver/profiles/<node_name>

### EXAMPLE FROM VIDEO:
# serverName=server1, profile="AppSrv01", node="AppNode"

# for instance, for profile "AppSrv01"
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv01
# checking for node "AppNode" the list of deployed apps:
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv01/config/cells/localhostNode01Cell/nodes/AppNode
# serverindex.xml file with the details for this node "AppNode" as follows:
<serverEntries ... serverName="server1" serverType="APPLICATION_SERVER">
	<deployedApplications>thisApp.ear/deployments/thisApp</deployedApplications>
	 # several tags like this above, one for each application deployed in the node

## Note: application binding ear files for installed apps by us are stored under folder:
ls -lah /opt/IBM/WebSphere/Appserver/profiles/AppSrv01/config/cells/applications

d .... query.ear

cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv01/config/cells/applications/query.ear/deployments/query.ear/
# open deployment.xml
# modules are listed, some mappings, and the target server:
<deploymentTarget xmi:type="appdeployment:ServerTarget" xmi:id="ServerTarget_18726373" name="server1" nodeName="AppNode"/>











