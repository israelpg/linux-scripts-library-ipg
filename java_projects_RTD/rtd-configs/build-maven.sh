#!/bin/bash
# Maven Arguments in shell script are passed by RTC build requested: RTC Build Properties --> Maven arguments
# Example: (in RTC build property as default: runSonar / false), in build definition: -s ${runSonar}
# Argument = -m mode -s sonar -d fetchDestination -w workspaceUUID -b buildresultUUID -p personalBuild -j javaEnvironment -r stagingRepoName -e skipErrors -t threads

# instructions about arguments when calling this script:
usage()
{
cat << EOF
usage: $0 options

This script runs a Maven compatible build for a RTC build request.

OPTIONS:
 -h Show this message
 -m Build mode, can be 'dev', 'staging' or 'release', defaults to 'dev'
 -s Sonar report can be 'true' or 'false', defaults to 'true'
 -B sonar extra options, can be left blank; example: -Dsonar.branch=BRANCH1
 -d Fetch Destination, directory path where the build should start
 -w RTC workspace UUID, the UUID from the RTC workspace being used for this build
 -b RTC Build Result UUID, the UUID of the build result where to feedback results and actions
 -p Personal Build, can be 'true' or 'false', defaults to 'false'
 -a Maven Parameters, any maven parameter needed for the build
 -j Java environment to build the project, can be '6' or '7', defaults to '7'
 -r Staging repo base name (will be completed with a prefix and a version)
 -o nosources, excludes sources from the build (used in case of MBeanMaker)
 -e skipErrors, should errors be skipped or not (to be used wisely, defaults to false)
 -t number of parallel threads to use during the build (defaults to 1)
 -z prefix path environment variable with the specified value leaving the rest as it is
EOF
}

# Keep location where script started in a variable
export BASEDIR=$(dirname $0) # var with dir name for the script=$0 itself
export MY_LOC="`pwd`"

# Parse passed options
MODE=dev
SONAR=true
FD=
WUUID=
BRUUID=
PERS=false
MAVEN_PARAMS=
JAVAVERS=8
STAGE_REPO_NAME=
BUILD_OPTIONS=
SKIP_ERRORS=false
SONAR_EXTRA_OPTS=
THREADS=1
ANGULAR=angular2
COBERTURA=true

# checking arguments passed when calling the script-$0 ... eg: -s <value> --> SONAR=$OPTARG (meaning that $OPTARG is the value passed as <script-$0> -s <value>
while getopts "h:m:s:B:d:w:b:p:a:j:r:o:e:t:z:c:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		m)
			MODE=$OPTARG
			;;
		s)
			SONAR=$OPTARG
			;;
		B)
			SONAR_EXTRA_OPTS=$OPTARG
			;;
		d)
			FD=$OPTARG
			;;
		w)
			WUUID=$OPTARG
			;;
		b)
			BRUUID=$OPTARG
			;;
		p)
			PERS=$OPTARG
			;;
		a)
			MAVEN_PARAMS=$OPTARG
			;;
		j)
			JAVAVERS=$OPTARG
			;;
		r)
			STAGE_REPO_NAME=$OPTARG
			;;
		o)
			BUILD_OPTIONS=$OPTARG
			;;
		e)
			SKIP_ERRORS=$OPTARG
			;;
		t)
			THREADS=$OPTARG
			;;
		z)
			ANGULAR=$OPTARG
			;;
		c)
			COBERTURA=$OPTARG
			;;
	esac
done

# exit 1 in case that fetch destination folder (source code) is not specified, or unexisting workspace UUID,
# or build request UUID does not exist 
# BRUUID seems to be auto-defined when launching build, RTC name: buildResultUUID, passed: -b ${buildResultUUID}
if [[ -z $FD ]] || [[ -z $WUUID ]] || [[ -z $BRUUID ]]
then
	usage
	exit 1
fi

if [ "$BUILD_OPTIONS" == "nosources" ]; then
	echo "EXCLUDING source generation"
	export GOALS="clean -Dmaxmemory=1g deploy"
else # default option, nothing is excluded, no -o argument passed when requesting build
	echo "EXCLUDING nothing"
	export GOALS="clean org.apache.maven.plugins:maven-javadoc-plugin:2.9.1:jar source:jar -Dmaxmemory=1g deploy"
fi

# this comes from build definition (RTC), when build is requested, some stuff like ANGULAR has default value
echo starting build with parameters MODE=$MODE, SONAR=$SONAR, FD=$FD, WUUID=$WUUID, BRUUID=$BRUUID, PERS=$PERS, MAVEN_PARAMS=$MAVEN_PARAMS, JAVAVERS=$JAVAVERS, ANGULAR=$ANGULAR

# Other environment variables with Maven arguments, eg: -Dmagen.repo.local=$localRepo --> mvn repo with code, libs, that might be used during a build (summary: it adds functionalities)
export MAVEN_OPTS="-Xmx6g -XX:MaxDirectMemorySize=1024m -Dmaven.test.failure.ignore=true -Duser.language=en -Dmaven.artifact.threads=3 -Dmaven.repo.local=$localRepo -XX:-DoEscapeAnalysis -Dcookie-secure=true"
# environment variables in PATH, for Java, Oracle, JS ...
export PATH=$NEWPATH:$JAVA_HOME/bin:$M2_HOME/bin:$ORACLE_HOME/bin:$NODE_JS_HOME/bin:$PATH
# local repository for maven plugins:
export PLUGIN_GROUPID=eu.europa.ec.rdg.maven.plugin
export PLUGIN_VERSION=2.20

# Java and WebLogic environment
case "$JAVAVERS" in
	6)
		export JAVA_HOME=/ec/local/java/64/jdk1.6.0_31
		export MW_HOME=/ec/local/sw/weblogic/wl12.1.1
		export M2_HOME_ROOT=/ec/local/sw/maven/apache-maven-3.3.9
		export MAVEN_OPTS="$MAVEN_OPTS -XX:MaxPermSize=512m"
		;;
        7)
                export JAVA_HOME=/ec/local/sw/java/64/jdk1.7.0_91
                export MW_HOME=/ec/local/sw/weblogic/wl12.1.1
                export M2_HOME_ROOT=/ec/local/sw/maven/apache-maven-3.3.9
                export MAVEN_OPTS="$MAVEN_OPTS -XX:MaxPermSize=512m"
                ;;
	*)
        	export JAVA_HOME=/ec/local/sw/java/64/jdk1.8.0_144
        	export MW_HOME=/ec/local/sw/weblogic/wl12.1.2
		export M2_HOME_ROOT=/ec/local/sw/maven/apache-maven-3.3.9
		export MAVEN_OPTS="$MAVEN_OPTS -XX:MaxMetaspaceSize=1024m"
		;;
esac
JAVA=$JAVA_HOME/bin/java # this means that we can call Java command like: $JAVA (eg: $JAVA -version)

# Angular configuration (default is Angular2)
export NODE_LIBS=/ec/local/data/nodejs
case "$ANGULAR" in
	angular)
		export NODE_JS_HOME=ec/local/sw/nodejs/node-v6.11.2-linux-x64
		export NG_HOME=/ec/local/data/nodejs/lib/node_modules/angular-cli
		alias ng='$NG_HOME/bin/ng'
		export PATH=$NG_HOME/bin:$NODE_JS_HOME:$PATH
		;;
	*) # this is angular2, default:
		export NODE_JS_HOME=ec/local/sw/nodejs/node-v6.11.2-linux-x64
		export NG_HOME=/ec/local/data/nodejs/lib/node_modules/@angular
		alias ng='$NG_HOME/cli/bin/ng'
		export PATH=$NG_HOME/cli/bin:$NODE_JS_HOME/bin:$PATH
		;;
esac

# Choose maven configuration
case "$MODE" in
	dev)
		export M2_HOME=$M2_HOME_ROOT-dev
		export EXTRA_REPO="-Drepository=rdg"
		export RTC_PROPS=/ec/local/sw/rtc-buildengine/config-dev1/config.properties
		export KEY_FILE=/ec/local/sw//rtc-buildengine/config-dev1/keyFile
		;;
	staging) # RM - staging: RTD Nexus (default value for RM builds)
		export M2_HOME=$M2_HOME_ROOT-rm
		export EXTRA_REPO="-Drepository=staging"
		# rm1, rm2 --> release management build engines (fetching their properties, keyFile)
		export RTC_PROPS=/ec/local/sw/rtc-buildengine/config-rm1/config.properties
		export KEY_FILE=/ec/local/sw/rtc-buildengine/config-rm1/keyFile
		# arg -d : dir where the build should start/source code:
		# g: jagate --> /ec/local/data/build-workspaces/rm/jagate-core
		cd $FD 
		# finding all pom.xml files in source, and replace/sed SNAPSHOT for nothing
		find . -name 'pom.xml' -exec sed -i 's/-SNAPSHOT//g' {} \;
		# this also works: find . -type f -iname 'pom.xml' | xargs -I {} sed -i 's/-SNAPSHOT//g' {}
		cd $MY_LOC
		;;
	release) # Final Build: Pushing to Digit's Nexus
		export M2_HOME=$M2_HOME_ROOT-rm
		export EXTRA_REPO="-Drepository=rdg"
		export RTC_PROPS=/ec/local/sw/rtc-buildengine/config-rm1/config.properties
		export KEY_FILE=/ec/local/sw/rtc-buildengine/config-rm1/keyFile
		;;
	*)
		usage
		exit 1
		;;
esac
export MAVEN_OPTS="$M2_OPTS -Dmode=$MODE -DconfigFile=$RTC_PROPS -DsecretKeyFile=$KEY_FILE -Dteam.scm.fetchDestination=$FD -Dteam.scm.workspaceUUID=$WUUID -DbuildResultUUID=$BRUUID -Djava.io.tmpdir=/ec/local/data/temp $MAVEN_OPTS"
export MAVEN_EXTRA_OPTS="-B" # mvn real argument: batch processing
echo Building with following maven options: $MAVEN_OPTS
MVN="$M2_HOME/bin/mvn $MAVEN_PARAMS $EXTRA_REPO" # $MVN will call the binary for maven with arguments, repo:staging
MVN_SINGLE="$M2_HOME/bin/mvn $MAVEN_PARAMS"

$JAVA -version
$MVN -version
echo PATH=$PATH

echo Cleaning local repo for /eu/europa/ec
rm -Rf $localRepo/eu/europa/ec

if [ "$MODE" == "release" ]; then
	$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Setting build result's label" $MAVEN_EXTRA_OPTS
	$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildLabel $MAVEN_EXTRA_OPTS
        if [ $? != 0 ]; then
                exit 1
        fi

        $MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Promoting staging version to release version" $MAVEN_EXTRA_OPTS
        $MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:deploy -DperformRelease=true -Dmaven.test.skip=true $MAVEN_EXTRA_OPTS
        if [ $? != 0 ]; then
                exit 1
        fi

        $MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Moving staging directory" $MAVEN_EXTRA_OPTS
        _dir=${PWD}
        echo Moving staging from $_dir to $_dir.old
        mv $_dir $_dir.old
	exit 0
fi

# Launching first MVN command passing args previously defined (j8, angular2, staging mode ...) !!!!!!!!!!
# invoking a command line like "mvn prefix:goal" with plugin group ID, defined in settings.xml
# PLUGIN_GROUP_ID=eu.europa.ec.rdg.maven.plugin, defined in maven settings.xml + $PLUGIN_VERSION=2.20 
# $MAVEN_EXTRA_OPTS="-B" ... this is a real mvn argument, not created via RTC. It means batch mode processing
# -DprogressText ... and all these kind of arguments, are related with RTD plugin, to link maven with Nexus
$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Setting build result's label" $MAVEN_EXTRA_OPTS
$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildLabel $MAVEN_EXTRA_OPTS

# if return of last command (mvn) is different than 0, it means there is an error, then we exit 1
if [ $? != 0 ]; then
	exit 1
fi

# we launched again the mvn command via $MVN variable calling bin, with arguments
$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Release Sanity Check" $MAVEN_EXTRA_OPTS
# calling mvn with arguments for the Nexus repository
$MVN $PLUGIN_GROUPID:rdg-utils-maven-plugin:$PLUGIN_VERSION:checkPom -DrepoManagerUrl=http://rtd-nexus.cc.cec.eu.int:8081 -DrepoManagerUser=j13b004 -DrepoManagerPass=dHo1aXE3Zw== -Drepo=rdg-releases $MAVEN_EXTRA_OPTS
if [ $? != 0 ]; then
        exit 1
fi

## mode staging when RM builds: is not a PERSonal build by default, proceeding:
# -DrepoManagerUrl mvn argument is specified by indicating nexus repository, to push build in there
if [ "$MODE" == "staging" ] && [ "$PERS" != "true" ]; then
        $MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Preparing staging repository" $MAVEN_EXTRA_OPTS
        $MVN $PLUGIN_GROUPID:rdg-utils-maven-plugin:$PLUGIN_VERSION:createRepo -DrepoManagerUrl=http://mons.cc.cec.eu.int:8081/nexus -DrepoManagerUser=rdg-build-user -DrepoManagerPass=cmRnLWJ1aWxkLXVzZXIx -DrepoPrefix=Staging -DrepoGroup=Stagings -DrepoName=$STAGE_REPO_NAME $MAVEN_EXTRA_OPTS
        if [ $? != 0 ]; then
                exit 1
        fi
        STAGING_REPO=$(cat repo.txt)
        echo Using Staging Repository:$STAGING_REPO
fi

if [ "$PERS" != "true" ]; then
        $MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Reset Snapshot" $MAVEN_EXTRA_OPTS
        $MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:snapshot $MAVEN_EXTRA_OPTS
        if [ $? != 0 ]; then
                exit 1
        fi
fi

$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Generating build dependencies report" $MAVEN_EXTRA_OPTS
$MVN $PLUGIN_GROUPID:rdg-report-maven-plugin:$PLUGIN_VERSION:dependencies -DskipErrors=$SKIP_ERRORS $MAVEN_EXTRA_OPTS
REP_RESULT=$?
$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildResultPublish -Dfile=target/rdg-dependencies.xml -DfileLabel="RDG Dependencies" $MAVEN_EXTRA_OPTS
if [ $? != 0 ] || [ $REP_RESULT != 0 ]; then
	exit 1
fi

$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Building and Deploying project" $MAVEN_EXTRA_OPTS
if [ "$MODE" == "staging" ] && [ "$PERS" != "true" ]; then
	ALT_REPO="-DaltDeploymentRepository=mons-staging::default::http://mons.cc.cec.eu.int:8081/nexus/content/repositories/$STAGING_REPO"
else
	ALT_REPO=
fi
if [ "$PERS" != "true" ]; then
	echo EXECUTE=$MVN $GOALS -Pintegration-test-with-recreate-schema -P$DB_UNIT_PROFILE $ALT_REPO $MAVEN_EXTRA_OPTS -T $THREADS
	$MVN $GOALS -Pintegration-test-with-recreate-schema -P$DB_UNIT_PROFILE $ALT_REPO $MAVEN_EXTRA_OPTS -T $THREADS 2>&1 | tee build.log
	if [ ${PIPESTATUS[0]} != 0 ]; then
		exit 1
	fi
	$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Publishing URLs for artefacts" $MAVEN_EXTRA_OPTS
	$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:deploymentReport -DbuildLog=build.log $MAVEN_EXTRA_OPTS
else
	echo EXECUTE=$MVN $GOALS -Pintegration-test-with-recreate-schema -P$DB_UNIT_PROFILE $MAVEN_EXTRA_OPTS -T $THREADS
        $MVN install -Pintegration-test-with-recreate-schema -P$DB_UNIT_PROFILE $MAVEN_EXTRA_OPTS -T $THREADS
        if [ $? != 0 ]; then
                exit 1
        fi
fi

$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Collecting Unit Tests" $MAVEN_EXTRA_OPTS
$MVN $PLUGIN_GROUPID:rdg-report-maven-plugin:$PLUGIN_VERSION:collectUnittests $MAVEN_EXTRA_OPTS
if [ $? != 0 ]; then
	exit 1
fi

# DEFAULT is true, but we give the possibility to switch off in case of Jacoco has been used
#if [ "$COBERTURA" == "true" ]; then
#	$MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Generating Cobertura report" $MAVEN_EXTRA_OPTS -T $THREADS
#	$MVN cobertura:cobertura -Dcobertura.report.format=xml -Dcobertura.aggregate=true $MAVEN_EXTRA_OPTS -T $THREADS
#fi
if [ "$SONAR" == "true" ]; then
        $MVN $PLUGIN_GROUPID:rdg-rtc-maven-plugin:$PLUGIN_VERSION:buildProgress -DprogressText="Generating Sonar report" $MAVEN_EXTRA_OPTS -T $THREADS
        $MVN org.sonarsource.scanner.maven:sonar-maven-plugin:3.4.0.905:sonar $MAVEN_EXTRA_OPTS $SONAR_EXTRA_OPTS -T $THREADS
        if [ $? != 0 ]; then
                exit 1
        fi
fi
