cd /tmp
bookmark t

# later, from another directory we want to cd to /tmp:

cd -b t
/tmp

# here it goes:

In [159]: cd /tmp/
/tmp

In [160]: bookmark t

In [161]: cd ~
/home/israel

In [162]: pwd
Out[162]: u'/home/israel'

In [163]: cd -b t
(bookmark:t) -> /tmp
/tmp

# or cd -b[TAB]

# Another way to create a bookmark:

bookmark home /home/israel

# Listing bookmarks:

bookmark -l

In [164]: %bookmark -l
Current bookmarks:
t -> /tmp

In [165]:

# Remove a bookmark

bookmark -d t

# Remove all bookmarks:

bookmark -r
