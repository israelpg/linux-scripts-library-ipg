#!/bin/bash -x



# Production
#export REPO=Production
#export RTCURI=https://s-cc-rwp01.net1.cec.eu.int:9443/jazz
#export STAG_STREAM="SYG ::: DEV 10.0 (Jenkins +1)"
#export MAINT_STREAM="SYG ::: PROD 7.2 Maintenance"
#export CI_STREAM="SYG ::: DEV 10.0 (Jenkins +1)"
#export CI_WS="Sygma10-CI"

#TEMP
#export RTCUSER=j13b004
#export RTCPWD=tz5iq7gb
#export WORKSPACE=/ec/local/data/jenkins-data/jobs/sygma-10-CI/workspace
#export WORKSPACE=/ec/local/data/jenkins-data/jobs/sygma-9-CI/workspace
#export STAG_STREAM="SYG ::: PROD 9.2 Staging"
#export CI_WS=Sygma9-CI
#export MAINT_STREAM="SYG ::: PROD 9.2 Staging"
#export CI_STREAM="SYG ::: PROD 9.2 Staging"


# Acceptance
#export REPO=Acceptance
#export STAG_STREAM="SYG ::: PROD 7.2 Staging"
#export MAINT_STREAM="SYG ::: PROD 7.2 Maintenance"
#export CI_STREAM="SYGMA CI"
#export CI_WS="Sygma-CI"
#export RTCURI=https://s-jazz-acc.net1.cec.eu.int:9443/jazz

export SCM_ALLOW_INSECURE=1
export ACCEPTED_WIS=""

#Files
export WORKITEMS_JSON_FILE="${WORKSPACE}/workitems.json"
export COMPARE_JSON_OUTPUT_FILE="${WORKSPACE}/output.compare.txt"
export COMPARE_JSON_FILE="${WORKSPACE}/parsed.compare.txt"
export WS_JSON_FILE="${WORKSPACE}/workspaces.json"
export ACCEPT_OUTPUT_FILE="${WORKSPACE}/accept.output.txt"
export ERROR_OUTPUT="${WORKSPACE}/error.output.txt"
export PROPERTIES_FILE="${WORKSPACE}/${JOB_NAME}-${BUILD_NUMBER}.properties"
export HTML_FILE="${WORKSPACE}/output.html"
export IFS="
"
export EXIT="0"

# Deletes temporary files prints message if second parameter available and exit with value of first ot 1 if not available
cleanup_and_exit(){
	[ -n "$2" ] && echo "$2" 
	[ -z "$1" ] && exit 1 || exit $1
}

# Accept Workitem and all dependant workitems (complete workitem rather than only dependant changesets), this function is recursive
recursive_accept(){
	[ -z "${COMPARE_JSON_FILE}" -o -z "${WORKSPACE}" -o -z "${REPO}" ] && cleanup_and_exit 1 "ERROR recursive_accept: env vars COMPARE_JSON_FILE, WORKSPACE, REPO must be available"
	[ "$#" != "2" ] && cleanup_and_exit 1 "Usage: recursive_accept {WORKITEM} {WORKSPACE}"
	local item="$1"
	local WS="$2"
	local DEPENDS=false
	local ERROR=false 
	local OK=false
	local NOCHANGES=false
	local CHANGESETS CHANGESETS_TMP ACCEPTED_CS_LIST DEPENDS
	
	CHANGESETS_TMP="$(cat ${COMPARE_JSON_FILE} | grep "${item}"| awk -F:: '{print $1}')"
	IFS="
	"
	# When recursive, we have to filter out already accepted changesets to avoid Java exception in accept command of type 
	#	"com.ibm.team.filesystem.client.FileSystemException: Change set (_hXvJgGWIEeiy0Ng7xuT15Q) is already in history."
	# ACCEPTED_CSS tracks all accepted changesets so far of a item workspace.
	for changeset in ${CHANGESETS_TMP} ; do
		echo "${ACCEPTED_CSS}" | grep "${changeset}" > /dev/null || CHANGESETS="${CHANGESETS}${CHANGESETS:+ }${changeset}"
	done
	[ -z "${CHANGESETS}" ] && return 0
	
	echo ${CHANGESETS} | sort | uniq | xargs scm accept -r ${REPO} -c  -t "${WS}" 2>&1 | tee ${ACCEPT_OUTPUT_FILE} 
	cat ${ACCEPT_OUTPUT_FILE} | grep 'Missing change sets found' &> /dev/null && DEPENDS=true
	cat ${ACCEPT_OUTPUT_FILE} | grep -P 'Accepting changes would introduce too many conflicts|Ensure that change sets are completed before they can be accepted|Could not secure .jazz-scm' &> /dev/null && ERROR=true
	cat ${ACCEPT_OUTPUT_FILE} | grep 'Following workspaces still have conflicts after accept' &> /dev/null &&  ERROR=true
	cat ${ACCEPT_OUTPUT_FILE} | grep 'The accept command completed successfully' &> /dev/null &&  OK=true
	cat ${ACCEPT_OUTPUT_FILE} | grep -P 'Workspace unchanged|No change sets found for the specified work items' &> /dev/null && echo "WARN: No changes for ${item}, why this item has been triggered ..." && NOCHANGES=true
	
	if "${ERROR}" ; then
		echo "ERROR: An unexpected error occurred accepting changes for workspace \"${WS}\""
		echo "<li> <font color=\"red\" ><b>ERROR: An unexpected error occurred accepting changes ${item} into workspace ${WS}</font></b></li>" >> ${HTML_FILE}
		return 1
	elif "${DEPENDS}" ; then
		DEPENDS_ON_CS_LIST="$(echo ${CHANGESETS} | xargs scm list missing-changesets -w ${WS} --json -r ${REPO} | jq -r .changes[].uuid)"
		ACCEPTED_CS_LIST="$(echo ${CHANGESETS} | xargs scm accept -r ${REPO} -c --json --accept-missing-changesets -t "${WS}" | jq -r .repos[0].workspaces[0].components[].changes[].uuid)"
		ACCEPTED_CSS="${ACCEPTED_CSS}${ACCEPTED_CSS:+ }${ACCEPTED_CS_LIST}" 
		IFS="
		"		
		# Print accepted changesets in the html report
		for changeset in ${ACCEPTED_CS_LIST} ; do
			comment="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $4}')"
			#workitem="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $2 " -- " $5}')"
			workitem_id="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $2}')"
			echo "<li><b> ${workitem_id} </b>: $changeset -- $comment</li>"	>> 	${HTML_FILE}
		done
		
		for changeset in ${DEPENDS_ON_CS_LIST} ; do
			# Figure out for which workitem this dependant changeset belongs to, If is not in the present in pending changes workitem list -> error
			DEPENDS_ON_WI="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $2}')"
			if [ -n "${DEPENDS_ON_WI}" ] ; then
				[ "$(echo ${DEPENDS_ON_WI_LIST} | grep ${DEPENDS_ON_WI})" == "" ] && \
				DEPENDS_ON_WI_LIST="${DEPENDS_ON_WI_LIST}${DEPENDS_ON_WI_LIST:+ }${DEPENDS_ON_WI}"
			else
				#cleanup_and_exit 1 "ERROR: No WorkItem found as incomming changes, for dependant changeset ${changeset}"
				echo "ERROR: No WorkItem found as incomming changes, for dependant changeset ${changeset}" 
				echo "<li><b><font color=\"red\" >ERROR: No WorkItem found as incomming changes, for dependant changeset ${changeset}</font></b></li>" >> ${HTML_FILE} 
				return 1
			fi
		done
		
		[ "$(echo ${ACCEPTED_WIS} | grep ${item})" == "" ] && ACCEPTED_WIS="${ACCEPTED_WIS}${ACCEPTED_WIS:+ }${item}"
		
		
		if [ -n "${DEPENDS_ON_WI_LIST}" ] ; then
			IFS=" "
			for dependant_wi in ${DEPENDS_ON_WI_LIST} ; do
				if [ "$(echo ${ACCEPTED_WIS} | grep ${dependant_wi})" == "" ] ; then 
					recursive_accept "${dependant_wi}" "${WS}"
					status="$?"
					[ "$status" != "0" ] && return $status
				fi
			done
			IFS="
			"
		fi
		
	elif "${OK}" ; then	
		[ "$(echo ${ACCEPTED_WIS} | grep ${item})" == "" ] && ACCEPTED_WIS="${ACCEPTED_WIS}${ACCEPTED_WIS:+ }${item}"
		echo "INFO: Changesets for item ${item} has been accepted."
	
		ACCEPTED_CSS="${ACCEPTED_CSS}${ACCEPTED_CSS:+ }${CHANGESETS}"
	
		# Print accepted changesets in the html report
		IFS=" "
		for changeset in ${CHANGESETS} ; do
			comment="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $4}')"
			#workitem="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $2 " -- " $5}')"
			workitem_id="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $2}')"
			echo "<li><b>${workitem_id}</b>: $changeset -- $comment</li>"	>> 	${HTML_FILE}
		done
	
	elif "${NOCHANGES}" ; then	
		echo "WARN: There are no changesets of item ${item} to be accepted."
		return 1
	else 
		#cleanup_and_exit 1 "ERROR: Accepting changes for item ${item}"
		echo "ERROR: Accepting changes for item ${item}" 
		echo "<li><b><font color=\"red\" >ERROR: Accepting changes for item ${item} into workspace ${WS}</font></b></li>" >> ${HTML_FILE} 
		return 1
	fi
	return 0
}


# Cleanup files from previous build
rm -rf ${WORKSPACE}/*.html ${WORKSPACE}/*.log ${WORKSPACE}/*.txt ${WORKSPACE}/*.json ${WORKSPACE}/*.properties ${WORKSPACE}/.jazz5  &> /dev/null

# dump header on html output that would be used by the Notification post action
cat <<EOF >> ${HTML_FILE}
<h3>Jenkins Build <a href=\"${BUILD_URL}\">${JOB_NAME}#${BUILD_NUMBER}</a></h3>
CI Stream: <b>${CI_STREAM}</b> <br/>
CI Workspace: <b>${CI_WS}</b><br/>
EOF


# CLI login
scm login -u ${RTCUSER} -P ${RTCPWD}  -n ${REPO} -r ${RTCURI} -c &>/dev/null || cleanup_and_exit 1 "ERROR: Not possible to login in RTC Server" 


# Generate changeset list report, to be accepted and validated
scm compare -r ${REPO} --json -I s -f i workspace "${CI_WS}" stream "${CI_STREAM}"  > ${COMPARE_JSON_OUTPUT_FILE} || cleanup_and_exit 1 "ERROR: Not possible to run the compare command..." 
#scm compare -r ${REPO} --json -I s -f o stream "${CI_STREAM}" snapshot "${SNAPSHOT}" > ${COMPARE_JSON_OUTPUT_FILE} || cleanup_and_exit 1 "ERROR: Not possible to run the compare command..." 
jq -r  '.direction[].components[] | select(.changesets != null) |  .changesets[] | (.uuid + "::" + (.workitems[0]."workitem-number"|tostring) + "::" + .author.mail  + "::" + .comment + "::" + .workitems[0]."workitem-label" )' ${COMPARE_JSON_OUTPUT_FILE} 2> ${ERROR_OUTPUT} > ${COMPARE_JSON_FILE} \
	|| { cat ${ERROR_OUTPUT} ; cleanup_and_exit 1 "ERROR: Running jq parser..."; }
jq -r  '.direction[].components[] | select(.baselines != null) | .baselines[] | select(.changesets != null) |  .changesets[] | (.uuid + "::" + (.workitems[0]."workitem-number"|tostring) + "::" + .author.mail  + "::" + .comment + "::" + .workitems[0]."workitem-label" )'  ${COMPARE_JSON_OUTPUT_FILE} 2> ${ERROR_OUTPUT} >> ${COMPARE_JSON_FILE} \
	|| { cat ${ERROR_OUTPUT} ; cleanup_and_exit 1 "ERROR: Running jq parser..."; }
 

# Define mail recipients
RECIPIENTS="$(cat ${COMPARE_JSON_FILE} | awk -F:: '{print $3}' | sort | uniq)"
echo "RECIPIENTS=${RECIPIENTS}${RECIPIENTS:+,}Rodrigo.JIMENEZ-RODGRIGUEZ@ext.ec.europa.eu,Antoine.DE-TROOSTEMBERGH@ext.ec.europa.eu" > ${PROPERTIES_FILE} 
 
# Check if there are new changes
if [ ! -s ${COMPARE_JSON_FILE} ] ; then
	echo "No new changes detected in ${CI_STREAM}" >> ${HTML_FILE}
	cleanup_and_exit 0 "WARN: No changes detected ..."
fi

# Extract from comparation output list of workitems, if empty means nothing to check
ITEMS_TO_VERIFY="$(cat ${COMPARE_JSON_FILE} | awk -F:: '{print $2}' | awk '!x[$0]++')"
[ -z "${ITEMS_TO_VERIFY}" ] && echo "INFO: No new changes to accept into ${CI_WS}" && cleanup_and_exit 0 "END"



# Snapshot creation in DEV Stream, to be used as start point for workspace creation.
SNAPSHOT="${JOB_NAME}-${BUILD_NUMBER}"
scm create snapshot -r ${REPO} -n "${SNAPSHOT}" "${CI_WS}" || cleanup_and_exit 1 "ERROR: Not possible to create Snapshot ${SNAPSHOT} in ${CI_STREAM}"

# Accept all Changesets in CI stream before anyone delivers new changeset, to prevent accepting changes not validated
scm load -r ${REPO} -d ${WORKSPACE}/${CI_WS} --resync --allow --force ${CI_WS}
cd ${WORKSPACE}/${CI_WS} && scm accept -r ${REPO} -v  -t "${CI_WS}" | tee ${WORKSPACE}/ci.accept.log
cat ${WORKSPACE}/ci.accept.log  | grep -P "Could not secure .jazz-scm|Missing change|would introduce too many conflic|still have conflicts after accept" && cleanup_and_exit 1 "ERROR: Accepting all changes from ${CI_STREAM} into ${CI_WS}"


# Build CI Workspace
cd ${WORKSPACE}/${CI_WS}/sygma-builder && mvn clean compile test 2>&1 > ${WORKSPACE}/ci.log
BUILD_STATUS="$?"

if [ "${BUILD_STATUS}" = "0" ]; then
	echo "Build: <font color=\"green\" ><b>OK</b></font><a href=\"${BUILD_URL}artifact/ci.log\"> [Build log]</a><br/>" >> ${HTML_FILE}
	echo "INFO: Compilation and changes delivery run succesfully in Sygma Integration Workspace ${CI_WS}"
else
	echo "Build: <font color=\"red\" ><b>NOK</b></font> <a href=\"${BUILD_URL}artifact/ci.log\"> [Build log]</a><br/>" >> ${HTML_FILE}
	echo "ERROR: Compilation in Sygma Integration Workspace ${CI_WS}"	
fi

# Print accepted changesets in the html report
echo "${CI_WS} Accepted Changesets:<ul>"  >> ${HTML_FILE}
for item in ${ITEMS_TO_VERIFY} ; do
	item_summary="$(cat ${COMPARE_JSON_FILE} | grep "::${item}::" | head -1 | awk -F:: '{print $5}')"
	CHANGESETS="$(cat ${COMPARE_JSON_FILE} | grep "${item}"| awk -F:: '{print $1}')"
	echo "<li><a href=\"${RTCURI}/web/projects/SyGMa#action=com.ibm.team.workitem.viewWorkItem&id=${item}\"> Item: ${item}: ${item_summary}</a></li><ul>" >> ${HTML_FILE}
	for changeset in ${CHANGESETS} ; do
		comment="$(cat ${COMPARE_JSON_FILE} | grep "${changeset}" | awk -F:: '{print $4}')"
		echo "<li><b> $changeset </b> $comment</li>" >> ${HTML_FILE}
	done
	echo "</ul>" >> ${HTML_FILE}		
done
echo "</ul>" >> ${HTML_FILE}
#[ "${BUILD_STATUS}" = "0" ] && cleanup_and_exit 0 "END"


# If Validation on CI stream did not succeded, We split changes by Workitem in different WS's and run validation on each
echo "<h3>Item Workspaces & Changesets</h3><ul>"  >> ${HTML_FILE}

# List available workspaces and cd to root workspace directory
scm list ws -m 250 -c ${RTCUSER} -r ${REPO} --json > ${WS_JSON_FILE} || cleanup_and_exit 1 "ERROR: Not possible to list ${RTCUSER} repositories" 
cd ${WORKSPACE}


# Check if CI workspace for each item exists otherwise create it
# For each item run a recursive_accept (in case of dependencies)
for item in ${ITEMS_TO_VERIFY} ; do
	
	# Testing
	#echo ${item} | grep "449998" || continue
	
	WI_WS="${CI_WS}-${item}"
	item_summary="$(cat ${COMPARE_JSON_FILE} | grep "::${item}::" | head -1 | awk -F:: '{print $5}')"
	DEPENDS_ON_WI_LIST=""
		
	#If new workitem -> create the workspace
	if [ "$(cat ${WS_JSON_FILE} | jq ".[].name | match(\"${WI_WS}\")")" == "" ] ; then	
		rm -rf ${WORKSPACE}/${WI_WS} &> /dev/null
		scm create ws -r ${REPO} --snapshot "${SNAPSHOT}" "${WI_WS}" || cleanup_and_exit 1 "ERROR: Not possible to create Workspace ${WI_WS}"
	else 
		scm workspace replace-component -r ${REPO} --all "${WI_WS}" snapshot "${SNAPSHOT}"
	fi
	scm load -r ${REPO} -d ${WORKSPACE}/${WI_WS} "${WI_WS}" --allow --force --resync  || cleanup_and_exit 1 "ERROR: Not possible to load Workspace ${WI_WS}"
	scm ws add-flowtargets -r ${REPO} "${WI_WS}" "${CI_STREAM}" || cleanup_and_exit 1 "ERROR: Not possible to add flow target ${CI_STREAM} in workspace ${WI_WS}"
	scm ws flowtarget -r ${REPO} --current i --default i "${WI_WS}" "${CI_STREAM}" || cleanup_and_exit 1 "ERROR: Not possible to set ${CI_WS} as income flow for workspace ${WI_WS}"
	cd ${WORKSPACE}/${WI_WS} || cleanup_and_exit 1 "ERROR: workspace directory ${WORKSPACE}/${WI_WS} not available"

	echo "<li><a href=\"${RTCURI}/web/projects/SyGMa#action=com.ibm.team.workitem.viewWorkItem&id=${item}\"> Item: ${item}: ${item_summary}</a> (Workspace ${WI_WS})</li><ul>" >> ${HTML_FILE}
	ACCEPTED_WIS="" && ACCEPTED_CSS=""
	recursive_accept "${item}" "${WI_WS}" 
	ACCEPT_RESULT=$?
	[ "${ACCEPT_RESULT}" -gt "0" ] && EXIT="1"
	echo "</ul>" >> ${HTML_FILE}
	[ "${ACCEPT_RESULT}" = "0" ] && ITEMS_TO_BUILD="${ITEMS_TO_BUILD}${ITEMS_TO_BUILD:+ }${item}"	
	
done	


[ -n "${ITEMS_TO_BUILD}" ] && cat <<EOF >> ${HTML_FILE}
</ul>
<h3>Validation & Delivery</h3>
<ul>
EOF


IFS=" "
for item in ${ITEMS_TO_BUILD} ; do

	WI_WS="${CI_WS}-${item}"
	
	# Option 1 - Serial build
	#CI_BUILD_OK=false
	#echo "INFO: Validating Workitem ${item}"
	#cd ${WORKSPACE}/${WI_WS}/sygma-builder && mvn clean compile &> ${WORKSPACE}/${item}.log && CI_BUILD_OK=true || echo "ERROR: Running mvn clean install in Sygma Integration Workspace"
	#if ${CI_BUILD_OK} ; then
	#	echo "<li>${item} <font color=\"green\" ><b>OK</b></font> <a href=\"${BUILD_URL}artifact/${item}.log\">[log]</a></li>" >> ${HTML_FILE}
	#	echo "INFO: mvn clean install run succesfully in Sygma Integration Workspace ${CI_WS}-${item}"
	#	echo "INFO: Delivering changes to ${STAG_STREAM}" #&& scm deliver -r "${REPO}" -t "${STAG_STREAM}"
	#else
	#	echo "<li>${item} <font color=\"red\" ><b>NOK</b></font> <a href=\"${BUILD_URL}artifact/${item}.log\">[log]</a></li>" >> ${HTML_FILE}
	#	echo "INFO: mvn clean install DID not run succesfully in Sygma Integration Workspace ${CI_WS}-${item}"
	#fi
	
	# Option 2 - Paralell build
	#bash -c "cd ${WORKSPACE}/${WI_WS}/sygma-builder && mvn clean compile &> ${WORKSPACE}/${item}.log && scm deliver -r ${REPO} -t \"${STAG_STREAM}\" &>> ${WORKSPACE}/${item}.log" &
	# TESTING Not deliver
	bash -c "cd ${WORKSPACE}/${WI_WS}/sygma-builder && mvn clean compile 2>&1 > ${WORKSPACE}/${item}.log" &
	PIDS+=($!) && ITEMS+=($item)
done

# Wait until all background tasks ends 
for((i=0;i<${#PIDS[@]};++i)); do
	wait ${PIDS[i]}
	STATUS=$?
	item=${ITEMS[i]}
	WI_WS="${CI_WS}-${item}"
	
	echo "INFO: Item: ${item} pid: ${PIDS[i]} Status: ${STATUS}"
	cd ${WORKSPACE}/${WI_WS} && scm ws unload -r Production -D -w ${WI_WS} &
	if [ "${STATUS}" = "0" ]; then
		echo "<li>${item} <font color=\"green\" ><b>OK</b></font> <a href=\"${BUILD_URL}artifact/${item}.log\">[log]</a></li>" >> ${HTML_FILE}
		echo "INFO: Compilation and changes delivery run succesfully in Sygma Integration Workspace ${CI_WS}-${item}"
	else
		EXIT="1"
		echo "<li>${item} <font color=\"red\" ><b>NOK</b></font> <a href=\"${BUILD_URL}artifact/${item}.log\">[log]</a></li>" >> ${HTML_FILE}
		echo "INFO: Either Compilation or changes delivery DID not run succesfully in Sygma Integration Workspace ${CI_WS}-${item}"
	fi
done

echo "</ul></font>" >> ${HTML_FILE}
cleanup_and_exit "${EXIT}" "END"

