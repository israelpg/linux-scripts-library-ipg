print('This script counts the number of times letter i/I are present. If phrase contains X will quit and not count anything.')
count = 0
phrase = input('Please, enter a phrase: ')

for letter in phrase:
    if letter == 'i' or letter == 'I':
        count += 1
    elif letter == 'X':
        break

print('The number of letter i in the phrase: ', count)

