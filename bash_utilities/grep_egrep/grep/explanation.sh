# an easy grep, 2 ways:

grep 'pattern' filename

cat filename | grep 'pattern'

grep 'pattern' filename1 filename2 filename3

# print the line number for the matchings:

cat filename | grep -n 'pattern'

# search for a pattern AMONG several files, and listing filename if matches:
grep -l 'pattern' file1 file2

# reading from stdin, using echo -e:

echo -e 'this is a word\nnext line' | grep 'word' # output: this is a word

# regex:
# files are:
ls -l
createbackup.sh		list.sh		lspace.sh	speaker.sh
listopen.sh		lost.sh		rename-file.sh	topprocs.sh
# using regex patterns:
ls -l l* # list.sh, lspace.sh, listopen.sh
ls -l l?st.* # list.sh, lost.sh
ls -l ??st* # list.sh, lost.sh, listopen.sh
ls [clst]* # createbackup.sh, list.sh, lspace.sh, speaker.sh, listopen.sh, lost.sh, topprocs.sh
ls [clst][io]?t* # list.sh, listopen.sh, lost.sh

# ranges:
ls -l users[0-9].txt # users0.txt, users1.txt ...
ls -l filename_[a-cA-C]?t*.log # filename_aptitude.log, filename_Bmtmodules.log ...
ls -l filename_[a-cA-C][0-9][a-cA-C]?t*.log # filename_a9aptitude.log, filename_C5Btmodules.log ...

# to negate, use the ! in front of the regex: ![a-c] ... ![0-5] ...

# regex, uses egrep:
cat filename | egrep '[a-z]+'

egrep '[a-z]+' filename

# egrep as well for many patterns:

cat file1.txt | egrep 'pattern1|pattern2'

# option    -o       displays only the output itself, not the whole line:

echo 'this is a line.' | egrep '[a-z]+\.' # output: line. (note the . )

# to print everything except the matches of the grep or egrep:

cat filename | grep -v 'pattern'

# count number of lines which contain a match:

cat filename | grep -c 'pattern'
grep -c 'pattern' filename

# count number of matches, even if are in the same line, use this trick:

cat filename | grep -o 'pattern' | wc -w
grep -o 'pattern' filename | wc -w
# with -o only getting the pattern itself, and then count lines

# getting the pattern from a file:

echo 'hello this is cool' | grep -f pathfile

# search for patterns recursively in a directory:

grep 'pattern' . -R -n # R for recursive, n to print the line number
# it displays different information, if we want to ls -lah the file itself, we need to remove stuff leaving only dir/filename, and use xargs for multiple files:
[root@02DI20161235444 builds_maven]# grep 'wc -l' -R -n /home/ip14aai/git/workspace_linux_scripts/bash_utilities/
/home/ip14aai/git/workspace_linux_scripts/bash_utilities/basic_stuff_utilities_everyday/check_du_remote_machines.sh:19:	numberLines=$(cat $logfile | wc -l)
/home/ip14aai/git/workspace_linux_scripts/bash_utilities/basic_stuff_utilities_everyday/readLines_redirectionFile2.sh:4:numberLines=$(cat $File | wc -l)
/home/ip14aai/git/workspace_linux_scripts/bash_utilities/wall_message_to_ttys_users/wall_extended_scripted_v2.sh:17:	number_lines=$(cat $check_user | wc -l)
/home/ip14aai/git/workspace_linux_scripts/bash_utilities/xargs/count_lines.sh:3:find . -maxdepth 2 ! -type d -perm 644 -iname '*.c' -print0 | xargs -0 wc -l
[root@02DI20161235444 builds_maven]# grep 'wc -l' -R -n /home/ip14aai/git/workspace_linux_scripts/bash_utilities/ | cut -d ':' -f 1 | xargs -I {} ls -lah {}
-rw-rw-r--. 1 ip14aai ip14aai 1.5K Feb  8 14:10 /home/ip14aai/git/workspace_linux_scripts/bash_utilities/basic_stuff_utilities_everyday/check_du_remote_machines.sh
-rw-rw-r--. 1 ip14aai ip14aai 257 Feb  8 14:10 /home/ip14aai/git/workspace_linux_scripts/bash_utilities/basic_stuff_utilities_everyday/readLines_redirectionFile2.sh
-rw-rw-r--. 1 ip14aai ip14aai 896 Feb  8 14:10 /home/ip14aai/git/workspace_linux_scripts/bash_utilities/wall_message_to_ttys_users/wall_extended_scripted_v2.sh
-rw-rw-r--. 1 ip14aai ip14aai 90 Feb  8 14:10 /home/ip14aai/git/workspace_linux_scripts/bash_utilities/xargs/count_lines.sh


# Including and excluding files in a grep search:

grep 'main()' . -r --include *.{c,cpp} # only matches in files with specified extensions

# Excluding README files:

grep 'main()' . -r --exclude 'README'


# adding lines after , before, or both regarding the pattern matched for seq:

seq 10 | grep '5' -A 3 # add 3 lines after the matching 5

seq 10 | grep '5' -B 2 # before

seq 10 | grep '5' -C 3 # 3 lines after and before

# practical example on above point:
cat filename.txt | grep -i 'israel' -A1 # it will display the occurence line, and the next one
