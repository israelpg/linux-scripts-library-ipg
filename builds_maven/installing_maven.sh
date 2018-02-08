# Source: www.vultr.com/docs/how-to-install-apache-maven-on-ubuntu-16-04

# 1/ Make sure JDK is installed:

java -version

# otherwise install:

sudo apt-get install default-jdk

# set JAVA_HOME env variable

which java
# probable output: /usr/bin/java
readlink -f /usr/bin/java # result path where jdk is installed ...

JAVA_HOME=<path_installation>

###### INSTALLING MAVEN ########

cd ~/Downloads

wget http://www-eu.apache.org <bla bla bla>.tar.gz # ... check last version

sudo tar -xzvf <downloaded_installation>.tar.gz -C /opt/

mv <installation_folder> maven

# setup maven env variables

sudo nano -c /etc/profile.d/mavenenv.sh
# check file attached

# verify installation: 

mvn -V



