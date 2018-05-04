#!/bin/bash

## user: some grants are required, individually or by using a role which can be assigned to several users
## profile: similar to role, with the following characteristics to be assigned: spool space, permspace, account strings ...

# These commands below are suitable in SQL Plus Command Line:

# creating a user:

CREATE USER username IDENTIFIED BY password;

# creating a user with extended options: (Note: Role cannot be assigned, a GRANT statement is used instead
CREATE USER jward
    IDENTIFIED BY AZ7BC2
    DEFAULT TABLESPACE data_ts
    QUOTA 100M ON test_ts
    QUOTA 500K ON data_ts
    TEMPORARY TABLESPACE temp_ts
    PROFILE clerk;

# GRANT basic connection feature to username:
GRANT CREATE SESSION TO jward;

# Alter a user already created:
ALTER USER avyrros
    IDENTIFIED EXTERNALLY
    DEFAULT TABLESPACE data_ts
    TEMPORARY TABLESPACE temp_ts
    QUOTA 100M ON data_ts
    QUOTA 0 ON test_ts
    PROFILE clerk;

# Removing a user: DROP
DROP USER username CASCADE;

# CREATE A PROFILE:
CREATE PROFILE enduser LIMIT
CPU_PER_SESSION			60000
LOGICAL_READS_PER_SESSION	1000
CONNECT_TIME			30
PRIVATE_SGA			102400
CPU_PER_CAL			UNLIMITED
COMPOSITE_LIMIT			60000000
FAILED_LOGIN_ATTEMPTS		3
PASSWORD_LIFE_TIME		90
PASSWORD_REUSE TIME		180
PASSWORD_LOCK_TIME		3
PASSWORD_GRACE_TIME		3
Verify_function_one ;
## assign profile to an existing user: ALTER USER <username> PROFILE <username>;

# GRANT:
GRANT CONNECT TO isaac14;
GRANT UNLIMITED TABLESPACE TO isaac14;
# several grants in one line:
GRANT CONNECT, RESOURCE, DBA TO isaac14;
# or to a role:
GRANT CONNECT, RESOURCE, DBA TO <roleName>;

# Create a new DB role (Preferred Option!!!), and granting permissions to the role:
CREATE ROLE my_app_developer;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE SYNONYM, CREATE CLUSTER, CREATE DATABASE LINK, ALTER SESSION TO my_app_developer;
# and finally assigning role with its privileges to a username:
GRANT my_app_developer to <username>;

# Assign grants to user, but also this same user can grant permissions to other users:
GRANT ALL PRIVILEGES ON db.* TO <username> WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON db.table TO <username> WITH GRANT OPTION;

# Privileges in terms of DML within a database or database.table:
GRANT
	SELECT,
	INSERT,
	UPDATE,
	DELETE
ON
	schemaDB.booksTable
TO
	isaac14;

# REVOKE:
REVOKE ALL ON db.table FROM username;


### DATA DICTIONARY VIEWS: CHECKING DATABASE INFORMATION

DBA_USERS
Information about username, profile and account_status
# sql:
SQL>    SELECT USERNAME, PROFILE, ACCOUNT_STATUS FROM DBA_USERS;

USERNAME        PROFILE         ACCOUNT_STATUS
----------------------------------------------------
SYS             DEFAULT         OPEN
SYSTEM          DEFAULT         OPEN
ISRAEL          DEVELOPER       OPEN
#

ALL_USERS	
Lists users visible to the current user, but does not describe them

USER_USERS	
Describes only the current user

DBA_SYS_PRIVS (use: USER_SYS_PRIVS for current user)
Info about system privileges to users, roles

DBA_ROLE_PRIVS
Info about role privileges

DBA_PROFILES
Displays all profiles and their limits

DBA_TS_QUOTAS
USER_TS_QUOTAS
Describes tablespace quotas for users

DBA_TAB_PRIVS
Info about tables privileges

USER_PASSWORD_LIMITS	
Describes the password profile parameters that are assigned to the user

USER_RESOURCE_LIMITS	
Displays the resource limits for the current user

RESOURCE_COST	
Lists the cost for each resource

V$SESSION	
Lists session information for each current session, includes user name

V$SESSTAT	
Lists user session statistics

V$STATNAME	
Displays decoded statistic names for the statistics shown in the V$SESSTAT view

PROXY_USERS	Describes users who can assume the identity of other users

### Examples:

# 1. Checking system privileges granted to all users:
SQL>	SELECT *
	FROM
	DBA_SYS_PRIVS;
# output: 
# GRANTEE:name, role, or user that was assigned the privilege
# PRIVILEGE: privilege assigned --> SELECT, CREATE ...
# ADMIN_OPTION: Whether the ADMIN option is granted or not

# 2. Privileges in tables:
SQL>	SELECT *
	FROM
	DBA_TAB_PRIVS;
# output: GRANTEE, TABLE_NAME, PRIVILEGE

# 3. We are querying what users have the role "CONNECT" assigned, and then add a new role:

SQL> 	SELECT user$.name, admin_option, default_role
	FROM user$, sysauth$, dba_role_privs
	WHERE privilege# =
	(SELECT user# from user$ WHERE name = 'CONNECT')
	AND user$.user# = grantee#
	AND grantee = user$.name
	AND granted_role = 'CONNECT';

# output:
NAME	ADMIN_OPTI	DEF
---------------------------
R1	YES		YES
R2	NO		YES

# then you add the new role to these users, R1 with ADMIN option:
SQL> GRANT my_app_developer TO R1 WITH ADMIN OPTION;
# The other one regular without admin option:
SQL> GRANT my_app_developer TO R2;

## Important to reflect changes with new roles, privileges, by auditing:
SQL> AUDIT CREATE TABLE, CREATE SEQUENCE, CREATE SYNONYM, CREATE DATABASE LINK, CREATE CLUSTER, CREATE VIEW, ALTER SESSION;

## Then we can check these prileges:
SQL> 	SELECT userid, name FROM aud$, system_privileges_map
	WHERE - priv$used = privilege;
# output:
USERID		NAME
-------------------------------
ACME		CREATE TABLE
ACME		CREATE SEQUENCE
ACME		ALTER SESSION
APPS		CREATE TABLE
...

###########################################################################


