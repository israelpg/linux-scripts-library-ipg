#!/bin/bash

#sudo apt-get install ldap-auth-client nscd

apt-get remove ldap-auth-client
apt-get purge ldap-auth-client
apt-get remove nscd
apt-get purge nscd
rm -Rf /etc/ldap
