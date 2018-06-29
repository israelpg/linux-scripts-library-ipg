#!/bin/bash
export J6_HOME=/ec/sw/sygma/java/64/jdk1.6.0_31
export JAVA_HOME=/ec/sw/sygma/java/64/jdk1.7.0_45
export M2_HOME=/ec/sw/sygma/maven/apache-maven-3.0.5-dev
export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH
exec $J6_HOME/bin/java -Djava.io.tmpdir=/ec/prod/app/sygma/temp -XX:MaxPermSize=512M -jar /ec/sw/sygma/jenkins/apache-tomcat-7.0.50/webapps/jenkins/WEB-INF/slave.jar
