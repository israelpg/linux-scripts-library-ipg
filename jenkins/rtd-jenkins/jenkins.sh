#!/bin/bash

usage()
{
    echo "Usage: $0 {start|stop|restart}"
    exit 1
}

ACTION=$1

case "$ACTION" in
	start)
		echo "Starting Jenkins"
		nohup java -Djava.io.tmpdir=/ec/local/data/temp -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath="/ec/local/data/jenkins-data/heapdump/" -jar /ec/local/sw/jenkins/jenkins.war --httpPort=8080 >/ec/local/data/log/jenkins/jenkins.log 2>&1 &
		;;
	
	stop)
		echo "Shutting down Jenkins"
		ps -ef|grep "[j]enkins.war"|awk '{print $2}'| xargs kill
		;;
	
	restart)
		$0 stop 
		sleep 5
		$0 start
		;;

	*)
		usage
		;;
esac

