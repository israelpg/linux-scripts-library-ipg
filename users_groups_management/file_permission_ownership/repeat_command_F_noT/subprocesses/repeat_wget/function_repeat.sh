#!/bin/bash

repeat_wget()
{
while true
	do
		$@ && return
		sleep 10
	done
}

export -f repeat_wget

bash subprocess.sh
