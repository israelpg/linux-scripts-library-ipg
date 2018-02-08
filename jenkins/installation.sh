# wget to download the jenkins keys, -O output to - (std input), which then is used to add apt-key:

sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -

# Then add the following entry in your /etc/apt/sources.list:

deb https://pkg.jenkins.io/debian-stable binary/

# Update your local package index, then finally install Jenkins:

sudo apt-get update
sudo apt-get install jenkins

# Run Jenkins: locate jenkins.war (normally: /usr/share/jenkins: Is a java app: java -jar

java -jar jenkins.war

# In case of error, probably is due to the http port: then run jenkins with a port other than 8080:

java -jar --httpPort=5225

# Accessing Jenkins:

http://localhost:8080

# Dashboard:
# Indicates jenkins main folder where build workspaces are stored, as well as build records:
# /var/lib/jenkins

# config in: /etc/sysconfig/jenkins

/etc/default/jenkins # possible to change JENKINS_HOME, port, and so on


