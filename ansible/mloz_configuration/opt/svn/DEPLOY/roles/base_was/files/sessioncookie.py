import save
import validateparams

def modifycookiename(AdminConfig,nodename,servername,prefix):

	server = AdminConfig.getid('/Node:'+nodename+'/Server:'+servername+'/')
	appsrv=AdminConfig.list('ApplicationServer',server)
	webcntr=AdminConfig.list('WebContainer',appsrv)

	print "  Configure SESSION Cookie for %s" % servername
	sessmgr=AdminConfig.list('SessionManager',webcntr)
	
	cookie=AdminConfig.showAttribute(sessmgr,'defaultCookieSettings')
	AdminConfig.modify(cookie,[['name',prefix+'SESSIONID']])
	
# modifycookiename(AdminConfig,'integrationNodeDemo0_61','EDEMOCLIENTS61','CLNT')
# modifycookiename(AdminConfig,'integrationNodeDemo0_61','JADE_EDEMO61','JADE')
# modifycookiename(AdminConfig,'integrationNodeDemo0_61','CATA_EDEMO61','CATA')
# modifycookiename(AdminConfig,'integrationNodeDemo0_61','INTG_EDEMO61','INTG')

# validateparams.validateparams([])
# save.savework(AdminConfig)
