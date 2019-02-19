# Script Name: start_INTEG.py
# Date and Author: 05/02/2019 - Israel Palomino Garcia
# Environment: INTEG
# 
# Rationale: 
# This script handles the start of WAS Servers during a Database Release
# It follows a sequential order based on JadeR requirements: 
# First CLIENTS_998, then JADER, then rest of Clusters + individual servers

import sys
import os
import time
import re

def starting(serverName, nodeName):
        AdminControl.startServer(serverName, nodeName, 300)

def stopping(serverName, nodeName):
        AdminControl.stopServer(serverName, nodeName, 'immediate')

# Get complete lists of Clusters in INTEG, one for JadeR, one for non-JadeR:
listJaderClusters=[]
listNotJaderClusters=[]
for cluster in AdminClusterManagement.listClusters():
        clusterName = AdminConfig.showAttribute(cluster, 'name')
        isJader = re.findall("^JADER", clusterName)
        if (isJader):
                listJaderClusters.append(clusterName)
        else:
                listNotJaderClusters.append(clusterName)

# Remove Server JADER_500a_MBR1 JadeR from the list (it should remain stopped):
listJaderClusters.remove('JADER_500a')

# List used JadeR Servers with node details: [servername, nodename]
JADER_200a_MBR1 = ['JADER_200a_MBR1', 'IntegNode_200B_RFND']
JADER_500b_MBR1 = ['JADER_500b_MBR1', 'IntegNode_500B_RFND_BE']
# List used JadeR Servers by Server Name:
listJaderServers = [JADER_200a_MBR1, JADER_500b_MBR1]

# List with all Individual Servers (out of cluster) with node details: [servername, nodename]
CLIENTS_998 = ['CLIENTS_998', 'IntegNode_500A_RFND']
INTG_200 = ['INTG_200','IntegNode_200A_RFND']
INTG_500 = ['INTG_500','IntegNode_500A_RFND']
ORCRPG_200 = ['ORCRPG_200','IntegNode_200A_RFND']
ORCRPG_500 = ['ORCRPG_500','IntegNode_500A_RFND']
DPZ_500 = ['DPZ_500','IntegNode_500A_FLUX']
# List with all Individual Servers by Server Name:
individualServers = [INTG_200, INTG_500, ORCRPG_200, ORCRPG_500, DPZ_500] # CLIENTS_998 is started separately !

starting(CLIENTS_998[0], CLIENTS_998[1])
sleep(180)
CLIENTS_998_status = AdminControl.completeObjectName('node='+CLIENTS_998[1]+',name='+CLIENTS_998[0]+',type=Server,*')
if CLIENTS_998_status != '': # CLIENTS_998 started
        #Starting JadeR Clusters:
        print('Starting JadeR Clusters...')
        for jaderCluster in listJaderClusters:
                AdminClusterManagement.startSingleCluster(jaderCluster)
                time.sleep(300) # Allowing 5 minutes for each JadeR Cluster to start
        
        # Check that required JadeR Servers are started:
        i = 0
        while i < len(listJaderServers):
                server = listJaderServers[i]
                i += 1
                checkServer = AdminControl.completeObjectName('name='+server+',type=Server,*')
                if checkServer == '':
                        print('JadeR Server: ', server, ' not started, trying to start again...')
                        starting(server[0], server[1])
                        sleep(180)
                        checkServerAgain = AdminControl.completeObjectName('name='+server+',type=Server,*')
                        if checkServerAgain == '':
                                print('Not possible to start JadeR Server: ', server)
                                print('Exiting script, please use WAS Console.')
                                exit()
                        else:
                                print('JadeR Server: ', server, ' started.')

        print('All required JadeR Clusters started.')
        
        # Starting non-JadeR Clusters:
        print('Starting non-JadeR Clusters...')
        for notJaderCluster in listNotJaderClusters:
                AdminClusterManagement.startSingleCluster(notJaderCluster)
                sleep(480)
                
        # Starting Individual Servers:
        j = 0 
        while j < len(individualServers):
                server = individualServers[j]
                j += 1
                starting(server[0], server[1])                      
else:
        print('CLIENTS_998 Server not started, try again by relaunching this script.')
        exit()

# Checking that all Servers have been started or report otherwise:
# 1) Generate the list of servers in the cell
listServers=[]
for server in AdminServerManagement.listServers():
        serverName = AdminConfig.showAttribute(server, 'name')
        if serverName != 'JADER_500a_MBR1' or 'CLIENTS_298' or 'nodeagent':
            listServers.append(serverName)

# 2) Checking that all involved Cluster(s) / Server(s) are already started or report otherwise:
i = 0
listStopped=[]
while i < len(listServers):
        server = listServers[i]
        i += 1
        checkServer = AdminControl.completeObjectName('name='+server+',type=Server,*')
        if checkServer == '':
            listStopped.append(server)

if len(listStopped) > 0:
        print('There seems to be a problem starting one or several servers. List of required servers not started:')
        print(listStopped)
else:
        print('All required Servers are started.')