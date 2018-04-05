#!/bin/bash

# Good to add at the beginning of each bash shell script:
# exiting script due to failure (do not continue execution):
set -o errexit
# exiting if a non-declared var is used:
set -o nounset

# debugging or controlling execution:

bash -v scriptname # verbose: executing while displaying all commands and so on ...
bash -n scriptname # simulates execution, checking syntax
bash -x scriptname # execution with tracing mode, displaying all details, including arguments' values and so on

## Tip: you can declare the execution option (simulation or logging) withing the script iself:
# simulating:
#!/bin/bash -n
# tracing mode:
#!/bin/bash -x

# debugging just a section of the script:
set -n
set -x # finish section: set +x

# declaring a static variable (value does not change, like a constant):
readonly fileName="/var/www/html/report2.html"

# reference env variable with capitals:
PATH="$PATH:/thisnewpath/"

# get script filename:
$0

# arguments: when calling script, e.g.: scriptname arg1 arg2:
$1 # arg1
$2 # arg2

# pid of the script in execution:
$$

# Builtin variables:
# There are some useful builtin variables, like
echo "Last program's return value: $?"
echo "Script's PID: $$"
echo "Number of arguments passed to script: $#"
echo "All arguments passed to script: $@"
echo "Script's arguments separated into different variables: $1 $2..."

# CONDITIONALS

# ARITHMETICS:

-eq
-ne
-gt
-lt
-ge
-le

# NEGATION:
!

# continue execution depending on condition:
&& # 1st command good, then 2n is executed
|| # 1st command wrong, then execute 2nd
function checkFile()
{
	[ -e $1 ] && ls -lah $1 ; let token++
	[ -e $1 ] || echo 'Try again mate'
}

# FUNCTIONS

# define a function

function thisFunction()
{
	# instructions
}

# calling a function passing value or argument in a variable

thisFunction value1
thisFunction $var1

# evaluate command in a function

if (( $? == 0 ))
then
	echo "Correct command"
else
	echo "Wrong command"
fi

## OPERATORS:

# files:

Operator syntax 	Description
-a <FILE> 	True if <FILE> exists. :!: (not recommended, may collide with -a for AND, see below)
-e <FILE> 	True if <FILE> exists.
-f <FILE> 	True, if <FILE> exists and is a regular file.
-d <FILE> 	True, if <FILE> exists and is a directory.
-c <FILE> 	True, if <FILE> exists and is a character special file.
-b <FILE> 	True, if <FILE> exists and is a block special file.
- p <FILE> 	True, if <FILE> exists and is a named pipe (FIFO)
-S <FILE> 	True, if <FILE> exists and is a socket file.
-L <FILE> 	True, if <FILE> exists and is a symbolic link.
-h <FILE> 	True, if <FILE> exists and is a symbolic link.
-g <FILE> 	True, if <FILE> exists and has sgid bit set.
-u <FILE> 	True, if <FILE> exists and has suid bit set.
-r <FILE> 	True, if <FILE> exists and is readable.
-w <FILE> 	True, if <FILE> exists and is writable.
-x <FILE> 	True, if <FILE> exists and is executable.
-s <FILE> 	True, if <FILE> exists and has size bigger than 0 (not empty).
-t <fd> 	True, if file descriptor <fd> is open and refers to a terminal.
<FILE1> -nt <FILE2> 	True, if <FILE1> is newer than <FILE2> (mtime). :!:
<FILE1> -ot <FILE2> 	True, if <FILE1> is older than <FILE2> (mtime). :!:
<FILE1> -ef <FILE2> 	True, if <FILE1> and <FILE2> refer to the same device and inode numbers. :!:

# String tests:

Operator syntax	Description
-z <STRING>	True, if <STRING> is empty.
-n <STRING>	True, if <STRING> is not empty (this is the default operation).
<STRING1> = <STRING2>	True, if the strings are equal.
<STRING1> != <STRING2>	True, if the strings are not equal.
<STRING1> < <STRING2>	True if <STRING1> sorts before <STRING2> lexicographically (pure ASCII, not current locale!). Remember to escape! Use \<
<STRING1> > <STRING2>	True if <STRING1> sorts after <STRING2> lexicographically (pure ASCII, not current locale!). Remember to escape! Use \>

## EVALUATING A VARIABLE:
# In case we evaluate a number:

if (( $COUNT > 10 ))

# or:
while (( COUNT > 10))
do
	echo -e "$COUNT \c"
	sleep 1
	(( COUNT -- ))
done

# In case we evaluate a text variable:

if [[ $var1 == "this" ]]

## EXAMPLES OF OPERATORS:

# argument not provided when calling function, or script itself (bash scriptname arg1):

if [ -z $1 ]
then
    	echo "No argument has been provided, you must specify a package name"
        exit $E_NOARGS
fi

# argument exists or not as file

if [ -e $1 ]
then
	echo "file exists"
else
	echo "does not exist"
fi

# a file exists?

if [ -f /var/www/html/$1 ]
then
	rm $1
fi

# a dir exists?

if [ -d ~/tests/$1 ]
then
	touch $1/file1.txt
fi

## WHILE LOOPS:

while (( COUNT > 10 ))
do
	# instructions
done

# reading line by line a file:
while read line
do

done < /tmp/thisfile.txt
# in case a command returns just one column with values, then you can use for --> for F in $(ls) do ... done

# infinite while loop
while true
do
	# instructions
done

# evaluating wheter the script is called with an argument for -i install or -v version-check
# getopts is useful for this purpose, getopts: usage: getopts optstring name [arg]
while getopts iv name
do
        case $name in
          i)iopt=1;;
          v)vopt=1;;
          *)echo "Invalid arg";;
       	esac
done


# FOR LOOPS

for i in {1..10} # {1..10..2}
do
	#instructions
done

# looping a variable:
for i in $namesList
do
	#instructions
done
# same as:
while [ $token -eq 0 ]
do
	#instructions
done

# continue script .. but out of the loop:
# example:

for F in $(ls)
do
	[[ if ! -f $F ]] && continue # if the result of ls (this line in the loop) is not a file, continue out of loop
	DT=$(stat $F | grep i 'access' | tail -1 | cut -d " " -f2) # if it is a file, then it gets the last access date
	echo "The file $F is $(du -b $F | cut -f1) bytes and was last accessed $DT" # and prints the size and date
done

## repeating command until successful resolution: e.g. calling function repeat with arg cmd="ls -lah": repeat $cmd
function repeat()
{
	while true
	do
		$1 && sleep 10
	done
}

# FILES

# variable references a file:
logfile="diskusage.log"

# Redirections to and from files:

# reading from a file, line by line in a loop (redirection from file to the loop for executing instructions line by line):
# while read line ... < filename
while read line;
do
	# instructions
done< /tmp/remote_hosts_$$.df

# while read line; ... from a command
while read line;
do

done < <(df -h --total | grep -vi filesystem)

# redirecting results of script execution to log file:

(
	# instructions, loops, etc ...
) >> $logfile

# redirecting to log file, but also displaying error 2 in stdout screen 1:
2>&1 | tee -a $pathLog # stdout in the screen, plus tee redirection to log file

# using commands for files with var input: e.g.: awk
resultAwk=$(awk -F '.' '{print $4}' <<< $hostIP)

# installing the script
# make use of the getopts iv name in a loop for evaluating with case, see above
while getopts iv name
do
	case $name in
		i) iopt="install";;
		v) vopt="version";;
		*) echo "error";;
	esac
done

# input from user:
read -p "enter something here: " input

# input password:
read -s "enter your password: " password

# assign values to vars with a single input with a command instead of input:
read -r username pass uid gid comments homedir shell <<< $(cat /etc/passwd | grep "^$username")
echo -e "The username is: $username\n"
...

# terminal with rich text: tput
tput bold
# reset:
tput sgr0

### calling a script from another script:

There are a couple of ways you can do this:

    Make the other script executable, add the #!/bin/bash line at the top, and the path where the file is to the $PATH environment variable. Then you can call it as a normal command.

    Call it with the source command (alias is .) like this: source /path/to/script.

    Use the bash command to execute it: /bin/bash /path/to/script.

The first and third methods execute the script as another process, so variables and functions in the other script will not be accessible.
The second method executes the script in the first script's process, and pulls in variables and functions from the other script so they are usable from the calling script.

In the second method, if you are using exit in second script, it will exit the first script as well. Which will not happen in first and third methods.

