#!/bin/bash -x


# Acceptance
export RTCUSER=jimerod
export RTCPWD=Marzo2018.
export WORKSPACE=/ec/local/data/jenkins-data/jobs/release-dependencies/workspace
export REPO=Production
export STAG_STREAM="SYG ::: PROD 7.2 Staging"
export TARGET_STREAM="SYG ::: PROD 7.2 Maintenance"

export WS="Sygma-Release"
export RTCURI=https://s-jazz-acc.net1.cec.eu.int:9443/jazz
export COOKIES="${WORKSPACE}/cookies.txt"
export DEPENDENCIES_FILE="${WORKSPACE}/dependencies.txt"
export workItem=399296


# Deletes temporary files prints message if second parameter available and exit with value of first ot 1 if not available
cleanup_and_exit(){
	[ -n "$2" ] && echo "$2" 
	[ -z "$1" ] && exit 1 || exit $1
}

get_last_alpha_version(){
	[ "$#" != "2" ] && echo "Usage: get_last_alpha_version [ARTIFACT] [VERSION]"
	local artifact=$1
	local version=$2
	local output=${mktemp}
	local lastVersion="$(scm list snapshots --json -r Production "SYG ::: PROD 9.2 Maintenance" | jq -r .snapshots[].name 2>/dev/null | grep ${artifact}-${version}-Alpha | sort | wc -l)"
	return $((lastVersion+1))
}

# Cleanup
rm -rf ${WORKSPACE}/output.html ${WORKSPACE}/*properties  ${WORKSPACE}/.jazz5                                                                                                                                                                                       &> /dev/null

# RTC HTTP form based Login
#curl -k -c ${COOKIES} ${RTCURI}/authenticated/identity &>/dev/null
#curl -k -L -b ${COOKIES} -c ${COOKIES} -d j_username=${RTCUSER} -d j_password=${RTCPWD} ${RTCURI}/authenticated/j_security_check &>/dev/null


# Fetch target stream and validate name
#curl -k -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}"
#DEPENDENCIES="$(curl -k -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}?oslc_cm.properties=rtc_cm:dependencies_description" | jq -r .\"rtc_cm:dependencies_description\")"
DEPENDENCIES="$(cat dependencies.report.txt)"

for dependency in ${DEPENDENCIES} ; do
	artifact="$(echo $dependency | awk -F: '{print $2}')"
	old="$(echo $dependency | awk -F: '{print $3}')"
	new="$(echo $dependency | awk -F: '{print $4}')"
	 
	root="$(find . -maxdepth 2 -type d -name ${artifact} | grep -v .jazz5 | awk -F'/' '{print $2}')"
	[ -z "${root}" -o ! -e "${root}" ] && cleanup_and_exit "ERROR: Root directory for artifact ${artifact} not found"
	root="${WORKSPACE}/${root}" && cd ${root}
	mvn versions:set -DnewVersion="${new}" -DprocessAllModules && mvn versions:commit || cleanup_and_exit "ERROR: Running Maven versions:set to $new for artifact ${artifact}"
	mvn clean compile  &> ${artifact}.build.log && cleanup_and_exit "ERROR: Running Maven deploy goal for artifact ${artifact}"
	
	#scm show pc --xunresolved --json | jq -r ".workspaces[0].components[] | select(.unresolved != null) | .unresolved[].path" | sed 's/^\///g' | xargs scm checkin --comment "Version updated to ${new} artifact ${artifact}" -W ${workItem} \
	#	|| cleanup_and_exit 1 "ERROR: Not possible to checkin pom version updates for artifact $artifact in workspace ${WORKSPACE}"
	#scm deliver -s "${WS}" -t "${STAG_STREAM}" || cleanup_and_exit 1 "ERROR: Not possible to deliver pom version updates for artifact ${artifact} to ${REL_STREAM}" 
	
done


# Prepare the json file to update planned for on all resolved workitems
TMPFILE=$(mktemp)
cat > ${TMPFILE} <<EOF
{
 "rtc_cm:dependencies_description":
  {
   "rdf:resource":"test"
  }
}
EOF

#Update
curl -D - -k -b ${COOKIES} -H "Content-Type: application/x-oslc-cm-change-request+json" -H "Accept: application/json" -X PUT --data-binary @${TMPFILE} \
${RTCURI}/resource/itemName/com.ibm.team.workitem.WorkItem/${workItem} &> /dev/null
