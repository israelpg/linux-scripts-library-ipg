def create_counter(n):
    nonlocal sum
    def counter():
        ''' Just adding a sum '''
        for count in range (1, 11):
            sum += count
        return sum

    return counter

num = int(input('Enter a number: '))
value = create_counter(num)
print(value)
