#!/bin/bash

function execution()
{
	echo 'executing command $@'

	$1 && sleep 3

	echo 'done!'
}

execution $1
