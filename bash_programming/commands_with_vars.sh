#!/bin/bash

# Executing commands in bash, passing arguments in vars already declared
# example:

var1="-lah"

ls ${var1}

# output below:

wai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.imgai@02DI20161235444 tests]$ var1="-lah"
[ip14aai@02DI20161235444 tests]$ ls ${var1}
total 5.0M
drwxrwxr-x.  2 ip14aai ip14aai  128 Apr 23 16:05 .
drwx------. 23 ip14aai ip14aai 4.0K Apr 25 17:52 ..
-rw-rw-r--.  1 ip14aai ip14aai  213 Feb 13 17:49 case_optarg.sh
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file2.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file3.txt
-rw-rw-r--.  1 ip14aai ip14aai   86 Apr 23 16:05 file.txt
-rwxr-xr--.  1 ip14aai ip14aai   63 Mar 21 16:05 hardlink1
-rw-rw-r--.  1 ip14aai ip14aai 4.9M Feb  7 18:01 test2.img
-rw-rw-r--.  1 ip14aai ip14aai  49K Feb  7 18:00 test.img
