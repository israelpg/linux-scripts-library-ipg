def findserver(AdminConfig,nodename,servername):
	if nodename=='':
		scope='/ServerCluster:'+servername+'/'	
	elif servername=='':
		scope='/Node:'+nodename+'/'
	else:
		scope='/Node:'+nodename+'/Server:'+servername+'/'

	srvr=AdminConfig.getid(scope)
	if  srvr == "":
		raise Exception, "	WebSphere Server %s does not exist !!!" % scope
	
	return srvr
	
# def searchserver(AdminConfig, matchlist)
# create empty list
# AdminConfig list server
	# check all match patterns [or replace the whole thing with regex-es]
	# all match --> add to list
# return list
	

def configureusergroup(AdminConfig,nodename,servername,username,group):
	
	server=findserver(AdminConfig,nodename,servername)
	
	pdefs=AdminConfig.list('JavaProcessDef',server)
	# pdefs=AdminConfig.list(server,'processDefinitions')
	print "%s" % pdefs
	exectn=AdminConfig.showAttribute(pdefs,'execution')
	AdminConfig.modify(exectn,[['runAsUser',username],['runAsGroup',group]])

def modifycookiename(AdminConfig,nodename,servername,prefix):

	server = findserver(AdminConfig,nodename,servername)
	appsrv=AdminConfig.list('ApplicationServer',server)
	webcntr=AdminConfig.list('WebContainer',appsrv)

	print "  Configure SESSION Cookie for %s" % servername
	sessmgr=AdminConfig.list('SessionManager',webcntr)
	
	cookie=AdminConfig.showAttribute(sessmgr,'defaultCookieSettings')
	AdminConfig.modify(cookie,[['name',prefix+'SESSIONID']])

def configurememory(AdminConfig,server,mmin,mmax):
	jvm = AdminConfig.list('JavaVirtualMachine', server)
	AdminConfig.modify(jvm,[
		['initialHeapSize',mmin],
		['maximumHeapSize',mmax]
		])
	
def createLibrary(AdminConfig,nodename,servername,libname,libapp,libfile):
	serverid = findserver(AdminConfig,nodename,servername)
	AdminConfig.create('Library',serverid,[['name',libname],
						['classPath','/data/'+libapp+'/'+servername+'/lib/'+libfile],
						['nativePath',''],
						['isolatedClassLoader','false'],
						['description','jar with classes to retrive information from JNDI']
						])

def createResourcesProvider(AdminConfig,nodename,servername,resource_list):
	serverid = findserver(AdminConfig,nodename,servername)
	resprov=AdminConfig.create('ResourceEnvironmentProvider',serverid,[['name','ResourcesProviderForJNDI']])
	referc=AdminConfig.create('Referenceable',resprov,[['classname','be.mteam.config.server.jndi.ConfigServer'],['factoryClassname','be.mteam.config.server.jndi.ConfigServerFactory']],'referenceables')
	for resource in resource_list:
		enventry=AdminConfig.create('ResourceEnvEntry',resprov,[['name',resource[0]],['jndiName',resource[1]],['referenceable',referc]])
		props=AdminConfig.create('J2EEResourcePropertySet',enventry,[['resourceProperties',[[['name',resource[2]],['value',resource[3]],['type',resource[4]]]]]])
