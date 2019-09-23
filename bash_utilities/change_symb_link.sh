ln -s /media/files/tb-prod/files files
#-s means to make a symbolic link. To update a link, either delete the link and create it as above, or use the -f option to ln as well. If you are linking to a folder, also include the -n option:

ln -sfn /a/new/path files
