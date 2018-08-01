#!/bin/bash

read -p "Enter a repo/project/{module} url: " repo

# SVN repository name , e.g.: FOA
svnroot="${repo%/trunk/*}" 
# SVN project name, e.g.: Nippin, or project/module: big_leap_project/wcm_ws_modules
project="${repo##*trunk/}"  
# checking if we will clone/migrate a project as a whole, or just a module folder:
checkModule=$(echo $project | awk -F '/' '{print $2}' | wc -w)
if [[ ${checkModule} -gt 0 ]]
then
    module=$(echo $project | awk -F '/' '{print $2}')
    project=$(echo $project | awk -F '/' '{print $1}')

fi

echo $project
echo $module
