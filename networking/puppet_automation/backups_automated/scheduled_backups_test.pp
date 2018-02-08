# create directory tree structure in agents

file { [ '/backups', '/backups/scripts', '/backups/logs', '/backups/totalBkp' ]:
	ensure => 'directory',
	owner  => 'root',
	group  => 'root',
	mode   => '0750',
}

file { '/backups/scripts/totalBkp.sh':			
	source => "puppet:///modules/backup_clients/totalBkp.sh",
	source_permissions => 'use'
}

cron { 'bkp_cron':
	ensure => 'present',
	environment => 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/bin/bash',
	command => '/backups/scripts/totalBkp.sh',
	user => 'root',
	hour => '17',
	minute => '25',
}
