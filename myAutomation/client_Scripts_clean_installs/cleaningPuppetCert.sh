#!/bin/bash

################# REVOKING A SIGNED CERTIFICATE ##################################

# SERVER

#$ sudo /opt/puppetlabs/bin/puppet cert revoke <agent_fqdn>

#$ sudo /opt/puppetlabs/bin/puppet cert clean <agent_fqdn>

# CLIENT/AGENT

systemctl stop puppet.service
systemctl stop mcollective.service
rm -Rf /etc/puppetlabs/puppet/ssl
# clean .pem:
find /etc/puppetlabs/puppet/ssl -name 02di20161542846.ip14aai.com.pem -delete
# clear cache info:
rm -Rf /opt/puppetlabs/puppet/cache
systemctl start puppet.service
systemctl start mcollective.service

systemctl status puppet.service
