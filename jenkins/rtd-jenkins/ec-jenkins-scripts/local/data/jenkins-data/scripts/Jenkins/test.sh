#!/bin/bash -x


WORKSPACE=/ec/local/data/jenkins-data/jobs/sygma-9-CI/workspace
export CI_WS="Sygma9-CI"
export ITEMS_TO_BUILD="360311 458002 458283"



for item in ${ITEMS_TO_BUILD} ; do

	WI_WS="${CI_WS}-${item}"
	
	# If workspace has been deleted not run validation
	[ ! -e ${WORKSPACE}/${WI_WS} ] && cleanup_and_exit 1 "ERROR: Workspace directory ${WORKSPACE}/${WI_WS} not available"
	
	cd ${WORKSPACE}/${WI_WS}
	echo "INFO: Validating Workitem ${item}"

	
	# Option 2 - Paralell build
	bash -c "cd ${WORKSPACE}/${WI_WS}/sygma-builder && mvn clean &> ${WORKSPACE}/${item}.log && && scm deliver -r ${REPO} -t \"${STAG_STREAM}\"" &
	PIDS+=($!)
	ITEMS+=($item)
	
	
	

done

echo ${PIDS[@]}
echo ${ITEMS[@]}

# Wait until all Compilations ends 
for((i=0;i<${#PIDS[@]};++i)); do
  wait ${PIDS[i]}
  STATUS=$?
  item=${ITEMS[i]}
  echo "Item: ${ITEMS[i]} pid: ${PIDS[i]} Status: $?"
  
  if [ "${STATUS}" = "0" ] ; then
		echo "<li>${item} <font color=\"green\" ><b>OK</b></font> <a href=\"${BUILD_URL}artifact/${item}.log\">[log]</a></li>" >> ${HTML_FILE}
		echo "INFO: mvn clean install run succesfully in Sygma Integration Workspace ${CI_WS}-${item}"
		echo "INFO: Delivering changes to ${STAG_STREAM}"
	else
		echo "<li>${item} <font color=\"red\" ><b>NOK</b></font> <a href=\"${BUILD_URL}artifact/${item}.log\">[log]</a></li>" >> ${HTML_FILE}
		echo "INFO: mvn clean install DID not run succesfully in Sygma Integration Workspace ${CI_WS}-${item}"
	fi
  
  
done


echo "</ul></font>" >> ${HTML_FILE}