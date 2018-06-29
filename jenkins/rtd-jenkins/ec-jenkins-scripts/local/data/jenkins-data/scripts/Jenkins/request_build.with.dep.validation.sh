#!/bin/bash -x

 
#TEMP
#RTCUSER=j13b004
#RTCPWD=tz5iq7gb
#RTCUSER=jimerod
#RTCPWD=Marzo2018.
#WORKSPACE=/ec/local/data/jenkins-data/jobs/sygma-request-build
#workItem=399296
 
# Acceptance
#export REPO=Acceptance
#export STAG_STREAM="SYG ::: PROD 7.2 Staging"
#export TARGET_STREAM="SYG ::: PROD 7.2 Maintenance"
#export WS="Sygma-Release"
#export RTCURI=https://s-jazz-acc.net1.cec.eu.int:9443/jazz



# Production
#export REPO=Prod
#export WS="SyGMaReleaseStream"
#export RTCURI=https://s-cc-rwp01.net1.cec.eu.int:9443/jazz

export SCM_ALLOW_INSECURE=1
export ACCEPTED_WIS=""
export IFS="
"

# Files
export TMPFILE=$(mktemp)
export PROPERTIES_FILE="${WORKSPACE}/${JOB_NAME}-${BUILD_NUMBER}.properties"
export WORKITEMS_JSON_FILE="${WORKSPACE}/workitems.json"
export COMPARE_JSON_OUTPUT_FILE="${WORKSPACE}/output.compare.txt"
export COMPARE_JSON_FILE="${WORKSPACE}/parsed.compare.txt"
export WS_JSON_FILE="${WORKSPACE}/workspaces.json"
export ACCEPT_OUTPUT_FILE="${WORKSPACE}/accept.output.txt"
export ERROR_OUTPUT="${WORKSPACE}/error.output.txt"
export BUILD_OUTPUT_FILE="build.output.txt"
export BUILD_OUTPUT="${WORKSPACE}/${BUILD_OUTPUT_FILE}"

export HTML_FILE="${WORKSPACE}/output.html"
export JSON_OUTPUT="${WORKSPACE}/json.output.txt"
export COOKIES="${WORKSPACE}/cookies.txt"


export THIRD_PARTY_DEV_STREAM="Architecture ::: Supporting Projects :: DEV"
export THIRD_PARTY_REL_STREAM="Architecture ::: Supporting Projects :: REL"
export THIRD_PARTY_WS="Release-ThirdParty"

export workItem="458165"

# Deletes temporary files prints message if second parameter available and exit with value of first ot 1 if not available
cleanup_and_exit(){
	[ -n "$2" ] && echo "$2" 
	[ -z "$1" ] && exit 1 || exit $1
}


# Fetch dependencies versions report
export DEPENDENCIES_REPORT="$(curl -k -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}?oslc_cm.properties=rtc_cm:dependencies_description" | jq -r .\"rtc_cm:dependencies_description\" | grep -v -P '^##')"
DEPENDENCIES="$(cat dependencies.report.txt)"

for dependency in $(echo ${DEPENDENCIES} | grep -v -P "^##") ; do
	artifact="$(echo $dependency | awk -F: '{print $2}')"
	old="$(echo $dependency | awk -F: '{print $3}')"
	new="$(echo $dependency | awk -F: '{print $4}')"
	
	cd ${WORKSPACE}/${THIRD_PARTY_WS}
	root="$(find .  -maxdepth 2 -type d -name ${artifact} | grep -v .jazz5 | awk -F'/' '{print $2}')"
	[ -z "${root}" -o ! -e "${root}" ] && cleanup_and_exit "ERROR: Root directory for artifact ${artifact} not found"
	root="${WORKSPACE}/${THIRD_PARTY_WS}/${root}" && cd ${root}
	#mvn versions:set -DnewVersion="${new}" -DprocessAllModules && mvn versions:commit || cleanup_and_exit "ERROR: Running Maven versions:set to $new for artifact ${artifact}"
	#mvn clean compile  &> ${artifact}.log && cleanup_and_exit "ERROR: Running Maven deploy goal for artifact ${artifact}"
	
	#scm show pc --xunresolved --json | jq -r ".workspaces[0].components[] | select(.unresolved != null) | .unresolved[].path" | sed 's/^\///g' | xargs scm checkin --comment "Version updated to ${new} artifact ${artifact}" -W ${workItem} \
	#	|| cleanup_and_exit 1 "ERROR: Not possible to checkin pom version updates for artifact $artifact in workspace ${WORKSPACE}"
	#scm deliver -s "${WS}" -t "${STAG_STREAM}" || cleanup_and_exit 1 "ERROR: Not possible to deliver pom version updates for artifact ${artifact} to ${REL_STREAM}" 
	
done




# Cleanup
rm -rf ${WORKSPACE}/output.html ${WORKSPACE}/cookies.txt ${WORKSPACE}/*properties  ${WORKSPACE}/.jazz5 &> /dev/null

# RTC HTTP form based Login
curl -k -c ${COOKIES} ${RTCURI}/authenticated/identity &>/dev/null
curl -k -L -b ${COOKIES} -c ${COOKIES} -d j_username=${RTCUSER} -d j_password=${RTCPWD} ${RTCURI}/authenticated/j_security_check &>/dev/null

# RTC SCM CLI login
scm login -u ${RTCUSER} -P ${RTCPWD}  -n ${REPO} -r ${RTCURI} -c &>/dev/null || cleanup_and_exit 1 "ERROR: Not possible to login in RTC Server"

# Fetch all Resolved items
curl -k -o ${JSON_OUTPUT} -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}/rtc_cm:com.ibm.team.workitem.linktype.resolvesworkitem.resolves?oslc_cm.pageSize=100&_startIndex=0&oslc_cm.properties=rtc_cm:com.ibm.team.workitem.linktype.parentworkitem.children" 2> /dev/null 
export ITEMS=$(jq -r ".[].\"rtc_cm:com.ibm.team.workitem.linktype.parentworkitem.children\"[].\"oslc_cm:label\" , .[].\"oslc_cm:label\"" ${JSON_OUTPUT} | sed '/^\s*$/d' | sort | uniq )

# Fetch Snapshot Name, from there obtain Relase and iteration
export SNAPSHOT="$(curl -k -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}?oslc_cm.properties=rtc_cm:eu.europa.ec.rdg.apt.attribute.snapshot" 2>/dev/null | jq -r ."\"rtc_cm:eu.europa.ec.rdg.apt.attribute.snapshot\"")"



# Fetch target stream and validate name
export TARGET_STREAM="$(curl -k -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}?oslc_cm.properties=rtc_cm:eu.europa.ec.rdg.apt.attribute.sourcestream" 2> /dev/null | jq .\"rtc_cm:eu.europa.ec.rdg.apt.attribute.sourcestream\" | sed 's/\"//g')"

if [ "$(scm list streams -m 250 -r ${REPO} --json | jq ".[] | select(.name == \"${TARGET_STREAM}\")")" == "" ]  ; then
	cleanup_and_exit 1 "ERROR: Stream ${TARGET_STREAM} not found"
fi

export RELEASE=$(echo ${SNAPSHOT} | grep -o -P "[0-9]+\.[0-9]+((\.[0-9]+)*)?")
export ITERATION=$(echo ${SNAPSHOT} | grep -o -P it[0-9]+)


# Select source Stream depending on Version.
if [ "${RELEASE#9.2}" != "${RELEASE}" ] ; then
	export STAG_STREAM="${STAG_STREAM_9_2}"
elif [ "${RELEASE#10.0}" != "${RELEASE}" ] ; then 
	export STAG_STREAM="${STAG_STREAM_10_0}"
else
	echo "ERROR: Source stream for Release ${RELEASE} not defined"
fi


# Store values in properties file to be included in email.
echo "RELEASE=${RELEASE}" > ${PROPERTIES_FILE}
echo "ITERATION=${ITERATION}" >> ${PROPERTIES_FILE}
echo "SNAPSHOT=${SNAPSHOT}" >> ${PROPERTIES_FILE}


# Prepare workspace
echo "INFO: Preparing Workspace making sure that points to the correct component versions from maintenance Stream"
scm workspace change-target -r ${REPO} "${WS}" "${STAG_STREAM}" &>/dev/null || { echo "ERROR: Not possible to change flow target to ${STAG_STREAM} of ${WS}" >&2 && exit 1; }
scm workspace replace-component -r ${REPO} --all "${WS}" stream "${TARGET_STREAM}" &>/dev/null || cleanup_and_exit 1 "ERROR: Not possible to set the components from ${TARGET_STREAM} in workspace ${WS}"
scm load -r ${REPO} --force --resync "${WS}" &>/dev/null || cleanup_and_exit 1 "ERROR: Not possible to sync workspace ${WS}"



# Generate changeset list
scm compare -r ${REPO} --json -I s -f o stream "${STAG_STREAM}" stream "${TARGET_STREAM}"  > ${COMPARE_JSON_OUTPUT_FILE} || cleanup_and_exit 1 "ERROR: Not possible to run the compara command..." 
#scm compare -r ${REPO} --json -I s -f o   stream "${STAG_STREAM}" workspace "${WS}"  > ${COMPARE_JSON_OUTPUT_FILE} || cleanup_and_exit 1 "ERROR: Not possible to run the compara command..." 
jq -r  '.direction[].components[] | select(.changesets != null) |  .changesets[] | (.uuid + "::" + (.workitems[0]."workitem-number"|tostring) + "::" + .author.mail  + "::" + .comment + "::" + .workitems[0]."workitem-label" )' ${COMPARE_JSON_OUTPUT_FILE} 2> ${ERROR_OUTPUT} > ${COMPARE_JSON_FILE} \
	|| { cat ${ERROR_OUTPUT} ; cleanup_and_exit 1 "ERROR: Running jq parser..."; }
jq -r  '.direction[].components[] | select(.baselines != null) | .baselines[] | select(.changesets != null) |  .changesets[] | (.uuid + "::" + (.workitems[0]."workitem-number"|tostring) + "::" + .author.mail  + "::" + .comment + "::" + .workitems[0]."workitem-label" )'  ${COMPARE_JSON_OUTPUT_FILE} 2> ${ERROR_OUTPUT} >> ${COMPARE_JSON_FILE} \
	|| { cat ${ERROR_OUTPUT} ; cleanup_and_exit 1 "ERROR: Running jq parser..."; }  
  
# Accept all changesets linked to the workitems present in the Staging stream accept them

CHANGESETS=""
for item in ${ITEMS} ; do

    ID=$(echo $item  | awk -F": " '{print $1}')
    PLANNEDFOR=$(curl -k  -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${ID}/rtc_cm:plannedFor" 2>/dev/null | jq ".\"dc:identifier\"")
	ITEM_CHANGESETS="$(cat ${COMPARE_JSON_FILE} | grep "${ID}"| awk -F:: '{print $1}')"
	
	if [ -n "${ITEM_CHANGESETS}" ] ; then 
		if [ -n "${CHANGESETS}" ] ; then 
			CHANGESETS="${CHANGESETS}
${ITEM_CHANGESETS}"
		else
			CHANGESETS="${ITEM_CHANGESETS}"
		fi
    else
		echo "WARN: No Changesets found for item ${item}"
		echo "<font color=\"red\">WARN: No Changesets found for item ${item}</font><br/>" >> ${HTML_FILE}
	fi
	
    	
done

echo "<ul>" >> 	${HTML_FILE}
for changeset in ${CHANGESETS} ; do
	comment="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $4}')"
	workitem_id="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $2}')"
	echo "<li><b>${workitem_id}</b>: ${changeset} -- ${comment}</li>"	>> 	${HTML_FILE}
	
done
echo "</ul>" >> ${HTML_FILE}


multi_changesets_accept "${CHANGESETS}" "${WS}"




# Update poms if first iteration
cd ${WORKSPACE}/sygma-builder
[ "${ITERATION/it01/}" != "${ITERATION}" ] && mvn versions:set -DnewVersion="${RELEASE}-SNAPSHOT" -DprocessAllModules && mvn versions:commit

# Maven validation
mvn clean &> ${BUILD_OUTPUT} || { \
echo "<p><font color=\"red\">ERROR in maven Build <a href=\"${BUILD_URL}artifact/${BUILD_OUTPUT_FILE}\">[log]</a></font></p>" >> ${HTML_FILE} \
cleanup_and_exit 1 "ERROR: Running mvn clean install" ; }

echo "<p><font color=\"green\">Maven Build Succesfull <a href=\"${BUILD_URL}artifact/${BUILD_OUTPUT_FILE}\">[log]</a></font></p>" >> ${HTML_FILE}

# Deliver pom modifications to the Staging stream
cd ${WORKSPACE}
if [ "${ITERATION/it01/}" != "${ITERATION}" ] ; then 
	scm show pc --xunresolved --json | jq -r ".workspaces[0].components[] | select(.unresolved != null) | .unresolved[].path" | sed 's/^\///g' | xargs scm checkin --comment "pom updates to ${RELEASE}-SNAPSHOT" -W ${workItem} \
		|| cleanup_and_exit 1 "ERROR: Not possible to checkin pom version updates in workspace ${WORKSPACE}"
	scm deliver -s "${WS}" -t "${STAG_STREAM}"   || cleanup_and_exit 1 "ERROR: Not possible to deliver changes to ${STAG_STREAM}" 
fi

# Deliver Requested items to the target stream
##scm deliver -s "${WS}" -t "${TARGET_STREAM}" || cleanup_and_exit 1 "ERROR: Not possible to deliver changes to ${TARGET_STREAM}"

# Create Snapshot in Target Stream
##scm create snapshot -r ${REPO} --json -n "${SNAPSHOT}" "${TARGET_STREAM}" > ${JSON_OUTPUT} || cleanup_and_exit 1 "ERROR: Not possible to create Snapshot ${SNAPSHOT}"
SNAPSHOT_ID="$(cat ${JSON_OUTPUT} | jq -r .uuid)"
echo "SNAPSHOT_ID=${SNAPSHOT_ID}" >> ${PROPERTIES_FILE}

cleanup_and_exit 0 "END"