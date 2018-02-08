#!/bin/bash
systemctl stop puppet.service
systemctl stop mcollective.service

rm -Rf /etc/puppetlabs/puppet/
rm -Rf /var/log/puppetlabs/
rm -Rf /opt/puppetlabs/puppet/cache/

apt-get remove puppet-agent
apt-get purge puppet-agent
apt-get remove puppetlabs-release-pc1
apt-get purge puppetlabs-release-pc1

