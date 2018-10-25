# module to update WebSphere ports

# proc removevhostentry { vhost port  } {
# 	global AdminConfig

# 	set allist [$AdminConfig list HostAlias $vhost]
# 	for { set i 0 } { $i < [llength $allist] } { incr i 1 } {
# 		if { [$AdminConfig showAttribute [lindex $allist $i] port] == $port } {
# 			$AdminConfig remove [lindex $allist $i]
# 		}
# 	}  
# }

# proc addvhostentry { vhost hostname port  } {
# 	global AdminConfig
#  
# 	$AdminConfig create HostAlias $vhost [list [list hostname $hostname] [list port $port]]
# }

# proc obtainvhost { nodename servername } {
# 	global AdminConfig
	
# 	set ext "_vhost"
# 	set vhost [$AdminConfig getid /VirtualHost:$nodename$ext/]
# 	if { $servername=="dmgr" } {
# 		set vhost [$AdminConfig getid /VirtualHost:admin_host/]
# 	}

# 	if { $vhost == "" } {
# 		set vhost [$AdminConfig create VirtualHost [$AdminConfig list Cell] [list [list name $nodename$ext]]]
# 	}

# # detect mime-type
# 	# add mime-types
# 		# image/x-icon ico
# 		# application/x-java-jnlp-file jnlp

# 	set melist [$AdminConfig list MimeEntry $vhost]
# 	for { set i 0 } { $i < [llength $melist] } { incr i 1 } {
# 		if { [$AdminConfig showAttribute [lindex $melist $i] type] == "image/x-icon" } {
# 			$AdminConfig remove [lindex $melist $i]
# 		} else {
# 			if { [$AdminConfig showAttribute [lindex $melist $i] type] == "application/x-java-jnlp-file" } {
# 				$AdminConfig remove [lindex $melist $i]
# 			}
# 		}
# 	}  
# 	$AdminConfig create MimeEntry $vhost [list [list type "image/x-icon"] [list extensions "ico"]]
# 	$AdminConfig create MimeEntry $vhost [list [list type "application/x-java-jnlp-file"] [list extensions "jnlp"]]

# 	return $vhost
# }

def createportdict(baseportstring):
	baseport=int(baseportstring)
	ports={}
	ports['WC_defaulthost']=baseport
	ports['WC_defaulthost_secure']=baseport+1
	ports['BOOTSTRAP_ADDRESS']=baseport+2
	ports['ORB_LISTENER_ADDRESS']=baseport+3
	ports['SOAP_CONNECTOR_ADDRESS']=baseport+4
	ports['CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS']=baseport+5
	ports['CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS']=baseport+6
	ports['SAS_SSL_SERVERAUTH_LISTENER_ADDRESS']=baseport+7
	ports['DCS_UNICAST_ADDRESS']=baseport+8
	ports['SIB_ENDPOINT_ADDRESS']=baseport+12
	ports['SIB_ENDPOINT_SECURE_ADDRESS']=baseport+13
	ports['SIB_MQ_ENDPOINT_ADDRESS']=baseport+14
	ports['SIB_MQ_ENDPOINT_SECURE_ADDRESS']=baseport+15
	ports['SIP_DEFAULTHOST']=baseport+16
	ports['SIP_DEFAULTHOST_SECURE']=baseport+17
	ports['WC_adminhost']=baseport+18
	ports['WC_adminhost_secure']=baseport+19
	return ports

def updateports(AdminTask,nodename,servername,hostname,baseport):
	if servername =='dmgr' or servername == 'nodeagent':
		raise Exception, 'Updateports can''t handle administrative servers (yet)'
 	
 	portslist=createportdict(baseport).items()
 	for port in portslist:
 		AdminTask.modifyServerPort(servername, '[-nodeName '+nodename+' -endPointName '+port[0]+' -host '+hostname+' -port '+str(port[1])+' -modifyShared]')
 		