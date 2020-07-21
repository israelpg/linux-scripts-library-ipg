def help_screen():
    print("Add: Adds two numbers")
    print("Subtract: Subtracts two numbers")
    print("Print: Displays the result of the latest operation")
    print("Help: Displays this help screen")
    print("Quit: Exits the program")

# menu
# Display a menu
# Accepts no parameters
# Returns the string entered by the user.

def menu():
    return input("A)dd S)ubtract H)elp Q)uit ")

def get_input():
    try:
        global arg1 
        arg1 = float(input("Enter arg 1: "))
        global arg2 
        arg2 = float(input("Enter arg 2: "))
    except ValueError:
        print('Please supply numbers')

def calculation(operand):
    global result
    if operand == "Add":
        result = arg1 + arg2
    elif operand == "Substract":
        result = arg1 - arg2
    
    return result

# Runs a command loop that allows users to perform simple arithmetic.

def main():
    while True:
        choice = menu()
        if choice == "A" or choice == "a":
            # Addition
            get_input()
            calculation("Add")
            print(result)
        elif choice == "S" or choice == "s":
            # Subtraction
            get_input()
            calculation("Substract")
            print(result)
        elif choice == "H" or choice == "h":
            help_screen()
        elif choice == "Q" or choice == "q":
            print('Quitting')
            break
        else:
            continue # will ask the choice again, since user's input was not valid

if __name__ == "__main__":
    main()
