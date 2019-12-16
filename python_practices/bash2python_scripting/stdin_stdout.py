#!/usr/bin/python3

# stdin to read lines from a file, in combination with bash cat command:

cat logfile.txt | python3 processing_logfile.py

for line in sys.stdin.readlines():
    line = line.strip()
    # more stuff if needed

# stdout ca be used for printing out something in the screen:

sys.stdout.write("This is just a simple text line")

