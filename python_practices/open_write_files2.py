def load_data(filename):
	with open(filename) as f:
		for line in f:
			print(int(line))

def store_data(filename):
	with open(filename, 'w') as f:
		done = False
		while not done:
			number = int(input('Please enter number (999 quits):'))
			if number != 999:
				f.write(str(number) + '\n') # Convert integer to string to save
			else:
				break

def main():
	done = False
	while not done:
		cmd = input('S)ave L)oad Q)uit: ')
		if cmd == 'S' or cmd == 's':
			store_data(input('Enter file name:'))
		elif cmd == 'L' or cmd == 'l':
			load_data(input('Enter filename:'))
		elif cmd == 'Q' or cmd == 'q':
			done = True

if __name__ == '__main__':
	main()
