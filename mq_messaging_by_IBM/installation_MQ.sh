#!/bin/bash

download rpm package + mqlicense.sh file

# accepting the license:

./mqlicense -accept

# now installing the rpm packages: (*** to be changed with version - real filename):

rpm -ivh MQSeriesRuntime***.rpm MQSeriesServer***.rpm MQSeriesSamples***.rpm

# editing passwd for mqm user:

sudo passwd mqm

# switching to user mqm: - (does not have home folder)

su - mqm

# cd to mqm installation dir:

cd /opt/mqm/bin/

# version:

./dspmqver

# complete setup by creating a queue manager: ./crtmqm <queueManager_name>

./crtmqm TESTMGR1

# start MQM:

./strmqm TESTMGR1

# checking processes:

ps -ef | grep 'mqm'

##### Accessing MQM for queue management: (then we can type mqm commands):

./runmqsc TESTMGR1

# display details:

display

# display local queues available:

display qlocal(*)

# create a local queue:

DEFINE QLOCAL(q1local)

# create a listener with the IP of our server where MQM is running:

DEFINE LISTENER(TESTMGR1.LISTENER) TRPTYPE (TCP) PORT(1414) ipaddr(x.x.x.x)

display listener(*)

# start listener just created:

start LISTENER(TESTMGR1.LISTENER)

# define a channel is optional, since the system already created one for us:

DEFINE CHANNEL(SYSTEM.ADMIN.SVRCONN) CHLTYPE(SVRCONN) TRPTYPE(TCP) DESCR('WMQ Default Channel') REPLACE

display CHANNEL(SYSTEM.ADMIN.SVRCONN)

# sending a sample message: Selecting queue:

./amqsput Q1LOCAL TESTMGR1

# getting a sample message:

./amqsget Q1LOCAL TESTMGR1

##### CONNECTING WEBSPHERE WITH MQM:

# Webpshere console:

JMS --> Queue connection factories

# Select scope: Best is to select the Cell level, as its the major logical unit, composed of all nodes, servers ...

Scope: <cells:localhost_********>

`Tick` --> WebSphere MQ messaging provider

#Configure basic attributes: Name: wmq_qcf_1, JNDI name: jms/wmq_qcf_1
# Enter details:
Type queue manager: TESTMGR1
# this info can be obtained via:
display qmgr

# details of server defined when defining the listener:
Hostname: IP of our machine
+
Port

Server Connection Channel: SYSTEM.ADMIN.SVRCONN
# This comes from:
display channel(*)
SYSTEM.ADMIN.SVRCONN

# if testing connectivity gives an error, disable the CHLAUTH for the QMGR via mqm command line:

alter qmgr CHLAUTH(DISABLED)

# giving permission:

setmqaut -m TESTMGR1 -t qmgr -g mqm +all

# add root user to group mqm
usermod -a -G mqm root
# or:
gpasswd -a root mqm






 
