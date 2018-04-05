# Sources: urbanpenguin
# plus: Gyaan With Anand Nayyar's Youtube Channel

# make sure hostname is setup, same for domain name (/etc/hosts)

127.0.0.1	localhost host01.example.com
127.0.1.1	02DI20161542844.ip14aai.com 02DI20161542844
10.57.121.196	02DI20161542844.ip14aai.com 02DI20161542844

sudo apt-get install -y slapd ldap-utils

# setup password for LDAP Server, better not same as root in this same server :o

# /etc/ldap/ldap.conf

# this info comes from domain name: ip14aai.com
BASE	dc=ip14aai,dc=com
#URI	ldap://ldap.example.com ldap://ldap-master.example.com:666
URI	ldap://10.57.121.196 # default port is 389, if you need to specify another one: ldap://10.57.121.196:399

# Now configure the firewall settings:

ip14aai@02DI20161542844:~$ sudo ufw app list
Available applications:
  Apache
  Apache Full
  Apache Secure
  Bind9
  CUPS
  OpenLDAP LDAP
  OpenLDAP LDAPS
  OpenSSH
  Postfix
  Postfix SMTPS
  Postfix Submission
  Samba
  Squid

ip14aai@02DI20161542844:~$ sudo ufw allow "openLDAP LDAP"
Rule added
Rule added (v6)

# reconfigure package with changes: everything by default, except DB to use, which shall be HDB

sudo dpkg-reconfigure slapd

# checking Config from the server itself:
ip14aai@02DI20161542844:~$ ldapsearch -x -h localhost # or IP of the server

## LIST OF ARGUMENTS PASSING TO ldapsearch COMMAND:
-x basic auth instead of SASL
-h to specify host
-H uri of server (ldap://)
-D binddn (binding ldap directory)
-b searchbase
-W prompt for single auth
-f file (for modifications, add, deletion ...)

# an example for checking the whole ldap config from the server:
ip14aai@02DI20161542844:~$ ldapsearch -x -h localhost # or IP of the server
# extended LDIF
#
# LDAPv3
# base <dc=ip14aai,dc=com> (default) with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# ip14aai.com
dn: dc=ip14aai,dc=com
objectClass: top
objectClass: dcObject
objectClass: organization
o: ip14aai.com
dc: ip14aai

# admin, ip14aai.com
dn: cn=admin,dc=ip14aai,dc=com
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator

# search result
search: 2
result: 0 Success

# numResponses: 3
# numEntries: 2

### Now is time to install phpldapadmin, so that we can administer LDAP via browser
sudo apt-get install phpldapadmin

# Configuration: /etc/phpldapadmin/config.php
# Modify these lines to appear like:
162	// $config->custom->appearance['hide_template_warning'] = true;
289	$servers->setValue('server','name','ip14aai LDAP Server');
303	$servers->setValue('server','base',array('dc=ip14aai,dc=com'));
329	$servers->setValue('login','bind_id','cn=admin,dc=ip14aai,dc=com');

# Now try access (without using proxy RTD!) via browser:
http://10.57.121.196/phpldapadmin


## CREATING GROUP AND USERS IN PHPLDAPADMIN:

Click on domain: dc=ip14aai, dc=com

Create a new entry here --> x Generic: Organisational Unit (eg: sales) - Commit

Create a child entry --> x Generic: Posix Group - Group: sales-group - Commit

Create a child entry --> x Generic: User Account - Select sales-group as Group, home directory (does not need to match anything existing in server)

To check everything is correct: ldapsearch -x -h localhost

### feature to export / configure / import a new user:

From an existing user, who was manually created, we click on Export, copying the config text, then create a new file <username>.ldif, pasting
content of previous user. Edit username, name, group if needed, and so on. Save file. 
Run command:
ldapadd -c -x -D "cn=admin,dc=test,dc=net" -W -f <filename>.ldif

If we check the config from the ldapadmin, it should reflect everything applied in the file ... this way several users can be created quickly,
even automating the task.



###### ldaputils ######
### MANUALLY ADDING USER FROM SCRIPTS USING .ldif, even the initial one, no phpldapadmin is used:

# Hierarchy: ou ... group ... users - see *.ldif files with examples for each

# create-marketing-ou.ldif
dn: ou=marketing-ou,dc=ip14aai,dc=com
ou: marketing-ou
description: Users of Marketing ou
objectClass: organizationalUnit
objectClass: top

# create-marketing-group.ldif
dn: cn=marketing-group,ou=marketing-ou,dc=ip14aai,dc=com
cn: marketing-group
objectClass: posixGroup
objectClass: top
gidNumber: 4001

# users.ldif : (addig users to ou / group):
dn: cn=Juan Berenguel,cn=sales-group,ou=sales,dc=ip14aai,dc=com
cn: Juan Berenguel
gidnumber: 500
givenname: Juan
homedirectory: /home/users/jberenguel
loginshell: /bin/sh
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: shadowAccount
objectclass: top
sn: Berenguel
uid: jberenguel
uidnumber: 1000
userpassword: {MD5}qUZSqpfHIRuolU3RWjz4OA==

# then add user to ldap:
ldapadd -x -h locahost -D "cn=admin,dc=ip14aai,dc=com" -W -f users.ldif

# check entries now:
ldapsearch -x -LLL -H ldap:/// -b dc=ip14aai,dc=com

# filtering by ou, for instance sales-ou:
ldapsearch -x -LLL -H ldap:/// -b ou=sales-ou,dc=ip14aai,dc=com


######## THE BEST FOR MANAGING LDAP FROM BASH:

### LDAPSCRIPTS: In order to have a package which includes commands that allow us to create groups and users easily:

sudo apt-get install ldapscripts

sudo nano -c /etc/ldapscripts/ldapscripts.conf

SERVER="ldap://localhost"

SUFFIX="dc=ip14aai,dc=com"
GSUFFIX="ou=Group" # defined by us
USUFFIX="ou=People" # defined by us

BINDON="cn=admin,dc=ip14aai,dc=com" # created by us
BINDPWDFILE="/etc/ldapscripts/ldapscripts.passwd"   -------------->>>>>>>>>> IMPORTAAAAAAAAAAAAAANTTTT: This passwd is the LDAP, edit!
# do the following command: echo -n "<literal-passwd>" > /etc/ldapscripts/ldapscripts.passwd
#### SET THE PASSWD!!!!!!!!!!!!!!!!!!!!!!!!!!##### IPG ####

GIDSTART="10000"
UIDSTART="10000"
MIDSTART="20000"

GCLASS="posixGroup"
CREATEHOMES="yes"

# create an OU with ldapscripts, using one .ldif file: ou.ldif:
sudo ldapadd -x -h localhost -D "cn=admin,dc=ip14aai,dc=com" -W -f ou.ldif

# create a group with scripts:

sudo ldapaddgroup ldsales

# add user:

sudo ldapadduser fred ldsales

# delete user:

sudo ldapdeleteuser fred

# modify user:

sudo ldapmodifyuser fred
replace: uid
uid: fred67
(press Ctrl+D)

## or using a file with argument -f:
## to avoid SASL identification, use better regular auth with W option plus x
ldapmodify -x -h localhost -D "cn=admin,dc=ip14aai,dc=com" -W -f modify_group_sales.ldif

# see details for this particular user:
# -H unencrypted ldap query
ldapsearch -x -LLL -H ldap:/// -b dc=ip14aai,dc=com uid=fred67

# Let's try to connect from client:

sudo apt-get install ldap-auth-client nscd

# if you need to reconfigure this step:

sudo dpkg-reconfigure ldap-auth-config # remember dc=ip14aai,dc=com ... URI=ldap://10.57.121.196

# configuring services:

sudo auth-client-config -t nss -p lac_ldap

# see the details under:
/etc/auth-client-config/profile.d/ldap-auth-config

#######################
# Checking ldap from a client: ldap-utils:
ldapsearch -x -H ldap://10.136.137.110 -LLL -b "dc=ip14aai,dc=com"

# in case the dc info is unknown, it can be retrieved with:
ldapsearch -H ldap://10.136.137.110 -x -LLL -b "" namingContexts
# and then query as 

# Using PAM for assisting with the creation of the home dir of the user who connects to server via this client:

sudo nano -c /usr/share/pam-configs/mkhomedir

Name: activate mkhomedir via PAM
Default: yes
Priority: 900
Session-Type: Additional
Session:
	required pam_mkhomedir.so umask=0022 skel=/etc/skel

# save and update:

sudo pam-auth-update

sudo /etc/init.d/nscd restart

getent passwd # users created in openldap server will be listed in the end ...

# login to test and create home dir, first time:

su jberenguel

## to check info about supported features enabled in our ldap server:
ldapsearch -H ldap:// -x -s base -b "" -LLL "+"
