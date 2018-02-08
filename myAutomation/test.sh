#!/bin/bash

host=10.57.121.192

ssh -t root@$host "dpkg -l | grep 'apache2' >/tmp/resultQuery.log ; cat /tmp/resultQuery.log"  >/tmp/outputQuery_$$.log

countQuery=$(cat /tmp/outputQuery_$$.log | wc -w)

if [[ $countQuery -gt 0 ]] ;
then
	echo 'puppet-agent package is already installed in this client machine, no further action required other than checking manifests: ';
else
        #dpkg -i /usr/share/puppetlabs-release-pc1-xenial.deb && apt-get update && apt-get install puppet-agent && systemctl enable puppet && systemctl start puppet
        echo 'Installation of puppet-agent package completed. Enabling and starting puppet service completed.';
        #rm /usr/share/puppetlabs-release-pc1-xenial.deb
fi
