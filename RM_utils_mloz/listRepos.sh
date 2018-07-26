#!/bin/bash
# SCRIPT TO LIST ALL CVS / SVN REPOSITORIES USED IN JENKINS
JENKINS=/data/hudson/jobs
declare -a svnrepos
declare -a cvsrepos
svnIdx=0
cvsIdx=0

dirs=$(ls $JENKINS --ignore "*_team*" --ignore "template*" --ignore "test*" --ignore "*sonar*" --ignore "*deploy*" | grep release)
# Loop in all release jobs and search for repo
for dir in $dirs
do
    if [[ -d "$JENKINS/$dir" ]]; then
        config="$JENKINS/$dir"/config.xml
        if [[ -f $config ]]; then
            # repo in SVN ?
            repo=$(grep -A 3 '<scm class' "$config" | grep "<remote>")
            if [[ -n $repo ]]; then
                repo="$(echo $repo)"
                repo="${repo##<remote>}"
                repo="${repo%%</remote>}"
                svnrepos[$svnIdx]="$repo|$dir"
                ((svnIdx+=1))
            else
                repo=$(grep '<cvsroot>' "$config")
                if [[ -n $repo ]]; then
                    repo="$(echo $repo)"
                    repo="${repo##<cvsroot>}"
                    repo="${repo%%</cvsroot>}"
                    module=$(grep '<module>' "$config")
                    if [[ -n $module ]]; then
                        module="$(echo $module)"
                        module="${module##<module>}"
                        module="${module%%</module>}"
                        repo="$repo|$module|$dir"
                    fi

                    cvsrepos[$cvsIdx]="$repo"
                    ((cvsIdx+=1))
                fi
            fi
        fi
    fi
done

printf "%s\n" "${cvsrepos[@]}" > ~/cvsrepos.txt
printf "%s\n" "${svnrepos[@]}" > ~/svnrepos.txt
