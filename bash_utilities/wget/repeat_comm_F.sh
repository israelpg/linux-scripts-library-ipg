#!/bin/bash

repeat()
{
	while true
	do
		$@ && return
	done
}
