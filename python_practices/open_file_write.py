''' Uses Python's file class to store data to and retrieve data from a text file. '''
def load_data(filename):
    with open(filename) as f:
        for line in f:
            print(int(line))

''' Allows the user to store data to the text file named filename. '''
def store_data(filename):
    with open(filename, 'w') as f:
        number = 0
        while number != 999:
            number = int(input('Please enter number (999 quits):'))
            if number != 999:
                f.write(str(number) + '\n')
            else:
                break

def main():
    done = False

    while not done:
        cmd = input('S)ave L)oad Q)uit: ')
        if cmd == 'S' or cmd == 's':
            store_data(input('Enter file name:'))
        elif cmd == 'L' or cmd == 'l':
            load_data(input('Enter filename:'))
        elif cmd == 'Q' or cmd == 'q':
            done = True
        else:
            print('Wrong input, please type a valid option.')
            continue

if __name__ == '__main__':
    main()
