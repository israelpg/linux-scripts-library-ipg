#!/bin/bash

	echo 'executing command $@'

	$1 && sleep 3

	echo 'done!'
