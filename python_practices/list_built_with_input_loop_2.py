import sys

#def build_list():
#    result = []
#    inputValue = 0
#    while inputValue >= 0:
#        inputValue = eval(input('Please, enter positive value or < 0 to quit: '))
#        if inputValue >= 0:
#            #result += [inputValue]
#            result.append(inputValue)
#   return result

def build_list():
    result = []
    while True:
        try:
            inputValue = int(input('Please, enter integer to be added or < 0 to quit: '))
            if inputValue >= 0:
                result.append(inputValue)
            else:
                break
        except ValueError:
            print('Please, type a number')
        except KeyboardInterrupt:
            print('Exiting script...')
        except:
            print("Unexpected error:", sys.exc_info()[0])
            raise
    return result

def main():
    list1 = build_list()
    print(list1)

if __name__ == "__main__":
    main()
