import sys
sys.path.append('../share/procs')


#import java
import validateparams


#lineSeparator = java.lang.System.getProperty('line.separator')


def findOrCreateVHost(AdminConfig,vhostname):
	"""
	Search & Find vhost or create it if not found.
	
	:param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param vhostname: vhostname
	"""
	vhost=AdminConfig.getid('/VirtualHost:'+vhostname+'/')
	if vhost == '':
		#cells=AdminConfig.list('Cell').split(lineSeparator)
		cells=AdminConfig.list('Cell').splitlines()
		vhost=AdminConfig.create('VirtualHost',cells[0],[['name',vhostname]])
	return vhost


def resetVHost(AdminConfig,vhostname):
	"""
	Reset/Remove Vhost.
	
	:param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param vhostname: vhostname
	"""
	vhost=findOrCreateVHost(AdminConfig,vhostname)
	AdminConfig.modify(vhost,[['aliases', []]])
	return vhost


def addVHostAlias(AdminConfig,vhost,hostname,port):
	"""
	Add Alias to vhost.
	
	:param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
	:param vhost: vhostname
	:param hostname: new url
	:param port: new port
	"""
	AdminConfig.modify(vhost,[['aliases', [ [['hostname',hostname],['port',port]] ]]])


