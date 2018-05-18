#!/bin/bash

#create an archetype project (is a basic project that you get from maven, with just Hello World statement

mvn archetype:generate -DgroupId=com.ip14aai.app -DartifactId=my-app -DarchetypeArtifactId=mave-archetype-quickstart -DinteractiveMode=false

# NORMALLY do it like this:
mvn archetype:generate
# and choose a number of archetype / type of project/structure model

# then you can compile:

mvn compile

# example: project is date2408v1, with initial code, and pom.xml which handles the mvn build:

pom.xml
src

# then mvn compile within folder ~/.m2/repository/date2408v1/

pom.xml
src/
target/ # here the result of compiling, with the classes, and maven files with status in folder maven-status

# unit test, run again in main folder for your repository/project
mvn test

# folders in target are now:
classes, maven-status
surefire-reports
test-classes

# then you package the sources (.jar):

mvn package

# .jar file (jar was specified as packaging option in the pom.xml), is in the main repository/project folder
# example:
date2408v1-1.0-SNAPSHOT.jar
# plus folder:
maven-archiver # and file in it:
pom.properties # acting as log

#####
##### in /src/main/ fror this project, you have the classes, and code in general
##### once compiled, and tested ... everything else is in target ... tests, compressed packages, etc ...

# then you install, meaning it is deployed in your local repository (local machine):

mvn install

# To run application, go to your project's folder, not the repository, just the projects folder, and run:

java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app App

################# SOURCE: https://maven.apache.org/guides/getting-started/index.html

# going backwards ... step before compiling ... so that you only have sources, but not classes after compiling:

mvn clean
