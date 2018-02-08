service {"rsync":		# service name to be enabled in agent
	ensure => running,	# ensure it is running by default once implemented manifest
	enable => true,		# and it will be enabled by default as well
}
