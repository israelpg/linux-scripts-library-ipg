#!/bin/bash

# here you play around with command response:
function checkCommand()
{
$1
if [ $? == 0 ]
then
	echo "Correct command."
else
	echo "Wrong command"
fi
}

# this command will fail:
checkCommand pepito
# this one will succeed:
checkCommand hostnamectl
