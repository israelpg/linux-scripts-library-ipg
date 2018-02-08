#!/bin/bash

echo "Starting Backup..."
# Setting-up environment
NOW=$(date "+%y-%m-%d")
FILE="$NOW.totalBkp_scripts.tar.bz2"
FOLDER=/backups/totalBkp/$NOW
# Log Management
touch $FILE.log ; logFile=$FILE.log ; mv $logFile /backups/logs
pathLog=/backups/logs/$logFile
echo "--- Backup Scripts Folder ---" >> $pathLog
date >> $pathLog
# Backup starts by creating container folder
mkdir $FOLDER >> $pathLog
# transfer files to folder
rsync -avzh /home/natasa/pruebas/scripts $FOLDER >> $pathLog
# compression and removing container once backup has been moved to specific bkp folder
tar -jcvf $FILE $FOLDER ; mv $FILE /backups/totalBkp/ && rm -Rf $FOLDER
#rsync -avz ../totalBkp/$FILE ip14aai@10.57.122.196:~Backups/backup_client_library
echo "Backup successfully completed, folder: $FOLDER"
echo "Logs are in: $pathLog"

