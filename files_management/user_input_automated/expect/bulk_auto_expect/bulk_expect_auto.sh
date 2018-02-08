#!/bin/bash

for i in {1..10}
do
	num="$i"
	name="user-$1"
	./automate_expect.sh $num $name
done
