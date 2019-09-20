import os

inputDir = input('Please enter directory name:')

if (os.path.isdir(inputDir)):
    print('Directory: ', inputDir, ' exists')
else:
    print('Directory: ', inputDir, ' does not exist')
