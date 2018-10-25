import sys
sys.path.append('../share/procs')

import save
import validateparams

def updateNodes(AdminConfig):
	"""
	Function created to update Nodes Variables. *Example: That function update Path to jdbc drivers.*

	:param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	"""
	nodesraw=AdminConfig.list('Node')
	nodes=nodesraw.split(java.lang.System.getProperty("line.separator"))
	
	for curnode in nodes:
		print "Checking %s" % curnode
		varSubstitutions = AdminConfig.list("VariableSubstitutionEntry",curnode).split(java.lang.System.getProperty("line.separator"))
		
		for varSubst in varSubstitutions:
			getVarName = AdminConfig.showAttribute(varSubst, "symbolicName")
			if getVarName == 'MICROSOFT_JDBC_DRIVER_PATH':
				print "\tChanging %s" % getVarName
				AdminConfig.modify(varSubst,[['value','${WAS_INSTALL_ROOT}/optionalLibraries/sqljdbc']])
			if getVarName == 'OS400_TOOLBOX_JDBC_DRIVER_PATH':
				print "\tChanging %s" % getVarName
				AdminConfig.modify(varSubst,[['value','${WAS_INSTALL_ROOT}/optionalLibraries/jt400']])
			if getVarName == 'DB2UNIVERSAL_JDBC_DRIVER_PATH':
				print "\tChanging %s" % getVarName
				AdminConfig.modify(varSubst,[['value','${WAS_INSTALL_ROOT}/optionalLibraries/db2udbdriver']])

def updateSync(AdminConfig):
	"""
	Update & Synchronize nodes ???
	
	:param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	"""
	syncsraw=AdminConfig.list('ConfigSynchronizationService')
	syncs=syncsraw.split(java.lang.System.getProperty("line.separator"))
	
	for cursync in syncs:
		print "Updating %s" % cursync
		AdminConfig.modify(cursync,[['synchInterval',60],['synchOnServerStartup','true']])


def main():
	validateparams.validateparams([])
	updateNodes(AdminConfig)
	updateSync(AdminConfig)
	save.savework(AdminConfig)
	
	
if __name__ == '__main__':
	main()

