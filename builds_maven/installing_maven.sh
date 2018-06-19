# Source: www.vultr.com/docs/how-to-install-apache-maven-on-ubuntu-16-04

# 1/ Make sure JDK is installed:

java -version

# otherwise install:

sudo apt-get install default-jdk

# set JAVA_HOME env variable

which java
# probable output: /usr/bin/java (this is a link pointing to installation point for java)
readlink -f /usr/bin/java    # result path where jdk is installed ...
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64/jre/bin/java

JAVA_HOME=<path_installation>
# example:
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64/jre

# export PATH:
export PATH=$PATH:$JAVA_HOME/bin/

# then we setup M2 env variables: see manual

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
# or:
mvn --version

##########################################################

# Structure:
# Each component/module has its own folder with a pom.xml in it
# These folders can have a parent folder, therefore a parent pom.xml as well
# The main folder (containing all modules folders) has a pom.xml with parent super
#

# Super POM: Default POM configuration

mvn help:effective-pom
