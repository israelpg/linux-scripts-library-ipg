def checkingFile(filename):
    # searching linux filename ... true found, false not found
    foundToken = True
    return foundToken

fileToSearch = input('Please, enter a filename: ')
if checkingFile(fileToSearch) == True:
    print('Found!')
else:
    print('Not found')
