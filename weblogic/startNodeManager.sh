#!/bin/sh
# *************************************************************************
# This script can be used to start the WebLogic NodeManager
#
# To start the NodeManager on <host> and <port>, set the LISTEN_ADDRESS 
# variable to <host> and LISTEN_PORT variable to <port> before calling this 
# script.
#
# This script sets the following variables before starting the NodeManager:
# 
# BEA_HOME       - The BEA root installation directory.
# WL_HOME        - The root directory of your WebLogic installation.
# NODEMGR_HOME   - The root directory for this NodeManagerInstance.
# JAVA_HOME      - Location of the version of Java used to start WebLogic 
#                  Server. This variable must point to the root directory of a 
#                  JDK installation and will be set for you by the installer. 
#                  See the Oracle Fusion Middleware Supported System Configurations page 
#                  (http://www.oracle.com/technology/software/products/ias/files/fusion_certification.html) 
#                  for an up-to-date list of supported JVMs.
# PATH           - Adds the JDK and WebLogic directories to the system path.  
# CLASSPATH      - Adds the JDK and WebLogic jars to the classpath.  
# JAVA_OPTIONS   - Java command-line options for running the server. (These
#                  will be tagged on to the end of the JAVA_VM and MEM_ARGS)
# JAVA_VM        - The java arg specifying the VM to run.  (i.e. -server, 
#                  -hotspot, etc.)
# MEM_ARGS       - The variable to override the standard memory arguments
#                  passed to java
#
# Alternately, this script will take the first two positional parameters and 
# set them to LISTEN_ADDRESS and LISTEN_PORT. For instance, you could call this
# script: "sh startNodeManager.sh holly 7777" to start the NodeManager
# on host holly and port 7777, or just "sh startNodeManager.sh holly" 
# to start the node manager on host holly.
# *************************************************************************

# Set user-defined variables.
unset JAVA_VM MEM_ARGS

umask 027


mypwd="$(pwd)"

# Determine the location of this script...
# Note: this will not work if the script is sourced (. ./config.sh)
SCRIPTNAME=$0
case ${SCRIPTNAME} in
 /*)  SCRIPTPATH=`dirname "${SCRIPTNAME}"` ;;
  *)  SCRIPTPATH=`dirname "${mypwd}/${SCRIPTNAME}"` ;;
esac

WL_HOME="/home/ip14aai/Oracle/Middleware/Oracle_Home/wlserver"
# store all environment variables for reset later, if restarting
pre=$(env)


#
#  restoreOrigEnv 
#  restores the environment to the exact same as it was when we
#  were initially called, resetting values as they were and
#  unsetting any values that were set during exec.  The one
#  exception is JAVA_HOME - we leave that alone because
#  the JAVA_HOME rollout may reset/update the value
#
restoreOrigEnv() {
 IFS=$'\n' # make newlines the only separator
 for line in $pre ; do
   name=$(echo $line | cut -d '=' -f 1)
   value="$(echo $line | cut -d '=' -f 2-)"

   # only reset if the value is different
   if [ "$name" != "JAVA_HOME" ] && [ "$name" != "SUN_JAVA_HOME" ] && [ "$name" != "DEFAULT_SUN_JAVA_HOME" ] && [ "${!name}" != "${value}" ]; then
     eval "export $name=\"$value\""
     echo "reset ${name} to ${value}"
   fi 
 done

 #unset any variables that were set during our exec
 now=$(env)
 #compact pre has no new line characers
 compactpre=$(echo pre)
 IFS=$'\n' # make newlines the only separator
 #iterate through the current env, and if it was not in pre, then unset it
 for line in $now ; do
   name=$(echo $line | cut -d '=' -f 1)
   if [ "$(echo "${pre}"|grep "^$name\=")" == "" ]; then
     unset ${name}
   fi
 done
}

. "${WL_HOME}/../oracle_common/common/bin/commEnv.sh"

if [ "${NODEMGR_HOME}" = "" ]
  then
    NODEMGR_HOME="${WL_HOME}/../user_projects/nodemanager/machine-0"
    #NODEMGR_HOME="home/ip14aai/Oracle/Middleware/Oracle_Home/user_projects/nodemanager/machine-0"
 else
    echo NODEMGR_HOME is already set to ${NODEMGR_HOME} 
fi

# If NODEMGR_HOME does not exist, create it
if [ ! -d "${NODEMGR_HOME}" ]; then
  echo ""
  echo "NODEMGR_HOME ${NODEMGR_HOME} does not exist, creating it.."
  mkdir -p "${NODEMGR_HOME}"
fi

# Set first two positional parameters to LISTEN_ADDRESS and LISTEN_PORT
if [ "${1}" != "" ]; then
  LISTEN_ADDRESS="${1}"
fi

if [ "${2}" != "" ]; then
  LISTEN_PORT="${2}"
fi

# Check for JDK
if [ ! -d "${JAVA_HOME}/bin" ]; then
  echo "The JDK wasn't found in directory ${JAVA_HOME}."
  echo "Please edit the startNodeManager.sh script so that the JAVA_HOME"
  echo "variable points to the location of your JDK."
  exit 1

else

if [ "${MEM_ARGS}" = "" ]
then
MEM_ARGS="-Xms32m -Xmx200m"
fi

if [ -n "${BEA_HOME}" ] ; then 
  JAVA_OPTIONS="-Dbea.home=${BEA_HOME} ${JAVA_OPTIONS}"
fi
if [ -n "${COHERENCE_HOME}" ] ; then 
  JAVA_OPTIONS="-Dcoherence.home=${COHERENCE_HOME} ${JAVA_OPTIONS}"
fi

if [[ "$JAVA_OPTIONS" != *"-Dweblogic.RootDirectory"* ]]; then
  # it is global NM
  JAVA_OPTIONS="-Dweblogic.RootDirectory=${NODEMGR_HOME} ${JAVA_OPTIONS}"
fi    

CLASSPATH="${WEBLOGIC_CLASSPATH}${CLASSPATHSEP}${CLASSPATH}${CLASSPATHSEP}${BEA_HOME}"
echo "CLASSPATH=${CLASSPATH}"

# Get PRE and POST environment
if [ ! -z "${PRE_CLASSPATH}" ]; then
  CLASSPATH="${PRE_CLASSPATH}${CLASSPATHSEP}${CLASSPATH}"
fi
if [ ! -z "${POST_CLASSPATH}" ]; then
  CLASSPATH="${CLASSPATH}${CLASSPATHSEP}${POST_CLASSPATH}"
fi

TMP_UPDATE_SCRIPT="/tmp/Update.sh"
export TMP_UPDATE_SCRIPT
export CLASSPATH
export PATH

cd "${NODEMGR_HOME}"
if [ "$LISTEN_PORT" != "" ]
 then
   if [ "$LISTEN_ADDRESS" != "" ]
    then
     set -x
     "${JAVA_HOME}/bin/java" ${JAVA_PROPERTIES} ${JAVA_VM} ${MEM_ARGS} ${JAVA_OPTIONS} -Djava.security.policy="${WL_HOME}/server/lib/weblogic.policy" -Dweblogic.nodemanager.JavaHome="${JAVA_HOME}" -DListenAddress="${LISTEN_ADDRESS}" -DListenPort="${LISTEN_PORT}" weblogic.NodeManager -v
    else
     set -x
     "${JAVA_HOME}/bin/java" ${JAVA_PROPERTIES} ${JAVA_VM} ${MEM_ARGS} ${JAVA_OPTIONS} -Djava.security.policy="${WL_HOME}/server/lib/weblogic.policy" -Dweblogic.nodemanager.JavaHome="${JAVA_HOME}" -DListenPort="${LISTEN_PORT}" weblogic.NodeManager -v
   fi
 else
   if [ "$LISTEN_ADDRESS" != "" ]
    then
     set -x
     "${JAVA_HOME}/bin/java" ${JAVA_PROPERTIES} ${JAVA_VM} ${MEM_ARGS} ${JAVA_OPTIONS} -Djava.security.policy="${WL_HOME}/server/lib/weblogic.policy" -Dweblogic.nodemanager.JavaHome="${JAVA_HOME}" -DListenAddress="${LISTEN_ADDRESS}" weblogic.NodeManager -v
    else
     set -x
     "${JAVA_HOME}/bin/java" ${JAVA_PROPERTIES} ${JAVA_VM} ${MEM_ARGS} ${JAVA_OPTIONS} -Djava.security.policy="${WL_HOME}/server/lib/weblogic.policy" -Dweblogic.nodemanager.JavaHome="${JAVA_HOME}" weblogic.NodeManager -v
   fi
fi
fi


status=$?
set +x
cd -
if [ $status -eq 86 ]; then
    updatedLockExists="false"
    while [ -f "${TMP_UPDATE_SCRIPT}.lck" ]
      do
        if [ "$updatedLockExists" == "false" ]; then
          echo "Waiting for file '${TMP_UPDATE_SCRIPT}.lck' to be removed"
          for line in $(< ${TMP_UPDATE_SCRIPT}.lck)
          do
            case $line in
              *=*) eval $line;;
            esac
          done
          updatedLockExists="true"
        fi
        sleep 0.5
      done

    if [ "$updatedLockExists" == "false" ]; then
      if [ -f "$TMP_UPDATE_SCRIPT" ]; then
          echo "Calling $TMP_UPDATE_SCRIPT"
          (cd /tmp;$TMP_UPDATE_SCRIPT)
          ustatus=$?

          # restoring the original env before unsetting JAVA_HOME 
          # in order to unset any JAVA_HOME that was passed in from domainEnv
          if [ $ustatus -eq 42 ]; then
                JAVA_HOME=
                SUN_JAVA_HOME=
                DEFAULT_SUN_JAVA_HOME=
                #TODO: can we modify pre to remove JAVA_HOME=XXXX
          fi
      else
          echo "ERROR! $TMP_UPDATE_SCRIPT did not exist"
      fi
    else
      shopt -s nocasematch
      if [ "$ResetJava" == "true" ]; then
        JAVA_HOME=
        SUN_JAVA_HOME=
        DEFAULT_SUN_JAVA_HOME=
      fi
      shopt -u nocasematch
    fi
    #
    #  call the same script path that was supplied in order to support
    #  symbolic links 
    #
    restoreOrigEnv
    exec $SCRIPTPATH/startNodeManager.sh $*
else
    if [ $status -eq 88 ]; then
        restoreOrigEnv
        exec $SCRIPTPATH/startNodeManager.sh $*
    fi
fi

