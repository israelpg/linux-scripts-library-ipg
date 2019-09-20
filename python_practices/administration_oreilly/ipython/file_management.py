# Example: Listing only files (not dirs):

In [329]: ls -lah
total 0
drwxrwxr-x.  3 israel israel 100 Sep 20 17:03 ./
drwxrwxrwt. 24 root   root   540 Sep 20 16:48 ../
-rw-rw-r--.  1 israel israel   0 Sep 20 17:03 1-test.txt
-rw-rw-r--.  1 israel israel   0 Sep 20 17:03 2-test.txt
drwxrwxr-x.  2 israel israel  40 Sep 20 17:03 dir-test/

In [330]: content = !ls

In [331]: content
Out[331]: ['1-test.txt', '2-test.txt', 'dir-test']

In [332]: listFiles = content.grep(os.path.isfile)

In [333]: listFiles
Out[333]: ['1-test.txt', '2-test.txt']

# for dirs:
In [334]: listDirs = content.grep(os.path.isdir)

In [335]: listDirs
Out[335]: ['dir-test']

