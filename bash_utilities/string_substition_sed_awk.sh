#!/bin/bash

# After a pattern, add the content of file to another file: 
sed -i -e "/<\/properties>/r ${EXECUTION_DIR}/git_config_lines_template.txt" "${WORKSPACE}/${job}/config.xml"

# some substitution
sed -i "s/bitbucket-project/$BITBUCKET_PROJECT/g" "${WORKSPACE}/${job}/config.xml"
sed -i "s/git-repository/$module.git/g" "${WORKSPACE}/${job}/config.xml"

# awk for adding file content after pattern 
f1="$(< ${WORKSPACE}/git_config_lines_template.txt)"
awk -vf1="$f1" '/<\/properties>/{print;print f1;next}1' "${WORKSPACE}/${job}/config.xml"

