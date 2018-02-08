#!/bin/bash

# redirects output to a file, normally only the successful result of a command execution (like 1>)

date | tee output.log

# be careful, it redirects to the file, but any content there, will be deleted

# better use -a to append to the content already available in that file:

date | tee -a output.log
