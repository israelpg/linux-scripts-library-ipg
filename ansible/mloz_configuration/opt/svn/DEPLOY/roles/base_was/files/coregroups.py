
def addCGServers(AdminConfig, AdminTask,cgname,cgservers):
        for cgs in cgservers:
                AdminTask.moveServerToCoreGroup('[-source DefaultCoreGroup -target '+cgname+' -nodeName '+cgs[0]+' -serverName '+cgs[1]+']')

def addCGClusters(AdminConfig, AdminTask,cgname,cgclusters):
        for cls in cgclusters:
                AdminTask.moveClusterToCoreGroup('[-source DefaultCoreGroup -target '+cgname+' -clusterName '+cls+']')

def createCoreGroup(AdminConfig, AdminTask,cgname,cgcoords,cgservers):

        AdminTask.createCoreGroup('[-coreGroupName '+cgname+']') 
        cg=AdminConfig.getid('/CoreGroup:'+cgname+'/')
        AdminConfig.modify(cg,[['numCoordinators',len(cgcoords)]])
        addCGServers(AdminConfig, AdminTask,cgname,cgcoords)
        cgservattr = AdminConfig.showAttribute(cg,'coreGroupServers')
        cgsstr=cgservattr[1:len(cgservattr)-1]
        AdminConfig.modify(cg,[['preferredCoordinatorServers',cgsstr]])
        addCGServers(AdminConfig, AdminTask,cgname,cgservers)

