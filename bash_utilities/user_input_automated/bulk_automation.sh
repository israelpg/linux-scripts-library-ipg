#!/bin/bash

for i in {1..10}
do
	echo -e "$i\nuser$i\n" | ./interactive.sh
done
