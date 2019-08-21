word = input('Please, enter a word: ')
count = 0

for letter in word:
    if letter == 'A' or letter == 'a' or letter == 'E' or letter == 'e' or letter == 'I' or letter == 'i' or letter == 'O' or letter == 'o' \
            or letter == 'U' or letter == 'u':
            count+=1

print('The number of vowels is: ', count)
