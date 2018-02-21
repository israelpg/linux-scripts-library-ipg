#!/bin/bash

# good source here: https://www.thegeekstuff.com/2010/06/bash-array-tutorial/
# NOTE! @ and * are used the same way, you may choose mate

# declare an array:
array_test1=(2 4 6 8 10)
# index starts with 0, eg: index 0 is --> 2

# display an element in order x, eg element in positio index 3:
echo ${array_test1[3]}

# display all elements:
echo ${array_test1[*]}
# display specific elements by index, eg: 2 elements starting from position 3
echo ${array_test1[*]:3:2} # --> 8 10

# display all elements with a break line n
echo ${array_test1[@]} | tr ' ' '\n'
# or using a file:
echo ${array_test1[*]} > output_array.txt
cat output_array.txt | tr [':space:'] '\n'

# print the length of an array
echo ${#array_test1[*]}
# print the length of a value
echo ${#array_test1[1]} # if value in index 1 is fedora --> 6

# associate array: index is a defined word by user, instead of regular number value position 0 1 ...
declare -A assoc_array5=([index1]=val1 [index2]=val2)
echo ${assoc_array5[*]}
# index1 es la primera posicion, ergo el value val1
echo ${assoc_array5[index1]}

# nice practical example of assoc arrays:
declare -A fruits_value=([apple]='2eu/kg' [banana]='3.25eu/kg')
echo "The price of apple is: ${fruits_value[apple]}"
echo "The price of banana is: ${fruits_value[banana]}"

# we can get the index list instead of values list
declare -A array_motogp_cvs=([yamaha]=320 [honda]=315)
echo ${!array_motogp_cvs[*]}
# list all items
echo ${array_motogp_cvs[*]}
# list only value for index equals yamaha
echo ${array_motogp_cvs[yamaha]}
# number of values in the array
echo ${#array_motogp_cvs[*]}

# add an element to an existing array:
array1+=('last')
# or:
array1=("${array1[@]}" "newElement" "alsoNew")

# remove an element from an array: this just gives a null:
unset array1[2] # indicating index position 2 in this case
# the correct way is:
Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
pos=3
Unix=(${Unix[@]:0:$pos} ${Unix[@]:$(($pos + 1))})
echo ${Unix[@]}
Debian Red hat Ubuntu Fedora UTS OpenLinux
# explanation: array composed from index 0 with 3 elements, and from index 4 the rest of elements

# substition of one element value for another:
# with this array --> array_linux=(fedora ubuntu mandriva)
array_linux=(${array_linux[@]/ubuntu/red hat}) # ubuntu is substited by red hat in index 1

# copying an array
arraySystems=("${array_linux[@]}")

# concatenation of two bash arrays:
concatenatingArrays=("${arrayLinux[@]}" "${arrayWindows[@]}")
echo ${concatenatingArrays[@]}

# deleting an entire array:
unset arrayWindows
