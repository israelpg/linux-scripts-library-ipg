import subprocess

cmd = "date"

# returns output as byte string
returned_output = subprocess.check_output(cmd)

# using decode() function to convert byte string to string
print('Current date is:', returned_output.decode("utf-8"))

# with arguments:
returned_output2 = subprocess.check_output(['ls','-lah'])
print('Current date is:', returned_output2.decode("utf-8"))
