def countdown(num):
    for i in range(num, -1, -1):
        print(i)

countdown(int(input('Please, enter an integer to countdown until 0: ')))
