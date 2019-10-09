45 * * * * /data/scripts/listWASApps.sh &> /data/scripts/cron

#MUST BE DEPLOYED ON DMGR SERVER

# parameters
workDir=/data/scripts
wasDir=/data/was85/dmgr/bin
listApps=applications_running.txt
jythonScript=list_apps.py
defaultAppsArray=(filetransferSecured ibmasyncrsp isclite ManagementEJB MiddlewareAgentServices OTiS)
destinationServer=s598li2wseb01.integ.gfdi.be
destinationDir=/data/scripts

if [[ ${PWD} != ${workDir} ]]; then
	cd $workDir
fi

# get list of running application from DMGR
$wasDir/wsadmin.sh -f $workDir/$jythonScript $workDir/$listApps

# remove WAS default apps
for line in "${defaultAppsArray[@]}"
do
    sed -i "/$line/d" $workDir/$listApps
done

# Transfer list of WAS apps to destination server
scp $listApps root@$destinationServer:$destinationDir