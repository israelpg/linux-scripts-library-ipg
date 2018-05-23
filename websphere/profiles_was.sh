#!/bin/bash

# Terminology and basic concepts for WAS fundamentals understanding:
# Cell: Virtual unit composed by a Deployment Manager and several nodes.
# Deployment Manager: Process that manages installation and maintenance of apps, connection pools
# and other resources related to a J2EE environment.
# The Deployment Manager communicates with the nodes through another process: Node Agent.
# The node is another virtual unit that is built of a Node Agent and one or more Server instances!!!

# [NODE : Server1, Server2 ... handled by Node Agent ... ] --> Managed by Deployment Manager

# Architecture example:
# Cluster1 --> Node1 (Server_a, Server_b), Node2 (Server_c, Server_d)
# Node1 and Node2 have both their own Node Agent, spawning processes, while servers handle Java server requests
# The Deployment Manager handles the deployments for both nodes

# The Node Agent is a process responsible for spawning and killing server processes, sync between 
# the Deployment Manager and the node.

# Servers are regular Java processes responsible for serving J2EE requests (JSP, JSF, EJB, JMS ...)

# Cluster: Composed by several nodes. In WebSphere, a node may be managed individually, but we can
# also work by managing Cluster.

# Source: Youtube: SVR Technologies
# the main profiles in WAS: [a node has its own profile as well]
# 1) AppServer Profile
# 2) Cell Profile
# 3) Custom Profile
# 4) Management -- Deployment Manager, Job Manager, and Admin Agent
# 5) Secure proxy

# PROFILE MANAGEMENT:
## profiles can be defined via GUI --> /opt/IBM/WebSphere/Appserver/bin/ProfileManagement/pmt.sh
## or using command line tool --> /opt/IBM/WebShpere/AppServer/bin/manageprofiles.sh

WAS_HOME=/opt/IBM/WebSphere/Appserver

# our machine (hostname) can have multiple nodes, therefore, several profiles

# checking the system applications installed by default in our host:
ls -lah /opt/IBM/WebSphere/Appserver/systemApps # default systemApps !!!!!
# several *.ear files are displayed

## CREATING AN APPLICATION SERVER PROFILE IN GUI (pmt.sh): easy ... just complete name for each server, node, ports, and so on ...
# checking node configuration:
cd /opt/IBM/WebSphere/Appserver/profiles/<Profile_name>

### EXAMPLE FROM VIDEO: These are the parameters: (node name is used for WAS internal administration)
# cell: localhostNode01Cell
# hostname is the domain name (DNS) or IP address (same as for Apache, Tomcat, and so on)
# which will be controlled by each node agent (two of them), and on top, a DMGR
# serverName=server1, profile="AppSrv01", node="AppNode", I have complemented creating the following:
# AppNode: server1 - server3 (query.ear) cluster
# AppNodeAlt: server2 - server4 (anotherapp.ear) another cluster
# which will be controlled by each node agent (two of them), and on top, a DMGR

# First Cluster: query.ear
# for instance, for app server profile "AppSrv01" within "localhostNode01Cell":
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv01
# checking in this profile for corresponding node "AppNode" the list of deployed apps in the app server entry for "server1":
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv01/config/cells/localhostNode01Cell/nodes/AppNode
# serverindex.xml file with the details for this server within node "AppNode" as follows:
<serverEntries ... serverName="server1" serverType="APPLICATION_SERVER">
	<deployedApplications>query.ear/deployments/query</deployedApplications>
	 # several tags like this below, one for each application deployed in the server within this node

# We could create another profile within same node "AppNode", eg: "AppSrv03"
# then info about deployments would be in serverindex.xml file in:
/opt/IBM/WebSphere/Appserver/profiles/AppSrv03/config/cells/localhostNode01Cell/nodes/AppNode
# notice that it is another server within the same node: AppNode
<serverEntries ... serverName="server3" serverType="APPLICATION_SERVER">
	<deployedApplications>anotherapp.ear/deployments/query</deployedApplications>
	 # several tags like this below, one for each application deployed in the server within this node

# Second cluster: anotherapp.ear
# another server profile "AppSrv02", for another node "AppNodeAlt":
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv02
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv02/config/cells/localhostNode01Cell/nodes/AppNodeAlt
<serverEntries ... serverName="server2" serverType="APPLICATION_SERVER">
        <deployedApplications>query.ear/deployments/query</deployedApplications>

# completing the cluster for app: anotherapp.ear
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv04
cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv04/config/cells/localhostNode01Cell/nodes/AppNodeAlt
<serverEntries ... serverName="server4" serverType="APPLICATION_SERVER">
        <deployedApplications>anotherapp.ear/deployments/query</deployedApplications>

########################################################################################
## Note: application binding ear files for installed apps by us are stored under folder:
ls -lah /opt/IBM/WebSphere/Appserver/profiles/AppSrv01/config/cells/applications

d .... query.ear

cd /opt/IBM/WebSphere/Appserver/profiles/AppSrv01/config/cells/applications/query.ear/deployments/query.ear/
# open deployment.xml for this app:
# modules are listed, some mappings, and the target server name and node name:
<deploymentTarget xmi:type="appdeployment:ServerTarget" xmi:id="ServerTarget_18726373" name="server1" nodeName="AppNode"/>

## CONSOLE: Access for managing WAS server1 in our example:
# back to serverindex.xml in the node configuration file for node name AppNode in server profile AppSrv01:
# /opt/IBM/WebSphere/Appserver/profiles/AppSrv01/config/cells/localhostNode01Cell/nodes/AppNode
# there are some important lines concerning WAS node admin:
<specialEndpoints xmi:id... endPointName="WC_adminhost">
	<endPoint ... host="*" port="10000"/>
</specialEndpoints>
<specialEndpoints xmi:id... endPointName="WC_defaulthost">
        <endPoint ... host="*" port="10002"/>
</specialEndpoints>

# urls then are:
http://HostNameOfserver:WC_adminhost/ibm/console
# or:
http://HostNameOfserver:WC_adminhost/admin
# same using https
# or:
http://localhost:10002/ibm/console
https://localhost:10000/ibm/console

# remember that server1 must be started via bin:
cd /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin
./startServer.sh server1

# logs for profile are under folder:
cd /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/logs

## Summary: We start the server1 using bin from related profile folder, and we can access 
# the console to manage it. Server1 node name: AppNode. 
# If we want to chech the ports to access the console via url, for admin, then check one 
# of the node configs: serverindex.xml, in this case for AppNode node, and there are the 
# specialEndpoints indicating console ports.


### SCENARIOS:

# CREATING A PROFILE VIA GUI:
# 1. Profile Management Tool: /opt/IBM/WebSphere/Appserver/bin/ProfileManagement/pmt.sh
#    You can choose "Application Server", or go for Advanced Mode via "Custom Profile"
#    If "Custom Profile" --> "Advanced Profile Creation" .. type "profile" and "node" name 
#    Details for "hostname" and "port", check in: "Deployment Manager" --> "Ports"
#    SOAP_CONNECTOR_ADDRESS: HOSTNAME + PORT
# 2. Checking the new Profile and its node agent: System Administration --> Node agents
# 3. Now we can create a server managed by this Node Agent in the node for this recent profile
#    "Servers" --> "WebSphere application servers" --> Click on New .. 
#    Select the Node to be on top of this server, type a server name, check default ports, finish
#    
#    To sync the Server with its Node on top, you follow the "Messages", click on "Review": sync
#
# 4. The server can be started
#
# 5. DEPLOYMENT: "Applications" --> "New Application" --> "New Enterprise Application"
#    Local File System: Choose File to upload and deploy it
#    Q: How do you want to install the app? Fast Path (easy mode), or Detailed
#    A: I go for Fast Path ..
#    Just accept all by default ... the screen for app modules, select the ones you need (say all)
#    Select the server you want the app to be deployed .. or cluster
#    Sync changes with node
#
# 6. Checking Apps: "Applications" --> "All applications" (here you check link between node-server-app)
#
# 7. Virtual Host: A Virtual Host is needed to be defined for the application:
#    "Environment" --> "Virtual Hosts" --> "default_host" --> Click on "Host Aliases": hostname: * port:#
#    Port for accessing App, check "Servers" --> Choose the one --> "Ports": WC_defaulthost
#    Use it for assigning it to the Virtual Host above, and then app is accessible via url:
#    Example: http://localhost:9084/applicationName
#    If we deploy other apps in this server, we use same port, but obviously with different applicationName



