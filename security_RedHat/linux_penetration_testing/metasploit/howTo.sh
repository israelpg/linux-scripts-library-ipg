#!/bin/bash

# Sources:
# www.offensive-security.com/metasploit-unleashed
# www.wonderhowto.com

# Installation:
# msfinstall script needs to be executed
./msfinstall

# Make sure daemon postgresql.service is enabled and running
systemctl status postgresql.service

# execute console, use a non-root user (id -u ! 0):
./msfconsole

# First time you must setup the environment:
msf > msfdb start
[*] exec: msfdb start

 ** Welcome to Metasploit Framework Initial Setup **
    Please answer a few questions to get started.

Would you like to add msfconsole and other programs to your default PATH? Y
You may need to start a new terminal or log in again for this to take effect.

Would you like to use and setup a new database (recommended)? Y
Creating database at /home/ip14aai/.msf4/db
Starting database at /home/ip14aai/.msf4/db...success
Creating database users
Creating initial database schema

 ** Metasploit Framework Initial Setup Complete **

# Check status:
msf > db_status
[*] postgresql connected to msf

# listing help:
?

# you can always go back with:
msf > back

# clear screen:
clear

#### Workspaces in Metasploit:
msf > workspace
* default
msf > workspace -a ipg-exploitation
[*] Added workspace: ipg-exploitation
msf > workspace
  default
* ipg-exploitation
msf > 
# you can delete a workspace with:
msf > workspace -d <workspace_name>

# search for workspace options:
msf > workspace -h
Usage:
    workspace                  List workspaces
    workspace -v               List workspaces verbosely
    workspace [name]           Switch workspace
    workspace -a [name] ...    Add workspace(s)
    workspace -d [name] ...    Delete workspace(s)
    workspace -D               Delete all workspaces
    workspace -r <old> <new>   Rename workspace
    workspace -h               Show this help information

#### Importing and Scanning:
# an xml with the hosts list can be imported
$ nmap -p 22 10.136.137.0/24 -oX nmap_network.xml

msf > db_import /home/ip14aai/tests/nmap_network.xml
[*] Importing 'Nmap XML' data
[*] Import: Parsing with 'Nokogiri v1.8.2'
[*] Importing host 10.136.137.1
[*] Importing host 10.136.137.25
[*] Importing host 10.136.137.39
[*] Importing host 10.136.137.72
[*] Importing host 10.136.137.74
[*] Importing host 10.136.137.75
[*] Importing host 10.136.137.77
[*] Importing host 10.136.137.82
[*] Importing host 10.136.137.86
[*] Importing host 10.136.137.103
[*] Importing host 10.136.137.122
[*] Successfully imported /home/ip14aai/tests/nmap_network.xml

msf > hosts

Hosts
=====

address         mac  name                                os_name  os_flavor  os_sp  purpose  info  comments
-------         ---  ----                                -------  ---------  -----  -------  ----  --------
10.136.137.1                                             Unknown                    device         
10.136.137.25        p02di1136763rtd.net1.cec.eu.int     Unknown                    device         
10.136.137.39        p02di135010768.net1.cec.eu.int      Unknown                    device         
10.136.137.72        ginos-imac.net1.cec.eu.int          Unknown                    device         
10.136.137.74        p02di135010869.net1.cec.eu.int      Unknown                    device         
10.136.137.75        p02di141990040.net1.cec.eu.int      Unknown                    device         
10.136.137.77        javiers-imac.net1.cec.eu.int        Unknown                    device         
10.136.137.82        d02di1602131rtd.net1.cec.eu.int     Unknown                    device         
10.136.137.86        staruro-virtualbox.net1.cec.eu.int  Unknown                    device         
10.136.137.103       p02di1339945rtd.net1.cec.eu.int     Unknown                    device         
10.136.137.122       02di20161235444.net1.cec.eu.int     Unknown                    device  

# another option is using the internal msf nmap command for -A adding a host in the db:
msf > db_nmap -A <IP>

# hosts search filter options:
# -c column, -S value
msf > hosts -c address,os_flavor -S Linux

# if we are using one exploit (e.g.: auxiliary tcp) we can -R run the exploit

msf auxiliary(tcp) > hosts -c address,os_flavor -S Linux -R

#### Backing up our Data as an xml file, so that can be imported again:
msf > db_export -f xml /root/msfu/exported_1.xml

#### displaying all exploits available:
show exploits

# search something in particular:
search mysql

# we can search directly by type, platform and regex for exploit:
msf > search type:exploit platform:windows login

# show details for a particular exploit:

info <exploit_info>

# use exploit and show its options:

use <exploit>

msf > use exploit/windows/mssql/mssql_linkcrawler
msf exploit(windows/mssql/mssql_linkcrawler) > show options

Module options (exploit/windows/mssql/mssql_linkcrawler):

   Name                 Current Setting  Required  Description
   ----                 ---------------  --------  -----------
   DEPLOY               false            no        Deploy payload via the sysadmin links
   DEPLOYLIST                            no        Comma seperated list of systems to deploy to
   PASSWORD                              yes       The password for the specified username
   RHOST                                 yes       The target address
   RPORT                1433             yes       The target port (TCP)
   SRVHOST              0.0.0.0          yes       The local host to listen on. This must be an address on the local machine or 0.0.0.0
   SRVPORT              8080             yes       The local port to listen on.
   SSL                  false            no        Negotiate SSL for incoming connections
   SSLCert                               no        Path to a custom SSL certificate (default is randomly generated)
   TDSENCRYPTION        false            yes       Use TLS/SSL for TDS data "Force Encryption"
   URIPATH                               no        The URI to use for this exploit (default is random)
   USERNAME             sa               no        The username to authenticate as
   USE_WINDOWS_AUTHENT  false            yes       Use windows authentification (requires DOMAIN option set)


Exploit target:

   Id  Name
   --  ----
   0   Automatic

# set an option:
# set <option>=<value>

set RPORT 1455



## SCENARIO
# Example: mysql-login exploit tool

msf > search mysql
[!] Module database cache not built yet, using slow search

Matching Modules
================

   Name                                                  Disclosure Date  Rank       Description
   ----                                                  ---------------  ----       -----------
   auxiliary/admin/http/manageengine_pmp_privesc         2014-11-08       normal     ManageEngine Password Manager SQLAdvancedALSearchResult.cc Pro SQL Injection
   auxiliary/admin/http/rails_devise_pass_reset          2013-01-28       normal     Ruby on Rails Devise Authentication Password Reset
   auxiliary/admin/mysql/mysql_enum                                       normal     MySQL Enumeration Module
   auxiliary/admin/mysql/mysql_sql                                        normal     MySQL SQL Generic Query
   auxiliary/admin/tikiwiki/tikidblib                    2006-11-01       normal     TikiWiki Information Disclosure
   auxiliary/analyze/jtr_mysql_fast                                       normal     John the Ripper MySQL Password Cracker (Fast Mode)
   auxiliary/gather/joomla_weblinks_sqli                 2014-03-02       normal     Joomla weblinks-categories Unauthenticated SQL Injection Arbitrary File Read
   auxiliary/scanner/mysql/mysql_authbypass_hashdump     2012-06-09       normal     MySQL Authentication Bypass Password Dump
   auxiliary/scanner/mysql/mysql_file_enum                                normal     MYSQL File/Directory Enumerator
   auxiliary/scanner/mysql/mysql_hashdump                                 normal     MYSQL Password Hashdump
   auxiliary/scanner/mysql/mysql_login                                    normal     MySQL Login Utility
   auxiliary/scanner/mysql/mysql_schemadump                               normal     MYSQL Schema Dump
   auxiliary/scanner/mysql/mysql_version                                  normal     MySQL Server Version Enumeration
   auxiliary/scanner/mysql/mysql_writable_dirs                            normal     MYSQL Directory Write Test
   auxiliary/server/capture/mysql                                         normal     Authentication Capture: MySQL
   exploit/linux/mysql/mysql_yassl_getname               2010-01-25       good       MySQL yaSSL CertDecoder::GetName Buffer Overflow
   exploit/linux/mysql/mysql_yassl_hello                 2008-01-04       good       MySQL yaSSL SSL Hello Message Buffer Overflow
   exploit/multi/http/manage_engine_dc_pmp_sqli          2014-06-08       excellent  ManageEngine Desktop Central / Password Manager LinkViewFetchServlet.dat SQL Injection
   exploit/multi/http/zpanel_information_disclosure_rce  2014-01-30       excellent  Zpanel Remote Unauthenticated RCE
   exploit/multi/mysql/mysql_udf_payload                 2009-01-16       excellent  Oracle MySQL UDF Payload Execution
   exploit/unix/webapp/kimai_sqli                        2013-05-21       average    Kimai v0.9.2 'db_restore.php' SQL Injection
   exploit/unix/webapp/wp_google_document_embedder_exec  2013-01-03       normal     WordPress Plugin Google Document Embedder Arbitrary File Disclosure
   exploit/windows/mysql/mysql_mof                       2012-12-01       excellent  Oracle MySQL for Microsoft Windows MOF Execution
   exploit/windows/mysql/mysql_start_up                  2012-12-01       excellent  Oracle MySQL for Microsoft Windows FILE Privilege Abuse
   exploit/windows/mysql/mysql_yassl_hello               2008-01-04       average    MySQL yaSSL SSL Hello Message Buffer Overflow
   exploit/windows/mysql/scrutinizer_upload_exec         2012-07-27       excellent  Plixer Scrutinizer NetFlow and sFlow Analyzer 9 Default MySQL Credential
   post/linux/gather/enum_configs                                         normal     Linux Gather Configurations
   post/linux/gather/enum_users_history                                   normal     Linux Gather User History
   post/multi/manage/dbvis_add_db_admin                                   normal     Multi Manage DbVisualizer Add Db Admin

msf > info auxiliary/scanner/mysql/mysql_login

       Name: MySQL Login Utility
     Module: auxiliary/scanner/mysql/mysql_login
    License: Metasploit Framework License (BSD)
       Rank: Normal

Provided by:
  Bernardo Damele A. G. <bernardo.damele@gmail.com>

Basic options:
  Name              Current Setting  Required  Description
  ----              ---------------  --------  -----------
  BLANK_PASSWORDS   false            no        Try blank passwords for all users
  BRUTEFORCE_SPEED  5                yes       How fast to bruteforce, from 0 to 5
  DB_ALL_CREDS      false            no        Try each user/password couple stored in the current database
  DB_ALL_PASS       false            no        Add all passwords in the current database to the list
  DB_ALL_USERS      false            no        Add all users in the current database to the list
  PASSWORD                           no        A specific password to authenticate with
  PASS_FILE                          no        File containing passwords, one per line
  Proxies                            no        A proxy chain of format type:host:port[,type:host:port][...]
  RHOSTS                             yes       The target address range or CIDR identifier
  RPORT             3306             yes       The target port (TCP)
  STOP_ON_SUCCESS   false            yes       Stop guessing when a credential works for a host
  THREADS           1                yes       The number of concurrent threads
  USERNAME                           no        A specific username to authenticate as
  USERPASS_FILE                      no        File containing users and passwords separated by space, one pair per line
  USER_AS_PASS      false            no        Try the username as the password for all users
  USER_FILE                          no        File containing usernames, one per line
  VERBOSE           true             yes       Whether to print output for all attempts

Description:
  This module simply queries the MySQL instance for a specific 
  user/pass (default is root with blank).

References:
  https://cvedetails.com/cve/CVE-1999-0502/

msf > use auxiliary/scanner/mysql/mysql_login
msf auxiliary(scanner/mysql/mysql_login) > 


###########################################################

## Attacking a website:

# get info about website:

whois <website>
whois google.com

# get IP address:

host google.com

# scan victim's website ports:

nmap -F <IP>

# ssh open, right, then check its ssh version: use exploit tool for that

msf > info auxiliary/scanner/ssh/ssh_version

       Name: SSH Version Scanner
     Module: auxiliary/scanner/ssh/ssh_version
    License: Metasploit Framework License (BSD)
       Rank: Normal

Provided by:
  Daniel van Eeden <metasploit@myname.nl>

Basic options:
  Name     Current Setting  Required  Description
  ----     ---------------  --------  -----------
  RHOSTS                    yes       The target address range or CIDR identifier
  RPORT    22               yes       The target port (TCP)
  THREADS  1                yes       The number of concurrent threads
  TIMEOUT  30               yes       Timeout for the SSH probe

Description:
  Detect SSH Version.

References:
  http://en.wikipedia.org/wiki/SecureShell

msf > use auxiliary/scanner/ssh/ssh_version

msf auxiliary(scanner/ssh/ssh_version) > show options

Module options (auxiliary/scanner/ssh/ssh_version):

   Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   RHOSTS                    yes       The target address range or CIDR identifier
   RPORT    22               yes       The target port (TCP)
   THREADS  1                yes       The number of concurrent threads
   TIMEOUT  30               yes       Timeout for the SSH probe

msf auxiliary(scanner/ssh/ssh_version) > set RHOSTS 10.136.137.110
RHOSTS => 10.136.137.110
msf auxiliary(scanner/ssh/ssh_version) > show options

Module options (auxiliary/scanner/ssh/ssh_version):

   Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   RHOSTS   10.136.137.110   yes       The target address range or CIDR identifier
   RPORT    22               yes       The target port (TCP)
   THREADS  1                yes       The number of concurrent threads
   TIMEOUT  30               yes       Timeout for the SSH probe

# then if version is not updated, it may have some holes


#### Scenario: Scanning ports of a remote host:

msf auxiliary(scanner/portscan/tcp) > set RHOSTS 10.136.137.77
RHOSTS => 10.136.137.77
msf auxiliary(scanner/portscan/tcp) > run

[+] 10.136.137.77:        - 10.136.137.77:22 - TCP OPEN
[+] 10.136.137.77:        - 10.136.137.77:80 - TCP OPEN
[+] 10.136.137.77:        - 10.136.137.77:3283 - TCP OPEN
[+] 10.136.137.77:        - 10.136.137.77:5900 - TCP OPEN

# the same but using the hosts already imported in the DB (db_import) via xml file and -R running the exploit:
# msf > auxiliary(scanner/portscan/tcp) > hosts -R
# you can define just -c column address, or anything else, then -R run:
msf auxiliary(scanner/portscan/tcp) > hosts -c address -R

Hosts
=====

address
-------
10.136.137.1
10.136.137.25
10.136.137.39
10.136.137.72
10.136.137.74
10.136.137.75
10.136.137.77
10.136.137.82
10.136.137.86
10.136.137.103
10.136.137.122

RHOSTS => file:/tmp/msf-db-rhosts-20180615-21823-46n64u

msf auxiliary(scanner/portscan/tcp) > run # notice you are using command run as well !!!

[+] 10.136.137.25:        - 10.136.137.25:21 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:80 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:79 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:443 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:515 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:631 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:4000 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:5000 - TCP OPEN
[+] 10.136.137.25:        - 10.136.137.25:5001 - TCP OPEN
...
...

#### SERVICES: There is an option to scan services of remote hosts, with an internal command services
services <host>

# example:
msf > services 10.136.137.77
Services
========

host           port  proto  name  state  info
----           ----  -----  ----  -----  ----
10.136.137.77  22    tcp    ssh   open   

# same is applicable while using a exploit like portscan, which gives more knowledge:
msf auxiliary(scanner/portscan/tcp) > services 10.136.137.77
Services
========

host           port  proto  name  state  info
----           ----  -----  ----  -----  ----
10.136.137.77  22    tcp    ssh   open   
10.136.137.77  80    tcp          open   
10.136.137.77  3283  tcp          open   
10.136.137.77  5900  tcp          open

# for all hosts in DB:
msf > services
Services
========

host            port  proto  name  state     info
----            ----  -----  ----  -----     ----
10.136.137.1    22    tcp    ssh   closed    
10.136.137.25   22    tcp    ssh   closed    
10.136.137.39   22    tcp    ssh   closed    
10.136.137.72   22    tcp    ssh   closed    
10.136.137.74   22    tcp    ssh   closed    
10.136.137.75   22    tcp    ssh   closed    
10.136.137.77   22    tcp    ssh   open      
10.136.137.82   22    tcp    ssh   filtered  
10.136.137.86   22    tcp    ssh   closed    
10.136.137.103  22    tcp    ssh   closed    
10.136.137.120  8088  tcp    http  open      Apache-Coyote/1.1
10.136.137.122  22    tcp    ssh   open 

# only ssh --> use -S filter:
msf > services -S ssh

# Exporting to a CSV file: -o output
msf > services -S ssh -o /root/msfu/ssh_report_hosts.csv

####################################### TIPS, KNOW ERRORS & SOLUTIONS

## Scenario 1: I had metasploit working, after an update, cannot start postgresql.service
# * If starting the daemon gives an error that data is empty, then initdb must be executed first:
service postgresql initdb
# Now try to start the daemon:
systemctl start postgresql.service
# Now try to init the db:
# /opt/metasploit-framework/bin
[ip14aai@02DI20161235444 bin]$ ./msfdb init
Found a database at /home/ip14aai/.msf4/db, checking to see if it is started
Starting database at /home/ip14aai/.msf4/db...success

