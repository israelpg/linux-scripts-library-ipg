def countdown(num):
    for i in range(num, -1, -1):
        print(i)

def main():
    while True:
        try:
            countdown(int(input('Please, enter an integer to countdown until 0: ')))
            break
        except ValueError:
            print('Error, please enter a number.')
            continue

if __name__ == "__main__":
    main()