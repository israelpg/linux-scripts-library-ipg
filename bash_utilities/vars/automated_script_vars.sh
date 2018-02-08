#!/bin/bash

# recover folder for this user

whoUser=$(whoami)

homeFolder="/home/${whoUser}"

echo "Home Folder is: $homeFolder"

echo "Creating container folder for user id: $UID - username: $whoUser"

mkdir "${homeFolder}/container"

ls -lah "${homeFolder}/container"
