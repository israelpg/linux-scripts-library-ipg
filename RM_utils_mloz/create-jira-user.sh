#!/bin/bash
# This script creates users in Jira with file JIRA_USERS as input
JIRA_USERS="./por_Requester.csv"
curl_user='m999hfo'
curl_pwd='Tomytomy'
url='https://apps-proto.sdlc.gfdi.be/jira/rest/api/2'
#url='https://jira.sdlc.gfdi.be/jira/rest/api/2'
certif='/home/m999hfo/Downloads/mteam-ca.crt'
group='por_Requester'
password='welcome01'


# Create user group
curl -u"$curl_user:$curl_pwd" -X POST  -H "Content-Type: application/json" "$url/group" -d "{ \"name\": \"${group}\" }"

while IFS='|' read -r name username mail displayName
do
    # create user if email defined
    if [[ ! -z "${mail-x}" ]]; then
        curl -k -u"$curl_user:$curl_pwd" -X POST  -H "Content-Type: application/json" "$url/user" -d "{ \"key\": \"$username\", \"name\": \"$username\", \"fullname\": \"$name\", \"displayName\": \"$displayName\", \"password\": \"$password\", \"emailAddress\": \"$mail\", \"applicationKeys\": [ \"jira-core\", \"jira-software\"]}"
        # Add user to Jira Software application
        curl -k -u"$curl_user:$curl_pwd" -X POST  -H "Content-Type: application/json"  "$url/group/user?groupname=jira-users" -d "{ \"name\":\"$username\"}"
    fi

    # Add user to gdpr group
    curl -k -u"$curl_user:$curl_pwd" -X POST  -H "Content-Type: application/json"  "$url/group/user?groupname=$group" -d "{ \"name\":\"$username\"}"

done <"$JIRA_USERS"
