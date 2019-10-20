def build_list():
    result = []
    inputValue = 0
    while inputValue >= 0:
        inputValue = eval(input('Please, enter positive value or < 0 to quit: '))
        if inputValue >= 0:
            #result += [inputValue]
            result.append(inputValue)
    return result

def main():
    list1 = build_list()
    print(list1)

main()
