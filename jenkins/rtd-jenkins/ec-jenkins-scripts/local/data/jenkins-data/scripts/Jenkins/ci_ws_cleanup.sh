#!/bin/bash

export WS_JSON_FILE="${WORKSPACE}/workspaces.json"
export COOKIES="${WORKSPACE}/cookies.txt"

# RTC HTTP form based Login
curl -k -c ${COOKIES} ${RTCURI}/authenticated/identity &>/dev/null
curl -k -L -b ${COOKIES} -c ${COOKIES} -d j_username=${RTCUSER} -d j_password=${RTCPWD} ${RTCURI}/authenticated/j_security_check &>/dev/null

# List available workspaces
scm list ws -m 250 -c ${RTCUSER} -r ${REPO} --json > ${WS_JSON_FILE} || cleanup_and_exit 1 "ERROR: Not possible to list repositories of user ${RTCUSER}" 
IFS=" "
for CI_WS in ${CI_WS_LIST} ; do
	WI_WS_LIST="$(cat ${WS_JSON_FILE} | jq -r ".[].name | match(\"${CI_WS}-[0-9]+\") | .string")"
	IFS="
	"
	for WI_WS in ${WI_WS_LIST} ; do
		item="$(echo ${WI_WS} | sed "s/${CI_WS}-//g")"		
		state="$(curl -k  -b ${COOKIES} -H "Accept: application/x-oslc-cm-change-request+json" "${RTCURI}/oslc/workitems/${item}/rtc_cm:state" 2>/dev/null | jq -r .\"dc:title\")"
		if [ "${state}" == "Verified" -o "${state}" == "Done" ] ; then
			sandbox="/ec/local/data/jenkins-data/jobs/${CI_WS}/workspace/${WI_WS}"
			scm workspace delete -r ${REPO} ${WI_WS}
			rm -rf  ${sandbox} \
			&& echo "INFO: Workspace ${WI_WS} delete as Item state is ${state}" \
			|| echo "INFO: Sandbox for workspace ${WI_WS} of item ${item} in state ${state} could not be found under ${sandbox}"
		fi
	done
done