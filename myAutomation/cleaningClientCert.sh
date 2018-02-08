#!/bin/bash

/opt/puppetlabs/bin/puppet cert revoke 02di20161542846.ip14aai.com
/opt/puppetlabs/bin/puppet cert clean 02di20161542846.ip14aai.com

/opt/puppetlabs/bin/puppet cert list --all

cp /recordedHosts/recordedHosts.template /recordedHosts/recordedHosts.txt

rm /etc/nagios3/conf.d/02*
