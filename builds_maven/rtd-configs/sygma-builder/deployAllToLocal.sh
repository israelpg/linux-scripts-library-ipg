#!/bin/bash

mvn install -DskipTests -U -T 3
mvn -pl eu.europa.ec.rdg.sygma:sygma-application weblogic:deploy -Denv=local
#mvn -pl eu.europa.ec.rdg.sygma:sygma-it-plumber-ear weblogic:deploy -Denv=local
