#!/bin/bash

# handle csv files, imported from excel, with "'" as delimiter to separate fields
# file is this: example.csv

#Israel Palomino,CEO,500000,Office
#Juan Berenguel,Financial-Director,500001,Office
#Sami Issa,IT-Director,500002,Office
#Ahmad Issa,Commercial,500003,Client-Premises
#Javier Lara,Chief-Operator,500004,Factory

while read line
do
	echo -e "\e[1;33mUser:\e[0m\t $line\n" | awk -F ',' '{print $1}'
	echo -e "\e[1;33mRole:\e[0m\t $line\n" | awk -F ',' '{print $2}'
	echo -e "\e[1;33mUID:\e[0m\t $line\n" | awk -F ',' '{print $3}'
	echo -e "\e[1;33mLocation:\e[0m\t $line" | awk -F ',' '{print $4}'
	echo ""
done < example.csv



