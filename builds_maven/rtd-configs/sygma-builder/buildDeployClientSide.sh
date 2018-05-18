#!/bin/bash


mvn -f "../vaadin-custom-addons-v6/pom.xml" clean install -DskipTests -T 3 -U
mvn -f "../sygma-thirdparty/pom.xml" clean install -DskipTests -T 3 -U
cp ../sygma-thirdparty/target/sygma-thirdparty-2.1-SNAPSHOT.jar ~/weblogic/sygma/common_lib/

