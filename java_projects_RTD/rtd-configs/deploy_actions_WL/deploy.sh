#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, you should provide the target environment"
    echo "example: deploy int"
    exit 1
fi

TARGET_ENV=$1
shift

echo "Deploying to ${TARGET_ENV}"

if [ $TARGET_ENV != "local" ]
then
	echo "Stopping Weblogic and undeploying"
	mvn -f wl-stop-undeploy-pom.xml weblogic:wlst $1 $*
fi

echo "Deploying application"
mvn -pl eu.europa.ec.rdg.eris:eris-ear weblogic:deploy $1 $*

if [ $TARGET_ENV != "local" ]
then
	echo "Starting Weblogic"
	mvn -f wl-start-pom.xml weblogic:wlst $1 $*
fi
