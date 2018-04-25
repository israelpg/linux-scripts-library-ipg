#!/bin/bash

# installing and configuring tomcat in CentOS:

# Note: In CentOS 7 Tomcat is installed by default:
[ip14aai@02DI20161235444 tests]$ rpm -qa tomcat
tomcat-7.0.76-3.el7_4.noarch

$ rpm -qi tomcat-7.0.76-3.el7_4.noarch
Architecture: noarch
Install Date: Thu 05 Apr 2018 17:44:49 CEST
Group       : System Environment/Daemons
Size        : 310296
License     : ASL 2.0
Signature   : RSA/SHA256, Mon 30 Oct 2017 12:20:49 CET, Key ID 24c6a8a7f4a80eb5
Source RPM  : tomcat-7.0.76-3.el7_4.src.rpm
Build Date  : Mon 30 Oct 2017 11:23:17 CET
Build Host  : c1bm.rdu2.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://tomcat.apache.org/
Summary     : Apache Servlet/JSP Engine, RI for Servlet 3.0/JSP 2.2 API
Description :
Tomcat is the servlet container that is used in the official Reference
Implementation for the Java Servlet and JavaServer Pages technologies.
The Java Servlet and JavaServer Pages specifications are developed by
Sun under the Java Community Process.

Tomcat is developed in an open and participatory environment and
released under the Apache Software License version 2.0. Tomcat is intended
to be a collaboration of the best-of-breed developers from around the world.


● tomcat.service - Apache Tomcat Web Application Container
   Loaded: loaded (/usr/lib/systemd/system/tomcat.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2018-04-24 17:08:39 CEST; 18h ago
 Main PID: 4127 (java)
   CGroup: /system.slice/tomcat.service
           └─4127 /usr/lib/jvm/jre/bin/java -classpath /usr/share/tomcat/bin/bootstrap.jar:/usr/share/tomcat/bin/tomcat-juli.jar:/usr/share/java/commons-daemon.jar -Dcatalina.base=/usr/share/tomcat -Dcatalina.home=/usr/share/tomcat -Djava.endorsed.dirs= -Djava.io.tmpdir=/var/cache/tomcat/temp -Djava.util.logging.config.file=/usr/share/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager org.apache.catalina.startup.Bootstrap start

# service details can be modified then in file: /usr/lib/systemd/system/tomcat.service

# accessing tomcat via browser, localhost using port 8080
# port number can be modified in server.xml file under folder:
/etc/tomcat/server.xml
Define a non-SSL HTTP/1.1 Connector on port 8080
    -->
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
    <!-- A "Connector" using the shared thread pool-->
    <!--
    <Connector executor="tomcatThreadPool"
               port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />

# users management:
/etc/tomcat/tomcat-users.xml
# define these lines:
<tomcat-users>
	<user username="admin" password="passwordliteral" roles="manager-gui,admin-gui"/>
</tomcat-users>

# accessing the web interface with manager: For deploying apps, starting/stopping them, monitoring ...
http://serverIP:8080/manager/html/

# host manager: to add new hosts, to serve your applications from:
http://serverIP:8080/host-manager/html/

## NOTE: Tomcat is restricted to be managed only from the server machine itself (localhost)
# In case is needed to access remotely for managing the server, modify this file:
/etc/tomcat/context.xml

<Context antiResourceLocking="false" privileged="true" >
	<Valve className="org.apache.catalina.valves.RemoteAddrValve"
		allow="192\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
</Context>

### VIRTUALHOSTS:
# default virtualhost defined for localhost in server.xml:
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
</Host>
# adding a new virtualhost in server.xml: appBase is the server folder where the web documents are stored
<Host name="ip14aai-web1"  appBase="ip14aai-web1-docs"
            unpackWARs="true" autoDeploy="true">
</Host>

### ARCHITECTURE:
#
/usr/share/pki/server/webapps/ROOT
# jar files under folder:
/WEB-INF/lib/
# java classes:
/WEB-INF/classes

### DEPLOYING AND APP:
# several ways to deploy
# 1/ Deploy a Directory or War file from the Host appBase defined in virtualhost (server.xml)
# for instance: war file: bar.war ... Context Path is appBase: /bartoo
#
# 2/ Deploy using a Context configuration "*.xml" file: 
# see doc here --> https://tomcat.apache.org/tomcat-7.0-doc/html-manager-howto.html
# 
# 3/ Upload a War file to install: Easy
# note: if filename already exists, first it will need to be undeployed



