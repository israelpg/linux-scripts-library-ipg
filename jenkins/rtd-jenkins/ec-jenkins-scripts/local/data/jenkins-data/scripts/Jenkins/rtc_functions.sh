#!/bin/bash -x


resync_scripts(){
	[ -z "${SCRIPTS}" -o -z "${REPO}"  ] && { echo "ERROR: either SCRIPTS or REPO env vars is not defined" && return 1; }
	cd ${SCRIPTS}/..
	scm load -r ${REPO} --resync --allow "Build-Scripts"
	return $?
}