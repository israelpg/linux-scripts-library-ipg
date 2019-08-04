def count_to_n(n):
    for n in range(1, n + 1):
        print(n, end=' ')
    print()

print('Please, enter until which number you want to count: ')
count1 = int(input())
count_to_n(count1)

print('Please, enter another time until which number you want to count: ')
count2 = int(input())
count_to_n(count2)
