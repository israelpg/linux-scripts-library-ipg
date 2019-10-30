# Scenario: We launch a bash script in nohup & background execution to grep for a pattern
# in a log file. If an event is recorded in the log, this triggers the execution of another
# bash script

#!/bin/bash

tail -fn0 logfile.txt | \
while read line ; do
        echo "$line" | grep -q "trigger"
        if [ $? = 0 ]
        then
        	touch trigger_executed.txt
        fi
done

# you need the logfile.txt as an existing file to read
# then you execute this script:

nohup bash check_logs.sh &

# or:

bash check_logs.sh > /dev/null 2>&1 &

# this will trigger the touch execution:
echo "trigger" >> logfile.txt

