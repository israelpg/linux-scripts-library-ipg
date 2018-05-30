# There are two ways to pass when calling a script. (Ei, this is explanation, check examples in folder)

# Either you pass a normal option:

# script -v

# either you pass an argument besides the option:

# script -f filename1

# in the script, you do the following:
# Using colon after the option which requires an argument:
# in this case, f: indicates that calling script with option -f expects argument (filename)

usage()
{
cat << EOF
script -v for version number
script -h for help
script -f filename
EOF
}

while getopts vhf: OPTION
do
	case $OPTION in
	v)
		echo "Script $0 Version 1.0"
		exit 0
		;;
	h)
		echo "Displaying help"
		usage
		exit 0
		;;
	f)
		filename=$OPTARG
		;;
	esac
done

echo "Filename is ${filename}"
exit 0

# use the two examples in this folder, this is just explanation, does not execute smoothly!!!
