# Script Name: start_REF.py
# Date and Author: 06/02/2019 - Israel Palomino Garcia
# Environment: REF
# 
# Rationale: 
# This script handles the start of WAS Servers during a Database Release
# It follows a sequential order based on JadeR requirements: 
# First CLIENTS_998, then JADER Clusters, then rest of Clusters
# The script gathers information of servers not started and will try to start or report otherwise

import sys
import os
import time
import re

def starting(serverName, nodeName):
    AdminControl.startServer(serverName, nodeName, 300)

def stopping(serverName, nodeName):
    AdminControl.stopServer(serverName, nodeName, 'immediate')

# Get complete lists of Clusters in REF:
listJaderClusters=[]
listNotJaderClusters=[]
for cluster in AdminClusterManagement.listClusters():
    clusterName = AdminConfig.showAttribute(cluster, 'name')
    isJader = re.findall("^JADER", clusterName)
    if (isJader):
        listJaderClusters.append(clusterName)
    else:
        listNotJaderClusters.append(clusterName)

# List of JadeR Servers:
listJaderServers=[]
for server in AdminServerManagement.listServers() :
    serverName = AdminConfig.showAttribute(server, 'name')
    isJader = re.findall("^JADER", serverName)
    if (isJader):
        listJaderServers.append(serverName)

# Generate a list for all servers and one for all nodes in the cells with a relation server / node with same index number
lineSeparator = sys.getProperty('line.separator')
cells = AdminConfig.list('Cell').split()
listServersCell=[]
listNodesCell=[]
for cell in cells:
        nodes = AdminConfig.list('Node', cell).split()
        for node in nodes:
                cname = AdminConfig.showAttribute(cell, 'name')
                nname = AdminConfig.showAttribute(node, 'name')
                servers = AdminControl.queryNames('type=Server,cell=' + cname + ',node=' + nname + ',*').split()
                for server in servers:
                        sname = AdminControl.getAttribute(server, 'name')
                        if sname != 'nodeagent':
                                listServersCell.append(sname)
                                listNodesCell.append(nname)

# Starting CLIENTS_998 Server:
print('Starting CLIENTS_998 Server...')
CLIENTS_998 = ['CLIENTS_998', 'IntegNode_500A_RFND']
starting(CLIENTS_998[0], CLIENTS_998[1])
CLIENTS_998_status = AdminControl.completeObjectName('node='+CLIENTS_998[1]+',name='+CLIENTS_998[0]+',type=Server,*')
if CLIENTS_998_status != '': # CLIENTS_998 started
    #Starting JadeR Clusters:
    print('Starting JadeR Clusters...')
    for jaderCluster in listJaderClusters:
        AdminControl.invoke(jaderCluster, 'start')
        time.sleep(480) # Allowing 8 minutes for each JadeR Cluster to start

# Check that all JadeR Servers are started otherwise will try to individually start and report
i = 0
listJaderStopped=[]
while i < len(listJaderServers):
    server = listJaderServers[i]
    i += 1
    checkServer = AdminControl.completeObjectName('name='+server+',type=Server,*')
    if checkServer == '':
        print('JadeR Server: ', server, ' not started, trying to start...')
        # fetching node name:
        inIndex = listServersCell.index(server)
        thisNode = listNodesCell[inIndex]
        starting(server, thisNode)
        checkServerAgain = AdminControl.completeObjectName('name='+server+',type=Server,*')
        if checkServerAgain == '':
            print('Not possible to start JadeR Server: ', server)
            listJaderStopped.append(server)
        else:
            print('JadeR Server: ', server, ' started.')

if len(listJaderStopped) > 0:
    print('List of JadeR Servers not started:')
    print(listJaderStopped)
    print('Exiting script, please use WAS Console')
    exit()
else:
    print('All required JadeR Servers are started.')
    print('Starting rest of Clusters...')
    for notJaderCluster in listNotJaderClusters:
        AdminControl.invoke(notJaderCluster, 'start')
        sleep(480)

# Check that all non JadeR Servers are started
j = 0
listNotJaderStopped=[]
while j < len(listNotJaderServers):
    server = listNotJaderServers[j]
    j += 1
    checkServer = AdminControl.completeObjectName('name='+server+',type=Server,*')
    if checkServer == '': 
        print('Server: ', server, ' not started, trying to start...')
        # fetching node name:
        inIndex = listServersCell.index(server)
        thisNode = listNodesCell[inIndex]
        starting(server, thisNode)
        checkServerAgain = AdminControl.completeObjectName('name='+server+',type=Server,*')
        if checkServerAgain == '':
            print('Not possible to start Server: ', server)
            listNotJaderStopped.append(server)
        else:
            print('JadeR Server: ', server, ' started.')    

if len(listNotJaderStopped) > 0:
    print('List of Servers out of JadeR Clusters not started:')
    print(listNotJaderStopped)
    print('Exiting script, please use WAS Console.')
    exit()
else:
    print('All required non-JadeR Servers are started.')
    print('REF environment successfully started.')