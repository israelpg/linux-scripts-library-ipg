file {'/tmp/it_works2.txt':					# resource type file and filename
	ensure => present,					# make sure it exists
	mode => '0644',						# file permissions
	content => "Site2. It works on ${ipaddress_enp0s3}!\n"	# print the enp0s3 IP fact
}
