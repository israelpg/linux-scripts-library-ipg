#!/bin/bash

# this can be really useful combined with wget as command parameter $@

repeat()
{
	while true
	do
		$@ && return
		sleep 10 # every 10 seconds tries the command
	done
}

export -f repeat

bash subprocess.sh
