def calculation(num):
    return (num * 5)

def main():
    inputNum = eval(input('Please, enter a number: '))
    if calculation(inputNum) > 100:
        print('Higher than 100!')
    else:
        print('Lower than 100!')

main()

