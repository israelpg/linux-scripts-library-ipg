#!/bin/bash

repeat()
{
	while true # the code within the loop will be executed until it gets a successful output ... anyway ... this is good for wget -c or curl -O
	do
		$@ && return
	done
}

repeat $1 # the script calls the function passing an argument (command) written when executing script
# eg : bash repeat_comm_F.sh wget -c http://url.download.now.com
