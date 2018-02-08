#!/bin/bash

# might be that you need to import a package in your Java source, then you will need to add this dependency also in your pom.xml
# so that necessary files and libraries are downloaded from the Internet Repository

# example, java code:

import org.slf4j.*;

# then if you compile there is an error of missing dependency ... add it in your pom.xml

# check for info on site:

http://mvnrepository.com/artifact

# you will get details of this dependency: groupId, artifactId, version .... same as you initially have for junit

<dependency> ...


</dependency>

# DO NOT PUT SCOPE!!!!!!!!!!!!!!!!!!!!!!!
