#/bin/bash

# j is for using bz2, c for creating file, v verbose, f archive

tar -jcvf file.tar.bz2 folder_or_filename

# to see files in the compressed file:

tar -tvf file.tar.bz2

# extract

tar -jxvf file.tar.bz2 -C path/extraction_dir

# if tar.gz:

tar -xvzf <filename>.tar.gz -C /thispath/please

# WITHOUT USING BZ2 COMPRESSION:

tar -cvf file.tar filename1 filename2

tar -tvf file.tar

tar -xvf file.tar -C path/extraction_dir # extracts tar content in the specified folder instead of cwd

tar -xvf file.tar file1.img file4.img # extracting specific files, not all of them

# create a tar file excluding specific files:

tar -cvf compressed.tar * --exclude "*.txt"
# or using a file as list:
tar -cvf compressed.tar * -X list # cat list --> file5.img file9.img

# APPEND A FILE TO A COMPRESSED BACKUP FILE: !!! does not work for .bz2, only with tar!!!

tar -rvf archive.tar file_to_append

# Append a file, but only if timestamp is different that already in the compressed file:

tar -uvf compressed.tar file1.img # file1.img will be append if timestamp is different within tar file 

# Concatenate two tar files: File2 will be append to file1

tar -Avf file1.tar file2.tar # now file1.tar contains file2 as well

# delete a file from a compressed tar file:

tar --delete --file archive.tar file1.img

# a nice trick, transfering a compressed tar file as input for ssh connection:

tar -cvf - files/ | ssh ip14aai@192.168.56.101 "tar -xvf -C Documents/"



