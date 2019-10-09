[root@s298li2iib03 ~]# su - mqm
Last login: Mon Sep 30 10:30:03 CEST 2019

MQSI 10.0.0.17
/opt/iib10/server

[mqm@s298li2iib03 ~]$ crontab -l

#FVD
#45 * * * * /opt/HA/scripts/listIIBApps.sh &>/dev/null

[mqm@s298li2iib03 ~]$ cat /opt/HA/scripts/listIIBApps.sh
#!/bin/bash

# MUST BE DEPLOYED ON IIB SERVERS
# parameters
workDir=/data/scripts
mqsibin=/opt/iib10/server/bin
destinationServer=s598li2wseb01.integ.gfdi.be
destinationDir=/data/scripts
# PATH env variable
PATH=/opt/iib10/common/jre/bin:/var/mqsi/extensions/10.0.0/server/bin:/var/mqsi/extensions/10.0.0/bin:/opt/iib10/server/bin/mosquitto:/opt/iib10/server/bin:/opt/iib10/server/isadc:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/mqm/.local/bin:/home/mqm/bin:/opt/mqm/bin:/opt/iib10/server/bin

. $mqsibin/mqsiprofile

if [[ ${PWD} != ${workDir} ]]; then
	cd /opt/HA/scripts
fi

listQM=`dspmq |sed 's/QMNAME.//' |sed 's/).*//'`
listBroker=`echo $listQM |sed 's/QM/IIB/g'`

rm -f *.lst *.temp

for i in $listBroker; do
    $mqsibin//mqsilist -r -d2 $i  > $i.temp
    cat $i.temp |grep .bar |sed 's/.*\///'|sort |uniq > $i.lst
done