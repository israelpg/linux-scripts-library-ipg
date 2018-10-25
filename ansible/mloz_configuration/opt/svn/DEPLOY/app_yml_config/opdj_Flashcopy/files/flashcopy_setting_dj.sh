#!/bin/bash

echo "Script will be executed as nohup & using trap:"
echo "To check the ongoing process and associated PID type: ps -ef | grep 'flashcopy'"
echo "Logs are redirected to /tmp folder, and are only readable by user forgerock"
{
trap '' HUP
binaries_folder="/data/forgerock/software/opendj_users/bin/"
logs_dir="/tmp"
timestamp=$(date +%F_%H%M)
hostname=$(echo ${HOSTNAME})

# Checking that mteam.ldif from PROD has been previously copied to the opendj{INT||REF} host:
if [[ ! -f /tmp/mteam.ldif ]]; then
	echo "Script terminated with error: Missing mteam.ldif within dir tmp in hostname: $hostname !"
	exit 1
fi

# List of hosts:
integ_dj03="s000li2opdj03.integ.gfdi.be"
integ_dj01="s000li2opdj01.integ.gfdi.be"
ref_dj03="s000lr2opdj03.ref.cpc998.be"
ref_dj01="s000lr2opdj01.ref.cpc998.be"

# Password selection depending on host:
if [[ ${hostname} == ${integ_dj03} ]]; then
	password="pJQQKjZwlCUSXojEfGM="
elif [[ ${hostname} == ${integ_dj01} ]]; then
	password="gNTyB51VCPy5ZNvY2r8="
elif [[ ${hostname} == ${ref_dj03} ]]; then
	password="DqkdvaQR+Zb2wvxmmPg="
elif [[ ${hostname} == ${ref_dj01} ]]; then
	password="UfTktHeRF6BZymynRjL9"
fi

if [[ ${PWD} != ${binaries_folder} ]]; then
	cd ${binaries_folder}
fi

echo "Setting up $hostname ongoing:"
echo "Executing dsconfig setting password policy operation ..."
./dsconfig set-password-policy-prop --policy-name 'Default Password Policy' --set allow-pre-encoded-passwords:true --hostname localhost --port 4444 \
--bindDN cn='Directory Manager' --bindPassword ${password} --trustAll --no-prompt
echo "Password policy completed."
echo "Executing ldapsearch | ldapdelete for dc=m-team,dc=be ..."
./ldapsearch -p 1389 --bindDN "cn=Directory Manager" --bindPassword ${password} -b "dc=m-team,dc=be" -s one "(objectclass=*)" dn | grep -v admin \
| cut -d ' ' -f 2 | grep -v -e '^$' | ./ldapdelete -x -p 1389 --bindDN "cn=Directory Manager" --bindPassword ${password}
echo "ldapsearch | ldapdelete completed."
echo "Uncompressing mteam.ldif file and applying ldapmodify operation ..."	
zcat /tmp/mteam.ldif | ./ldapmodify -a -c -p 1389 --bindDN "cn=Directory Manager" --bindPassword ${password}
echo "ldapmodify completed."
mv /tmp/mteam.ldif /tmp/mteam.${timestamp}.ldif
echo "Script completed, please check logs here: ${logs_dir}/flashcopy_setting_dj.${timestamp}.log"
} < /dev/null > ${logs_dir}/flashcopy_setting_dj.${timestamp}.log &

chown forgerock:forgerock ${logs_dir}/flashcopy_setting_dj.${timestamp}.log && chmod 660 ${logs_dir}/flashcopy_setting_dj.${timestamp}.log

exit 0