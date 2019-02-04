import sys
import os
import time

def starting(serverName, nodeName):
    AdminControl.startServer(serverName, nodeName, 10)

def stopping(serverName, nodeName):
    AdminControl.stopServer(serverName, nodeName, 'immediate')

# JADER
JADER_500a = ['JADER_500a_MBR1', 'IntegNode_500B_RFND'] # this one is usually stopped
JADER_200a = ['JADER_200a_MBR1', 'IntegNode_200B_RFND']
JADER_500b = ['JADER_500b_MBR1', 'IntegNode_500B_RFND_BE']

# List for individual servers out of cluster to start: [Server, Node]
CLIENTS_998 = ['CLIENTS_998', 'IntegNode_500A_RFND']
DPZ_500 = ['DPZ_500','IntegNode_500A_FLUX']
INTG_200 = ['INTG_200','IntegNode_200A_RFND']
INTG_500 = ['INTG_500','IntegNode_500A_RFND']
ORCRPG_200 = ['ORCRPG_200','IntegNode_200A_RFND']
ORCRPG_500 = ['ORCRPG_500','IntegNode_500A_RFND']

individualServers = [DPZ_500, INTG_200, INTG_500, ORCRPG_200, ORCRPG_500] # CLIENTS_998 is started separately !

starting(CLIENTS_998[0], CLIENTS_998[1]))
CLIENTS_998_status = AdminControl.completeObjectName('node='+CLIENTS_998[1]+',name='+CLIENTS_998[0]+',type=Server,*')
if CLIENTS_998_status != '': # CLIENTS_998 started ... Starting Clusters:
    AdminClusterManagement.startAllClusters()
    stopping(JADER_500a[0], JADER_500a[1]) # this server within a Cluster is stopped
    # Starting the rest of Servers out of Cluster if JadeR is up an running:
    JADER_200a_status = AdminControl.completeObjectName('node='+JADER_200a[1]+',name='+JADER_200a[0]+',type=Server,*')
    JADER_500b_status = AdminControl.completeObjectName('node='+JADER_500b[1]+',name='+JADER_500b[0]+',type=Server,*')
    if JADER_200a_status and JADER_500b_status != '':
        i = 0 
        while i < len(individualServers):
            server = individualServers[i]
            i += 1
            starting(server[0], server[1])
    else:
        print('JADER Servers not started, try again or use the WAS Console.')
else:
    print('CLIENTS_998 Server not started, try again or use the WAS Console.')
    exit()

# Checking that all Servers have been started :

# 1) Generate the list of servers in the cell
listServers=[]
for server in AdminServerManagement.listServers() :
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
    print('List of servers not started:')
    print(listStopped)
else:
    print('All required Servers are started.')