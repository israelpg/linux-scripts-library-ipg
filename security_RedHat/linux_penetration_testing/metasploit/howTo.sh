#!/bin/bash

# Installation:
# msfinstall script needs to be executed
./msfinstall

# execute console, use a non-root user (id -u ! 0):
./msfconsole

# First time, start db, it setups the environment for you:
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

# displaying all exploits available:
show exploits

# search something in particular:
search mysql

# show details for a particular exploit:

info <exploit_info>

# use exploit:

use <exploit>

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
