def get_input():
    global dividend, divisor
    while True:
        try:
            dividend, divisor = eval(input('Please enter a dividend and a divisor like this: dividend, divisor '))
            if divisor == 0:
                print('Error, cannot divide by zero')
                continue
            else:
                break
        except valueError as e:
            print(e)

def main():
    get_input()
    try:
        msg = dividend / divisor
        print(msg)
    except valueError as e:
        print(e)

if __name__ == "__main__":
    main()
