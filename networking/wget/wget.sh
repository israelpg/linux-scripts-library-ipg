#!/bin/bash

wget http://slynux.org

wget ftp://example_domain.com/somefile.img -O downloaded_file.img -o log

# number of tries

wget -t 5 http://slynux.org

# infinitely until succeed:

wget -t 0 http://slynux.org # or we can use the repeat_command technique with functions!

# restricting speed limit to 20k

wget --limit-rate 20k http://slynux.org

# specify quota, max amount of m downloaded, then it will stop:

wget -Q 100m http://slynux.org

# resuming download in case of interruption:

wget -c http://slynux.org

# complete download / mirroring:

wget -r -N -l -k DEPTH URL

# webs with authentication:

wget --user username --password pass URL
