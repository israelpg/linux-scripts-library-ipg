#!/bin/bash

# Environment architecture:
	 Cell01	->	Node01			node02
			server1: Application 1	server2: Application 1 (App1_Cluster)
			server3: Application 2	server4: Application 2 (App2_Cluster)
			server5: Application 3	server6: Application 3 (App3_Cluster)
			+			+
			Nodeagent ENV03_aNode	Nodeagent ENV03_bNode
			+			+
			ENV03_aProf (WAS prof)  ENV03_bProf (WAS prof)
			-------------------------------------------------------------
			+ dmgr (Deployment Manager) / ENV03_dmgrProf (WAS profile)

# The node is a physical machine, which may run several virtual servers, each with its own cpu, ram, disk ...
# The cluster is composed of virtual servers which run in different nodes, in case one fails, the app runs in the other one.

# PROFILE MANAGEMENT:
# CREATING A DEPLOYMENT MANAGER PROFILE, USING MANAGERPROFILES.SH SCRIPT: (GUI can be used running pmt.sh)
# WAS_HOME=/opt/IBM/WebSphere/Appserver/bin

# listing existing profiles: (eg: exists the Dmgr01 profile)
$ ./manageprofiles.sh -listProfiles
[Dmgr01]

# removing existing dmgr profile (if needed to start from scratch): (eg: if listProfiles returns Dmgr01 as profile name)
$ ./manageprofiles.sh -delete -profileName Dmgr01
INSTCONFSUCCESS
# checking the logs to make sure:
cat /opt/IBM/WebSphere/Appserver/logs/manageprofiles/Dmgr01_delete.log

# profiles are normally created as such within folder:
/var/was8nd/profiles # was8nd may be different, depending on WAS version
# remove files related with profile we want to drop:
rm -Rf /var/was8nd/

# Below script to create a DMGR profile:
######################################################################################
#!/bin/bash
# Script Name: createDmgr.sh

set -o nounset ; set -o errexit

# Exporting env vars used during the creation of DMGR profile:
export WAS_BINARY_DIR="/opt.IBM/WebSphere/AppServer"
export PROFILE_NAME="Dmgr01_Prof"
export WAS_PROFILE_DIR="/var/apps/was8nd/profiles"
export CELL_NAME="Cell01" # Cell is main logical unit
export HOST="localhost" # Physical machine
export NODE_NAME="Cell01Dmgr01" # Node will contain one or several virtual servers
export START_PORT="10000" # Port to access console
export DMGR_ADMIN_USER="wasadmin"
export DMGR_ADMIN_PASSWORD="wasadmin"

# Checking whether profile name related with dmgr exists or not. Getting dmgr related profile name
existingDmgrUser=$(${WAS_BINARY_DIR}/bin/manageprofiles.sh -listProfiles | grep -i 'dmgr' | tr -d '[]')
# In case exists, token is 1, then we will delete it
tokenDmgr=$(echo ${existingDmgrUser} | wc -w)

if [[ ${tokenDmgr} -eq 0 ]]
then
	${WAS_BINARY_DIR}/bin/manageprofiles.sh -create -profileName ${PROFILE_NAME} -profilePath ${WAS_PROFILE_DIR}/${PROFILE_NAME} -templatePath ${WAS_BINARY_DIR}/profileTemplates/management
	-serverType DEPLOYMENT_MANAGER -cellName ${CELL_NAME} -hostname ${HOST} -nodeName ${NODE_NAME} -startingPort ${START_PORT} -isDefault -enableAdminSecurity true
	-adminUserName ${DMGR_ADMIN_USER} -adminPassword ${DMGR_ADMIN_PASSWORD}
	if [[ $? -eq 1 ]]
	then
		echo "Script failed during execution of DMGR profile creation"
                echo "Logs: ${WAS_BINARY_DIR}/logs/manageprofiles/${PROFILE_NAME}_create.log"
		exit 1
	else
		echo "DMGR profile ${PROFILE_NAME} has been successfully created"
		echo "Logs: ${WAS_BINARY_DIR}/logs/manageprofiles/${PROFILE_NAME}_create.log"
		echo "Profile under folder: ${WAS_PROFILE_DIR}/${PROFILE_NAME}"
		echo "Binaries for Deployment Manager under folder: ${WAS_PROFILE_DIR}/${PROFILE_NAME}/bin"
		echo "For instance, start DMGR running: ./startManager.sh -username <username> -password <password>"
		exit 0
	fi
else
	echo "Deleting existing DMGR profile ${existingDmgrUser} .."
	${WAS_BINARY_DIR}/bin/manageprofiles.sh -delete -profileName ${existingDmgrUser}
	if [[ $? -eq 0 ]]
	then
		if [[ -d /var/was*/profiles ]]
		then
			echo "DMGR profile: ${existingDmgrUser} folder will be deleted"
			rm -Rf /var/was*/profiles
		fi
		echo "Deletion completed"
		exit 0	
	fi
fi
########################################################################################

# Logs are here, tail -f to see the working progress while script is running:
sudo nohup ./createDmgr.sh &
tail -f /opt/IBM/WebSphere/Appserver/logs/manageprofiles/Dmgr01_Prof_create.log
...
INSTCONFSUCCESS

# profile then should now exist in:
/var/apps/was8nd/profiles/Dmgr01_prof # profile name
# use bin to execute the DMGR:
/var/apps/was8nd/profiles/Dmgr01_prof/bin
./startManager.sh -username <username> -password <password>

# process is running as java
ps -ef | grep 'java' # check for cell, node, profile details

# URL:
http://localhost:10000/ibm/console





