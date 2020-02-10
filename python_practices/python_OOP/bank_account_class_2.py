#!/usr/bin/python3

class BankAccount(object):
    def __init__(self, initial_balance=0):
        self.balance = initial_balance
    def check(self):
        print('Your balance is: ', self.balance)
    def deposit(self, amount):
        self.balance += amount
    def withdraw(self, amount):
        self.balance -= amount
    def overdrawn(self):
        return self.balance < 0

if __name__ == "__main__":
    while True:
        try:
            firstInput=eval(input('Please, type the amount for first input: '))
            my_account = BankAccount(firstInput)
            break
        except ValueError:
            print('There is an error entering the amount!')
        else: 
            print ('Nothing relevant, try again.')
        finally:
            print ('Good') if my_account.overdrawn() == False else print ('Sh..')
            print ('Your balance is {amount}'.format(amount = my_account.balance))
