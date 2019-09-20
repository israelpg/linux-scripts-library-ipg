import os

inputDir = input('Please enter directory name:')

print('Directory: ', inputDir, ' exists') if (os.path.isdir(inputDir)) else print('Directory: ', inputDir, ' does not exist')
