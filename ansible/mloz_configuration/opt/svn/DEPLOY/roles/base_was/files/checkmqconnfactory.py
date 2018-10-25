import sys
sys.path.append('../datasources/config')
sys.path.append('../share/procs')

import jaas
#import drivers
#import apps
import servers




#jmscfs.append(['teamNodeDpz80','DPZ_COM80','DMG_QCF_054','jms/DMG_QCF_RC', \
#	'QM.054','SYSTEM.DEF.SVRCONN','ALPHA','14054','INTG054','GTNI054'])


def checkmqcf(AdminConfig,AdminTask,mqcf):
	print "Creating MQ Connection Factory (%s)" % mqcf[2]
	authalias=jaas.configjaas(AdminConfig,mqcf[5],mqcf[6],mqcf[7])
	
	if mqcf[0]=='':
		scope=AdminConfig.getid('/ServerCluster:'+mqcf[1]+'/JMSProvider:WebSphere MQ JMS Provider/')
	else:
		scope=AdminConfig.getid('/Node:'+mqcf[0]+'/Server:'+mqcf[1]+'/JMSProvider:WebSphere MQ JMS Provider/')
	
	AdminTask.createWMQConnectionFactory(
		scope,
		 '[-type QCF -name '+mqcf[2]+
		 ' -jndiName '+mqcf[3]+
		 ' -qmgrName '+mqcf[4]+
		 ' -wmqTransportType BINDINGS_THEN_CLIENT -qmgrSvrconnChannel '+mqcf[9]+
		 ' -qmgrHostname '+servers.serverconfig[mqcf[5]]['serverName']+
		 ' -qmgrPortNumber '+mqcf[8]+
		 ' -sslType NONE -clientId  -providerVersion  -mappingAlias DefaultPrincipalMapping'+
		 ' -containerAuthAlias '+mqcf[5]+'/'+mqcf[6]+
		 ' -componentAuthAlias  -xaRecoveryAuthAlias  -support2PCProtocol true ]')
