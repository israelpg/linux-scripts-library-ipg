''' Open an existing file, and create a new one with same content but upper()  '''

def read_original():
    with open('texto.txt', 'r') as in_file:
        with open('upper2_' + 'texto.txt', 'w') as out_file:
            for line in in_file:
                line = line.strip().upper()
                out_file.write(line + '\n')

read_original()
