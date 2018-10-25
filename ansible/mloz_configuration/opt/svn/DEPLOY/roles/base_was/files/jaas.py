def configjaas(AdminConfig,dshost,username,password): 
	print "Checking JAAS login"
	sec=AdminConfig.getid('/Security:/')
	
	authalias=dshost+'/'+username
	authlistraw=AdminConfig.list('JAASAuthData')

#	print authlistraw
# get line separator 
	import  java
	lineSeparator = java.lang.System.getProperty('line.separator')
	authlist = authlistraw.split(lineSeparator)
	
	authexists="false"
	for authentry in authlist:
#		print "Checking %s" % authentry
		if authentry != "":
			if AdminConfig.showAttribute(authentry,'alias')==authalias:
				authexists="true"
				print "	Authentication alias %s already exists, not modified" % authalias

	if authexists == "false" :
		print "	Creating authentication alias %s" % authalias
		AdminConfig.create('JAASAuthData', sec, [['alias',authalias],['userId',username],['password',password]])	
	return authalias
