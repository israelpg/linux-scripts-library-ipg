#!/bin/bash

for i in ?.jpg
do

	mv "$i" "${i%.*}.gif"
done
