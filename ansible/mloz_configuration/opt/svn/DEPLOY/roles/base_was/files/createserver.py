import sys
sys.path.append('../share/procs')

#import save
import validateparams
import updateports
import serverprocs

def configureserver(AdminConfig,AdminTask,nodename,server,servername,hostname,baseport,wdir):
	print "  Calling updateports"
	updateports.updateports(AdminTask,nodename,servername,hostname,baseport)

	appsrv=AdminConfig.list('ApplicationServer',server)
	webcntr=AdminConfig.list('WebContainer',appsrv)

	print "  Configuring filter compatibility"
	AdminConfig.modify(webcntr,[
		['properties',[[['name','com.ibm.ws.webcontainer.invokefilterscompatibility'],['value','true']]]]
		])
		
	print "  Activate PMI"
	pmisvc=AdminConfig.list('PMIService',server)
	AdminConfig.modify(pmisvc,[['enable','false']])

	print "  Configure working dir: don't forget to create the following folder: "+hostname+":/data/"+wdir+"/"+servername+"/work"
	pdef=AdminConfig.list('JavaProcessDef',server)
	AdminConfig.modify(pdef ,[['workingDirectory','/data/'+wdir+'/'+servername+'/work']])

	print "  Configure classpath and memory parameters"
	jvm = AdminConfig.list('JavaVirtualMachine', server)
	AdminConfig.modify(jvm,[
		['classpath','/data/'+wdir+'/'+servername],
		['verboseModeGarbageCollection','false'],
		['genericJvmArguments','-Xgcpolicy:gencon'],
		['initialHeapSize','512'],
		['maximumHeapSize','1024'],
		['systemProperties',[[['name','java.awt.headless'],['value','true']]]]
		])

	print "  Configure logging"
	errstream=AdminConfig.showAttribute(server, 'errorStreamRedirect')
	outstream=AdminConfig.showAttribute(server, 'outputStreamRedirect')

	AdminConfig.modify( outstream , [
		['baseHour', 4],
		['maxNumberOfBackupFiles',  10 ],
		['rolloverPeriod', 4],
		['rolloverSize',10],
		['rolloverType', 'BOTH']])
	AdminConfig.modify( errstream , [
		['baseHour', 4],
		['maxNumberOfBackupFiles',  10 ],
		['rolloverPeriod', 4],
		['rolloverSize',10],
		['rolloverType', 'BOTH']])

def createserver(AdminConfig,AdminTask,nodename,servername,hostname,baseport,wdir):
	print "Creating Server %s on Node %s" % (servername, nodename)
	server = AdminConfig.create('Server', AdminConfig.getid('/Node:'+nodename+'/') , [['name' , servername]] )
	configureserver(AdminConfig,AdminTask,nodename,server,servername,hostname,baseport,wdir)

def createclustermember(AdminConfig,AdminTask,nodename,clustername,servername,hostname,baseport,wdir):
	print "Creating Member %s in Cluster %s" % (servername, clustername)
	cluster=AdminConfig.getid('/ServerCluster:'+clustername+'/')
	node=AdminConfig.getid('/Node:'+nodename+'/')
	AdminConfig.createClusterMember(cluster,node,[['memberName', servername]])
	server = AdminConfig.getid('/Node:'+nodename+'/Server:'+servername+'/')
	configureserver(AdminConfig,AdminTask,nodename,server,servername,hostname,baseport,wdir)

def convertcluster(AdminConfig,nodename,clustername,servername):
	print "Converting Server %s to Cluster %s" % (servername, clustername)
	server = AdminConfig.getid('/Node:'+nodename+'/Server:'+servername+'/')
	AdminConfig.convertToCluster(server,clustername)

## standalone program starts here - can't be included in other script
# validateparams.validateparams(['nodename','servername','hostname','baseport'])
# createserver(AdminConfig,AdminTask,validateparams.pardict['nodename'],validateparams.pardict['servername'],validateparams.pardict['hostname'],validateparams.pardict['baseport']) 
# save.savework(AdminConfig)
