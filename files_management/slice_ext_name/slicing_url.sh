#!/bin/bash

# using the awk command, to just get example.com:

echo 'http://example.com/index.php' | awk -F/ '{print $3}'

# with $4 we can get index.php from the url:

echo 'http://example.com/index.php' | awk -F/ '{print $4}'

