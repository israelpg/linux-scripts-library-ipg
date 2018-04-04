#!/bin/bash

# handle csv files, imported from excel, with "'" as delimiter to separate fields
# file is this: example.csv

#Israel Palomino,CEO,500000,Office
#Juan Berenguel,Financial-Director,500001,Office
#Sami Issa,IT-Director,500002,Office
#Ahmad Issa,Commercial,500003,Client-Premises
#Javier Lara,Chief-Operator,500004,Factory

# keeping the current IFS, which is space 
OLDIFS=$IFS
# defining new IFS, to be ' instead of a new line
IFS=","

# now we can use several elements separated by , instead of just line:
while read user job uid location
do
	echo -e "\e[1;33m$user \
	----------------------\e[0m\n\
	Role: \t $job\n\
	UID: \t $uid\n\
	Location: \t $location\e[0m\n"
done < example.csv

IFS=$OLDIFS


