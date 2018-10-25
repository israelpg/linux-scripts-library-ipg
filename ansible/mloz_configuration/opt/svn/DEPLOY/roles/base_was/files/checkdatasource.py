import sys
sys.path.append('config')
sys.path.append('../share/procs')

import jaas
import drivers
import apps
import servers

def checkjdbcprovider(AdminConfig,type,nodename,servername):
	"""
	Check jdbc provider and create if not exist. Configuring ConnectionPool settings.

	:param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param type: Type of db connection, Toolbox, Universal, Mssql
	:param nodename: Name of the Node
	:param servername: Name of the Server
	"""

	print "Checking %s jdbc provider" % type
	
	if nodename=='':
		scope='/ServerCluster:'+servername+'/'	
	elif servername=="nodeagent":
		scope='/Node:'+nodename+'/'
	else:
		scope='/Node:'+nodename+'/Server:'+servername+'/'
	
	srvr=AdminConfig.getid(scope)
	if  srvr == "":
		raise Exception, "	WebSphere Server %s does not exist !!!" % scope
	
	prov=AdminConfig.getid(scope+'JDBCProvider:'+drivers.driverconfig[type]['JDBCProvName']+'/')
	if prov == "":
		print "	JDBC Provider doesn't exist, creating ..."
		prov=AdminConfig.create('JDBCProvider', srvr, [
			['name', drivers.driverconfig[type]['JDBCProvName']],
			['providerType', drivers.driverconfig[type]['JDBCProvName']],
			['xa', drivers.driverconfig[type]['xa_flag']],
			['implementationClassName', drivers.driverconfig[type]['implementationClassName']],
			['classpath', drivers.driverconfig[type]['classpath']]])
	else:
		print "	JDBC Provider exists ..."	
	return prov

def setdriverprops(AdminConfig,ds,appl,type,dshost,dsmapdb):
	print "	Configuring DataSource settings"
	ps=AdminConfig.create('J2EEResourcePropertySet', ds, [])
	
	if type=='native' or type=='toolbox':
		drivers.setiseriesdriverprops(AdminConfig, ps, appl, type, dshost)
	elif type=='universal':
		drivers.setuniversaldriverprops(AdminConfig, ps, appl, dshost, dsmapdb)
	else:
		raise Exception, "	DataSource type %s not supported !!!" % type

def checkdatasource(AdminConfig,nodename,servername,appl,dshost,dsmapdb,environment,type,prov,cell):
	"""
	Check datasources, rename jndi if needed.

	:param AdminConfig, AdminTask: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param nodename: Name of the Node
	:param servername: Name of the Server
	:param appl: targeted application
	:param dshost: config in apps.py
	:param dsmapdb: db name
	:param environment: application environement (BETA,TEST,CPK,400,200,500)
	:param type: Type of db connection, Toolbox, Universal, Mssql
	:param prov: JDBC Provider
	"""
	print "Checking DataSource"
	apps.initialize(environment)

	if nodename=='':
		scope='/ServerCluster:'+servername+'/'	
	elif servername=="nodeagent":
		scope='/Node:'+nodename+'/'
	else:
		scope='/Node:'+nodename+'/Server:'+servername+'/'
		
	
	if appl == "DDD_":
		appl1=appl
		appl2="BPE_"
	elif appl == "BPE2":
		appl1="BPE_"
		appl2="BPE_"
	else:
		appl1=appl
		appl2=appl
		
	jndiname="jdbc/"+appl2+environment
	if appl == "DPZ":
		jndiname="jdbc/DPZ_RC"
	if appl == "INTGDPZ":
		jndiname="jdbc/INTG_RC"
	if appl == "DMG":
		jndiname="jdbc/DMG_AS400_RC"
	if appl == "INTGDMG":
		jndiname="jdbc/DMG_LINUX_RC"
	if appl == "LNXGDMG_":
		jndiname="jdbc/DMG_LINUX_RC"
	if appl == "AS400GDMG_":
		jndiname="jdbc/DMG_AS400_RC"
	if appl == "LNXCH4_":
		jndiname="jdbc/CH4_LINUX_RC"
	if appl == "AS400CH4_":
		jndiname="jdbc/CH4_AS400_RC"
	if appl == "BMD":
		jndiname="jdbc/MONDB"
	if appl == "IDITDS":
		jndiname="idit.jdbc.IDITDS"
	if appl == "BGL2":
		jndiname="jdbc/DILDB"
	if appl == "DCIDXICAT":
		jndiname="jdbc/ICAT_IDX"
	if appl == "DCADMICAT":
		jndiname="jdbc/ICAT_ADM"
	if appl == "DCDDRA":
		jndiname="jdbc/DDRA"
	if appl == "AS400MCT_":
		jndiname="jdbc/CARENET_AS400_RC"
	if appl == "LNXMCT_":
		jndiname="jdbc/CARENET_LINUX_RC"
	if appl == "AS400EFAC_":
		jndiname="jdbc/EFAC_AS400_RC"
	if appl == "LNXEFAC_":
		jndiname="jdbc/EFAC_LINUX_RC"
# 	if appl == "DCADM5XX":
# 		jndiname="jdbc/ICAT_ADM"
	if appl == "AS400EBP_":
		jndiname = "jdbc/EBP_506"
# 	if appl == "DCADM05X":
# 		jndiname="jdbc/DCADM05X"

	#ds=AdminConfig.getid(scope+'JDBCProvider:'+drivers.driverconfig[type]['JDBCProvName']+'/DataSource:'+appl1+environment+'/')
	ds = AdminConfig.list('DataSource', AdminConfig.getid(cell)).splitlines()
	ds = [ el for el in ds if el.startswith(appl1+environment) ]
	if len(ds) > 0:
		ds = ds[0]
		msg = 'DataSource %s already exists for %s' % (appl1+environment, scope)
		print(msg)
	else:
		print "	Creating DataSource"
		ds = AdminConfig.create('DataSource', prov, [
		   ['name', appl1+environment],
		   ['datasourceHelperClassname', drivers.driverconfig[type]['dsHelper']],
		   ['description', "Datasource for "+appl1+environment],
		   ['jndiName', jndiname]
		])

	# print "  Setting (prepared)StatementCacheSize to 25"
	# AdminConfig.modify(ds,[['statementCacheSize',25]])
	print "  Setting (prepared)StatementCacheSize to 100"
	AdminConfig.modify(ds,[['statementCacheSize',100]])
	
	setdriverprops(AdminConfig,ds,appl,type,dshost,dsmapdb)
	
	# change min/max/timeout according to env : team=0/10/1800 pp=0/20/3600 p=0/30/7200
	minconn=0
	maxconn=10
	timeout=1800
	try:    
		minconn=servers.serverconfig[dshost]['minconn']
		maxconn=servers.serverconfig[dshost]['maxconn']
		timeout=servers.serverconfig[dshost]['timeout']
	except: KeyError 
	
	print "	Configuring ConnectionPool settings"
	cp=AdminConfig.showAttribute(ds, 'connectionPool')
	AdminConfig.modify(cp, [['agedTimeout',0],
						    ['connectionTimeout', 30],
						    ['purgePolicy', "EntirePool"],
						    ['unusedTimeout', timeout],
						    ['reapTime', 300],
						    ['minConnections', minconn],
						    ['maxConnections', maxconn]])

	if apps.appconfig[appl]['isCmpDs'] == "true":
		raise Exception, "CMP datasources not implemented "
		#enablecmp $nodename $servername $appl $environment $ds

	return ds

def setauth(AdminConfig,datasource,authalias):
	"""
	Create authentication for datasource

	:param AdminConfig, AdminTask: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param datasource: Java Obj returning by creating datasource (checkj2datasource, checkudbdatasource)
	:param authalias: Authentication generated by Jython scripts with user/password information
	"""
	print "	Configuring JAAS for DataSource ( %s )" % authalias
	AdminConfig.modify(datasource, [['mapping', [['authDataAlias', authalias], ['mappingConfigAlias', "DefaultPrincipalMapping"]]],
								    ['authDataAlias', authalias]])

def checkj1datasource(AdminConfig,AdminTask,type,wsnode,wsserver,appl,dshost,env):
	print "Checking Unauthenticated DataSource (%s)" % env
	provider=checkjdbcprovider(AdminConfig,type,wsnode,wsserver)
	datasource=checkdatasource(AdminConfig,wsnode,wsserver,appl,dshost,'',env,type,provider)

def checkj2datasource(AdminConfig,AdminTask,type,wsnode,wsserver,appl,dshost,env,username,password):
	"""
	create toolbox (as400) datasource
	
	:param AdminConfig, AdminTask: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param type: Type of db connection, Toolbox, Universal, Mssql
	:param wsnode: Was Node in which create the datasource
	:param wsserver: Was server where is the Was Node
	:param appl: targeted application
	:param dshost: config in apps.py
	:param env: application environement (BETA,TEST,CPK,400,200,500)
	:param username: User used to connect to DB
	:param password: Password for user (username)
	"""
	print "Checking Authenticated DataSource (%s)" % env
	authalias=jaas.configjaas(AdminConfig,dshost,username,password)
	provider=checkjdbcprovider(AdminConfig,type,wsnode,wsserver)
	datasource=checkdatasource(AdminConfig,wsnode,wsserver,appl,dshost,'',env,type,provider)
	setauth(AdminConfig,datasource,authalias)

def checkudbdatasource(AdminConfig,AdminTask,type,wsnode,wsserver,appl,dshost,dsmapdb,env,username,password):
	"""
	create universal (udbi) datasource
	
	:param AdminConfig, AdminTask: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param type: Type of db connection, Toolbox, Universal, Mssql
	:param wsnode: Was Node in which create the datasource
	:param wsserver: Was server where is the Was Node
	:param appl: targeted application
	:param dshost: config in apps.py
	:param dsmapdb: db name
	:param env: application environement (BETA,TEST,CPK,400,200,500)
	:param username: User used to connect to DB
	:param password: Password for user (username)
	"""
	print "Checking Authenticated DataSource (%s)" % dsmapdb
	authalias=jaas.configjaas(AdminConfig,dshost,username,password)
	provider=checkjdbcprovider(AdminConfig,type,wsnode,wsserver)
	datasource=checkdatasource(AdminConfig,wsnode,wsserver,appl,dshost,dsmapdb,env,type,provider)
	setauth(AdminConfig,datasource,authalias)

