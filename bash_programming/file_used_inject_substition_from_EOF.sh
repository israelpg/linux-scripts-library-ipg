#!/bin/bash

cat > secureRM.txt <<EOF
<properties>
	<hudson.security.AuthorizationMatrixProperty>
      <inheritanceStrategy class="org.jenkinsci.plugins.matrixauth.inheritance.NonInheritingStrategy"/>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Create:DL999_IT-LIM-LINUX</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Create:GG500_Jenkins-Team-RM</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Delete:DL999_IT-LIM-LINUX</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Delete:GG500_Jenkins-Team-RM</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains:DL999_IT-LIM-LINUX</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains:GG500_Jenkins-Team-RM</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Update:DL999_IT-LIM-LINUX</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Update:GG500_Jenkins-Team-RM</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.View:DL999_IT-LIM-LINUX</permission>
      <permission>com.cloudbees.plugins.credentials.CredentialsProvider.View:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Build:authenticated</permission>
      <permission>hudson.model.Item.Build:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Build:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Cancel:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Cancel:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Configure:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Configure:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Delete:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Delete:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Discover:anonymous</permission>
      <permission>hudson.model.Item.Discover:authenticated</permission>
      <permission>hudson.model.Item.Discover:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Discover:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Move:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Move:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Read:authenticated</permission>
      <permission>hudson.model.Item.Read:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Read:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Release:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Release:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Item.Workspace:authenticated</permission>
      <permission>hudson.model.Item.Workspace:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Item.Workspace:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Run.Delete:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Run.Delete:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Run.Replay:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Run.Replay:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.model.Run.Update:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.model.Run.Update:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.plugins.release.ReleaseWrapper.Release:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.plugins.release.ReleaseWrapper.Release:GG500_Jenkins-Team-RM</permission>
      <permission>hudson.scm.SCM.Tag:DL999_IT-LIM-LINUX</permission>
      <permission>hudson.scm.SCM.Tag:GG500_Jenkins-Team-RM</permission>
    </hudson.security.AuthorizationMatrixProperty>
EOF

while read job
do
	# delete security matrix if exists
	sed -i '/<hudson.security.AuthorizationMatrixProperty/,/<\/hudson.security.AuthorizationMatrixProperty>/d' \
	/opt/jenkins/jobs/${job}/config.xml
	# add security matrix with permissions non-inherited with RM all and Discover for rest of users
	sed -i 's/<properties>/cat secureRM.txt/e' /opt/jenkins/jobs/${job}/config.xml
done< <(ls /opt/jenkins/jobs/ | egrep -i 'REF|PROD')



