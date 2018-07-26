#!/bin/bash
GIT_USER="m999hfo"
GIT_PASSWD="Tomytomy"
outputdir="/mnt/cvsifs"

mount -t cifs //gfdi.gfdi.be/ROOT/home/ARCAD/MT "$outputdir" -o rw,noperm,user=m999hfo,password=welcome01,vers=1.0

cd "$outputdir"

# All projects
projects="$(curl -k -um999hfo:Tomytomy -X GET  'http://git.sdlc.gfdi.be/rest/api/1.0/projects' -H 'Content-Type: application/json' | json_reformat | grep key | sed 's/\"key\": "//' | sed 's/",//')"
for project in $projects; do
    repos="$(curl -k -um999hfo:Tomytomy -X GET http://git.sdlc.gfdi.be/rest/api/1.0/projects/$project/repos -H 'Content-Type: application/json' | json_reformat | grep slug | sed 's/\"slug\": "//' | sed 's/",//')"
    # All repos in project
    for repo in $repos; do
        echo "Repo: $project - $repo"
        # Asking
        url="http://$GIT_USER:$GIT_PASSWD@git.sdlc.gfdi.be/scm/$project/$repo.git"
        git clone "$url"
    done
done

umount "$outputdir"
