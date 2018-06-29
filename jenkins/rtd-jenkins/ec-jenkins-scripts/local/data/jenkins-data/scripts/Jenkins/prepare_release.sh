#!/bin/bash -x

 
#TEMP
export RTCUSER=j13b004
export RTCPWD=tz5iq7gb
#RTCUSER=jimerod
#RTCPWD=Marzo2018.
export REPO=Production
export RTCURI=https://s-cc-rwp01.net1.cec.eu.int:9443/jazz
export WORKSPACE=/ec/local/data/jenkins-data/jobs/validate-build-request/workspace
export workItem=459393
export THIRD_PARTY_REL_STREAM="Architecture ::: Supporting Projects :: REL"
export STAG_STREAM_9_2="SYG ::: PROD 9.2 Staging"
export STAG_STREAM_10_0="SYG ::: DEV 10.0 (Jenkins +1)"
export WS
 
# Acceptance
#export REPO=Acceptance
#export STAG_STREAM="SYG ::: PROD 7.2 Staging"
#export TARGET_STREAM="SYG ::: PROD 7.2 Maintenance"
#export WS="Sygma-Release"
#export RTCURI=https://s-jazz-acc.net1.cec.eu.int:9443/jazz


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
export HTML_FILE="${WORKSPACE}/output.html"
export JSON_OUTPUT="${WORKSPACE}/json.output.txt"
export COOKIES="${WORKSPACE}/cookies.txt"

export DEPS_REPORT_FILE="${WORKSPACE}/dependencies-report.txt"
export FINAL_DEPS_REPORT_FILE="${WORKSPACE}/dependencies-report-final.txt"
export THIRD_PARTY_STREAM="Architecture ::: Supporting Projects :: REL"

export WS
export ROOT




# Deletes temporary files prints message if second parameter available and exit with value of first ot 1 if not available
cleanup_and_exit(){
	[ -n "$2" ] && echo "$2" 
	[ -z "$1" ] && exit 1 || exit $1
}

# source RTC functions
source ${SCRIPTS}/rtc_functions.sh


# Cleanup
#rm -rf ${WORKSPACE}/output.html ${WORKSPACE}/cookies.txt ${WORKSPACE}/*properties  ${WORKSPACE}/.jazz5                                                                                                                                                                                       &> /dev/null

# RTC HTTP form based Login
#curl -k -c ${COOKIES} ${RTCURI}/authenticated/identity &>/dev/null
#curl -k -L -b ${COOKIES} -c ${COOKIES} -d j_username=${RTCUSER} -d j_password=${RTCPWD} ${RTCURI}/authenticated/j_security_check &>/dev/null

# Fetch all Resolved items
curl -k -o ${JSON_OUTPUT} -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}/rtc_cm:com.ibm.team.workitem.linktype.resolvesworkitem.resolves?oslc_cm.pageSize=100&_startIndex=0&oslc_cm.properties=rtc_cm:com.ibm.team.workitem.linktype.parentworkitem.children" 2> /dev/null 
export ITEMS=$(jq -r ".[].\"rtc_cm:com.ibm.team.workitem.linktype.parentworkitem.children\"[].\"oslc_cm:label\" , .[].\"oslc_cm:label\"" ${JSON_OUTPUT} | sed '/^\s*$/d' | sort | uniq )

# Fetch Snapshot Name, from there obtain Project Relase and iteration
export SNAPSHOT=$(curl -k -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}?oslc_cm.properties=rtc_cm:eu.europa.ec.rdg.apt.attribute.snapshot" 2>/dev/null | jq -r ."\"rtc_cm:eu.europa.ec.rdg.apt.attribute.snapshot\"")

# Fetch target stream and validate name
export TARGET_STREAM="$(curl -k -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${workItem}?oslc_cm.properties=rtc_cm:eu.europa.ec.rdg.apt.attribute.sourcestream" 2> /dev/null | jq .\"rtc_cm:eu.europa.ec.rdg.apt.attribute.sourcestream\" | sed 's/\"//g')"

##if [ "$(scm list streams -m 250 -r ${REPO} --json | jq ".[] | select(.name == \"${TARGET_STREAM}\")")" == "" ]  ; then
##	cleanup_and_exit 1 "ERROR: Stream ${TARGET_STREAM} not found"
##fi

export RELEASE="$(echo ${SNAPSHOT} | grep -o -P "[0-9]+\.[0-9]+((\.[0-9]+)*)?")"
export ITERATION="$(echo ${SNAPSHOT} | grep -o -P it[0-9]+)"

# Select Changeset Source and Release preparation Workspace depending on Project and Version.
if [ -n "$(echo ${SNAPSHOT} | grep -i "sygma")"  ] ; then
	WS="Sygma-Release"
	ROOT="sygma-builder"
	if [ "${RELEASE#9.2}" != "${RELEASE}" ] ; then
		export STAG_STREAM="${STAG_STREAM_9_2}"
	elif [ "${RELEASE#10.0}" != "${RELEASE}" ] ; then 
		export STAG_STREAM="${STAG_STREAM_10_0}"
	elif [ "${RELEASE#7.2}" != "${RELEASE}" ] ; then 
		export STAG_STREAM="SYG ::: PROD 7.2 Staging"
	else
		echo "ERROR: Source stream for Release ${RELEASE} not defined"
	fi
fi


# Store values in properties file to be included in email.
echo "RELEASE=${RELEASE}" > ${PROPERTIES_FILE}
echo "ITERATION=${ITERATION}" >> ${PROPERTIES_FILE}
echo "SNAPSHOT=${SNAPSHOT}" >> ${PROPERTIES_FILE}


# Prepare workspace
echo "INFO: Preparing Workspace making sure that points to the correct component versions from maintenance Stream"
scm load -r ${REPO} -d ${WORKSPACE}/${WS} "${WS}" --allow --force --resync && cd ${WS} || cleanup_and_exit 1 "ERROR: Not possible to load Workspace ${WI_WS}"


scm workspace change-target -r ${REPO} "${WS}" "${STAG_STREAM}" &>/dev/null || { echo "ERROR: Not possible to change flow target to ${STAG_STREAM} of ${WS}" >&2 && exit 1; }
scm workspace replace-component -r ${REPO} --all "${WS}" stream "${TARGET_STREAM}" &>/dev/null || cleanup_and_exit 1 "ERROR: Not possible to set the components from ${TARGET_STREAM} in workspace ${WS}"
scm load -r ${REPO} --force --resync "${WS}" &>/dev/null || cleanup_and_exit 1 "ERROR: Not possible to sync workspace ${WS}"


# Prepare the json file to update planned for on all resolved workitems
cat > ${TMPFILE} <<EOF
{
 "rtc_cm:plannedFor":
  {
   "rdf:resource":"${PLANNED_FOR}"
  }
}
EOF

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

    ID="$(echo $item  | awk -F": " '{print $1}')"
    PLANNEDFOR="$(curl -k  -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${ID}/rtc_cm:plannedFor" 2>/dev/null | jq ".\"dc:identifier\"")"
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
	fi
    # Check planned for value, should match with the current release
    [ "${PLANNEDFOR/${RELEASE}/}" == "${PLANNEDFOR}"  ] && \
    	echo "WARN: Planned Release value \"${PLANNEDFOR}\" of Work Item ${ID} does not match with the current release \"SyGMa ${RELEASE}\""
done

[ -n "${CHANGESETS}" ] && multi_changesets_accept "${CHANGESETS}" "${WS}"

cd ${WORKSPACE}/${WS}/${ROOT} && mvn -Pbuildall validate -Dworkspace="${WORKSPACE}/${WS}" -Dstream="${THIRD_PARTY_REL_STREAM}"

[ ! -e "${DEPS_REPORT_FILE}" ] && cleanup_and_exit 1 "ERROR: Dependency report file ${DEPS_REPORT_FILE} has not been generated"


for dependency in $(cat ${DEPS_REPORT_FILE}) ; do

	## Identify report comment lines
	[ "$(echo ${dependency} | grep -P "^##")" != "" ] && echo ${dependency} > ${FINAL_DEPS_REPORT_FILE} && continue

	artifact="$(echo $dependency | awk -F: '{print $2}')"
	currentVersion="$(echo $dependency | awk -F: '{print $3}')"
	
	requestedVersion=$(echo $dependency | awk -F: '{print $4}' | sed "s/\[TIMESTAMP\]/${timestamp}/")
	
	cd ${WORKSPACE}/${THIRD_PARTY_WS}
	root="$(find . -type d -name ${artifact} | grep -v .jazz5 | awk -F'/' '{print $2}')"
	[ -z "${root}"  ] && echo "ERROR: Root directory for artifact ${artifact} not found: ${WORKSPACE}/${THIRD_PARTY_WS}/${root}" && continue
	
	component="${root}"
	root="${WORKSPACE}/${THIRD_PARTY_WS}/${root}" && cd ${root}
	[ "${processed_projects/${root}}" != "${processed_projects}" ] && \
		echo "INFO: Root ${root} already processed" && continue
	
	processed_projects="${processed_projects}${processed_projects+ }${root}" 
	
	pom="$(find . -maxdepth 1 -name pom.xml)"
	[ -z "${pom}"  ] && echo "ERROR: master pom file not found for ${artifact}" && continue
	
	pomVersion="$(sed 's/xmlns/ignore/' ${pom} |  xmllint --xpath '//project/version/text()' -)"
	[ -z "${pomVersion}"  ] && echo "ERROR: Project version could not be extracted from ${pom}" && continue
	if [ "${currentVersion}" != "${pomVersion}" ] ; then	

		component_streams="$(cat ${WORKSPACE}/list | jq -r '.[] | select (."incoming-flow"==true) | select(.components[].name=="${component}") | (.name)')"
		tmp_pom=${mktemp}
		final_stream=""
		for stream in component_streams ; do
			scm get file -c "${component}" -w "${stream}" -f ${component}/pom.xml -o ${tmp_pom} -r ${REPO}
			pomVersion="$(sed 's/xmlns/ignore/' ${tmp_pom} |  xmllint --xpath '//project/version/text()' -)"
			if [ "${currentVersion}" == "${pomVersion}" ] ; then
				scm workspace replace-component -r ${REPO} "${component}" "${THIRD_PARTY_WS}" stream "${stream}" && cleanup_and_exit() 1 "ERROR: Not possible to replace component ${component} in ${THIRD_PARTY_WS}"
				break
			fi
		done
		[ -z "${final_stream}" ] echo "ERROR: Version used ${currentVersion} could not be found in current component streams: ${component_streams}" 
	
		component_stream="$(cat ${WORKSPACE}/list | grep ${component} | awk -F"---" '{print $1}')"
		echo "## ERROR: Version in pom (${pomVersion}) does not match with version used (${currentVersion}), Current Stream used for component ${component} is ${component_stream}" 
		echo "## If version used is an old version consider update to a released version or current version (${pomVersion}) otherwise indicate in which stream version  " 
		continue
	fi
	
	
	echo "INFO: ${artifact} Root: ${root} Current version: ${pomVersion} New version: ${requestedVersion}"
	
	#mvn versions:set -DnewVersion="${requestedVersion}" -DprocessAllModules && mvn versions:commit || cleanup_and_exit "ERROR: Running Maven versions:set to $new for artifact ${artifact}"
	#mvn clean compile  &> ${artifact}.log && cleanup_and_exit "ERROR: Running Maven deploy goal for artifact ${artifact}"
	
	#scm show pc --xunresolved --json | jq -r ".workspaces[0].components[] | select(.unresolved != null) | .unresolved[].path" | sed 's/^\///g' | xargs scm checkin --comment "Version updated to ${new} artifact ${artifact}" -W ${workItem} \
	#	|| cleanup_and_exit 1 "ERROR: Not possible to checkin pom version updates for artifact $artifact in workspace ${WORKSPACE}"
	#scm deliver -s "${WS}" -t "${STAG_STREAM}" || cleanup_and_exit 1 "ERROR: Not possible to deliver pom version updates for artifact ${artifact} to ${REL_STREAM}" 
	
done





DEPS_REPORT="$(cat ${DEPS_REPORT_FILE})"
cat > ${TMPFILE} <<EOF
{
 "rtc_cm:dependencies_description":
  {
   "rdf:resource":"${DEPS_REPORT}"
  }
}
EOF

curl -D - -k -b ${COOKIES} -H "Content-Type: application/x-oslc-cm-change-request+json" -H "Accept: application/json" -X PUT --data-binary @${TMPFILE} \
${RTCURI}/resource/itemName/com.ibm.team.workitem.WorkItem/${workItem} &> /dev/null || cleanup_and_exit 1 "ERROR: Not posible to upload dependencies report to RTC"


