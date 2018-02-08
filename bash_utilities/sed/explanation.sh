# printing from one line to another passing regex as argument: sed

$ sed -n '/^# israel-manual-config-start/,/^# israel-manual-config-end/ p' apache2.conf

# The output displays lines from label indicating start to label indicating end (my code in file)

# If you have these labels ... you can get the line numbers by using grep -n

$ grep -n 'israel' apache2.conf

# Then you can use sed passing line numbers as arguments, instead of regex:

$ sed -n '122,126 p' apache2.conf
$ sed -n '181,188 p' apache2.conf

# but you see, 3 lines instead of one ... the grep command, and two sed ... better first option!

## to make a permanent deletion, use option -i :

sed -i '2d' file.txt
