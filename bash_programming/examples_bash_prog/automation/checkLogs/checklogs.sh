#!/bin/bash

set -o errexit
#set -o nounset

iopt=""
vopt=""
readonly installationPath="/usr/bin" # while filename will be fetch with $0
tecreset=$(tput sgr0) # resetting shell format output arguments
readonly logsFolder="/var/log"
numberLogsRedHat=0
numberLogsDebian=0
token="true"
numberErrors=0
errorsDetected=0

# list of possible main logs for Red Hat, to check if they exist and possible to select as option by user prompt:
candidateLogsRedHat=(messages secure boot.log dmesg kern.log faillog cron yum.log mail.log httpd mysql.log)

# building actual list of available log files for this specific machine:
arrayLogsRedHat=()
numberLogsRedHat=${#candidateLogsRedHat[*]}
for ((i=0; i<numberLogsRedHat; i++))
do
	checkLog=${candidateLogsRedHat[$i]} # check if red hat candidate log file really exists (used) in machine
	if [[ -f $logsFolder/$checkLog ]]
	then
		arrayLogsRedHat+=("$checkLog") # if exists, then is added in the arrayLogsRedHat for user option
	fi
done
# adding option all_errors_classified as a feature to classify all existing log files in machine at once:
arrayLogsRedHat+=("all_errors_classified") # if exists, then is added in the arrayLogsRedHat for user option

echo -e '\E[32m'"The complete list of elements for red hat logs available in this system: $tecreset"
echo ""
echo ${arrayLogsRedHat[*]}
echo ""

# printing each element in the array, listing all possible options for Red Hat logs (10 logs):
function listingRedHatLogs()
{
        echo -e '\E[32m'"Please select one of these options: $tecreset"
	echo ""
        numberLogsRedHat=${#arrayLogsRedHat[*]}
	for ((i=0; i<numberLogsRedHat; i++))
        do
          	echo "Select option $i for: ${arrayLogsRedHat[$i]}"
                echo ""
        done
}

arrayLogsDebian=(syslog auth.log boot.log dmesg kern.log faillog cron dpkg.log mail.log httpd mysql.log all_errors_classified)

# printing each element in the array, listing all possible options for Red Hat logs (10 logs):
function listingDebianLogs()
{
        echo -e '\E[32m'"List of Debian system logs: $tecreset"
	echo ""
        #numberLogsRedHat=${#arrayLogsRedHat[*]}
	for i in {0..$numberLogsRedHat}
        do
          	echo "Select option $i for: ${arrayLogsDebian[$i]}"
                echo ""
        done
}

function errorsClassified()
{
        echo -e '\E[32m'"Listing all errors classified: $tecreset"
	echo ""
	for i in {0..10} # complete array except last element, which is the name for option checking all logs
	do
		logChecking="${arrayLogsRedHat[$i]}"
		if [[ -f $logsFolder/$logChecking ]]
		then
			printf -v int errorsDetected=$(cat $logsFolder/$logChecking | grep -ci 'error')
			if [[ $errorsDetected -gt 0 ]]
			then
				listErrors=$(cat $logsFolder/$logSelected | grep -i 'error' | tail -n 3)
				echo  "Listing up to last three error lines in log ${arrayLogsRedHat[$i]}"
				echo "$listErrors"
				echo ""
				errorsDetected=0
			else
				echo -e '\E[32m'"No errors recorded in ${arrayLogsRedHat[i]} $tecreset"
				echo ""
			fi
		fi
	done
}

# evaluating wheter the script is called with an argument for -i install or -v version-check
while getopts iv name
do
  	case $name in
          i)iopt=1;;
          v)vopt=1;;
          *)echo -e '\e[31;22m'"Invalid argument, please type -i for installing the script, or -v for checking version number. $tecreset";;
        esac
done

# in case the while loop case $name for argument contains i (iopt var created), then start installation
if [[ ! -z $iopt ]]
then
{
wd=$(pwd)
# test -L "$0" --> command:test tests whether symblink for script filename $0 (called by user) exists, if not the case, filename is moved to /tmp
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
# create as root su -c the binary for execution in case it does not exist / not installed yet:
if [[ -e $installationPath/checklogs ]]
then
	echo -e '\E[32m'"Script already installed, run it with command: checklogs $tecreset"
	exit 0
else
	su -c "cp $scriptname $installationPath/checklogs" root && echo -e '\E[32m'"Congratulations! Script installed, now run it with command: checklogs $tecreset" || echo 2&>1 | tee '/tmp/checklogs_$$.log'
fi
}
fi

if [[ ! -z $vopt ]]
then
{
echo -e '\E[32m'"checklogs version 1.0\nDesigned by IPG\nReleased Under GNU License $tecreset"
}
fi

# if no arguments had been passed when calling this script, then it means execution will follow:
if [[ $# -eq 0 ]]
then
{
# check whether the system is a Red Hat or a Debian distro: logs are different in some cases (see arrays for complete list)
# if exists a main config file redhat-release in etc: red hat, if exists file debian_version in etc as well then Debian system:
if [[ -f /etc/redhat-release ]]
then
	# user input via prompt for option selection / log to check:
	while [[ $token == "true" ]]
	do
		listingRedHatLogs
		indexLogs=`echo "$numberLogsRedHat" -2 | bc`
		allLogsRH=`echo "$numberLogsRedHat" -1 | bc`
		read -p "Please select log option number: " logOption
		case "$logOption" in
		#[0-9]|10)
		[0-$indexLogs])
			tokenAgain="true"
			logSelected="${arrayLogsRedHat[$logOption]}"
			if [[ -f $logsFolder/$logSelected ]]
			then
				echo -e '\E[32m'"The log selected is: $logSelected $tecreset"
				printf -v int numberErrors=$(cat $logsFolder/$logSelected | grep -ci 'error')
				echo -e '\e[31;22m'"Number of errors in $logSelected: $numberErrors $tecreset"
				if [[ $numberErrors -gt 0 ]]
				then
					echo -e '\e[31;22m'"Listing up to last 3 lines of the log file $logSelected with error: $tecreset"
					echo ""
					cat $logsFolder/$logSelected | grep -i 'error' | tail -n 3
					echo ""
				else
					echo -e '\E[32m'"No errors in the log file $logSelected, listing last three lines: $tecreset"
					cat $logsFolder/$logSelected | tail -n 3
					echo ""
				fi

				while [[ $tokenAgain == "true" ]]
				do
					read -p "Type l for listing again the log options, of q for exiting script: " nextOption
					case "$nextOption" in
					l)
						echo "You have chosen to check more logs ..."
						tokenAgain="false"
						;;
					q)
						tokenAgain="false"
						token="false"
						exit 0
						;;
					*)
						echo -e '\e[31;22m'"Wrong option ... $tecreset"
						;;
					esac
				done
			else
				echo "Log selected $logSelected does not exist ..."
				echo ""
			fi
			;;
		$allLogsRH)
			errorsClassified
			;;
		q)
			echo "Exiting script ..."
			exit 0
			;;
		*)
			echo -e '\e[31;22m'"Wrong option, please select a valid option from the list or q to quit: $tecreset"
			;;
		esac
	done
elif [[ -f /etc/debian_version ]]
then
	# commands for checking Debian logs
	echo "Debian"
fi
}
fi
