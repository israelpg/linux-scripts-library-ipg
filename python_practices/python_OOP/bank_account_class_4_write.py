#!/usr/bin/python3

# Calling script passing Account Number (existing in accounts.txt) as argument $1
# example: python3 bank_account_class_3.py BE9310001000

import sys
import os
import subprocess
import mmap
import re

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
    def record(self):
        return self.balance

def main():
    sys.stdout.flush()
    subprocess.call(['clear'])
    
    # Customer introduces Bank Card, the machine reads the Account Number
    if len(sys.argv) < 2:
        print('Not a valid Bank Card, cannot read your Account Number')
        print('You should call the script passing one argument as Bank Account, check accounts.txt')
        os._exit(0)
    else:
        global accountNumber
        accountNumber = sys.argv[1]
        dateTime = os.popen('date').read()
        print('System Date: ', dateTime)
        print('Hello, and welcome to IP Bank client', accountNumber)
        print('Proceeding with your Account Login validation...')
        validateAccount(accountNumber)
    
    print('Loading current balance...')
    global myAccount
    myAccount = BankAccount(currentBalance)
    print("You can now operate with your account.")
    manageAccount()

def validateAccount(accountNumber):
    try:
        if os.path.isfile("accounts.txt"):
            with open("accounts.txt", "r") as accountsFile, \
                mmap.mmap(accountsFile.fileno(), 0, access=mmap.ACCESS_READ) as s:
                #if s.find(b'BE9310001000') != -1: # hardcoded
                s1 = str(s, encoding = 'utf-8') # converting object s to string named s1
                if s1.find(accountNumber) != -1:                
                    print('Valid Account Number detected in the system, welcome', accountNumber)
                    # getting line number for this account, to get recorded PIN to contrast with the typedPIN
                    for num, line in enumerate(accountsFile, 1):
                        if accountNumber in line:
                            global recordedPIN 
                            global currentBalance
                            recordedPIN = line.split("|")[1].strip()
                            currentBalance = int(line.split("|")[2].strip())
                            
                    inputPIN()
                else:
                    print('Not a valid Account Number')
                    os._exit(0)

                if typedPIN.strip() == recordedPIN:
                    print('Valid PIN')
                else:
                    print('Invalid PIN')
                    os._exit(0)
        else:
            print('Sorry, it seems we have a system error checking Accounts List, Bank not operative.')
            os._exit(1)
    except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            os._exit(1)
    except ValueError:
            print ("There was an error")
            raise
    except IOError as e:
            print ("I/O error({0}): {1}".format(e.errno, e.strerror))
            raise
    except:
            print ("Unexpected error:", sys.exc_info()[0])
            raise
    finally:
            accountsFile.close()

def inputPIN():
    while True:
        try:
            global typedPIN
            typedPIN = input('Type PIN code or e for exit: ')
            if not typedPIN:
                print('You haven\'t typed a valid PIN code')
                continue
            elif typedPIN == "e":
                print("Goodbye client")
                os._exit(0)
            elif re.findall(r"[0-9]{4}", typedPIN):
                print('Checking PIN number')
                break
            else:
                print('You haven\'t typed a valid PIN code')
                continue
        except ValueError as e:
            print(e)
        except IOError as e:
            print ("I/O error({0}): {1}".format(e.errno, e.strerror))
            raise
        except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            os._exit(1)
        except:
            print ("Unexpected error:", sys.exc_info()[0])
            raise

def manageAccount():
    while True:
        try:
            optionUser = input('Type c for checking balance, d for deposit money, w for withdraw or e for exit: ')
            if not optionUser:
                print('You haven\'t typed a valid option')
                continue
            elif optionUser == "c":
                myAccount.check()
                print('Overdrawn Status is: ')
                print (myAccount.overdrawn())
            elif optionUser == "d":
                amount = eval(input('Amount: '))
                myAccount.deposit(amount)
                print('New balance: ')
                myAccount.check()
                print('Overdrawn Status is: ')
                print (myAccount.overdrawn())
            elif optionUser == "w":
                amount = eval(input('Amount: '))
                myAccount.withdraw(amount)
                print('New balance: ')
                myAccount.check()
                print('Overdrawn Status is: ')
                print (myAccount.overdrawn())
            elif optionUser == "e":
                global newAmount
                newAmount = myAccount.record()
                print('Exiting with new amount: ', newAmount)
                print('Past Balance', currentBalance)
                print('Difference: ', newAmount - currentBalance)
                recordAccount(newAmount)
                print('Goodbye client')
                break
        except ValueError as e:
            print(e)
        except IOError as e:
            print ("I/O error({0}): {1}".format(e.errno, e.strerror))
            raise
        except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            os._exit(1)
        except:
            print ("Unexpected error:", sys.exc_info()[0])
            raise

    sys.exit()

def recordAccount(newAmount):
    try:
        if os.path.isfile("accounts.txt"):
            f = open('accounts.txt', 'r')
            lines = f.readlines()
            f.close()
            for i, line in enumerate(lines):
                if line.split('|')[0].strip(' \n') == accountNumber:
                    lines[i] = str(accountNumber) + '|' + str(recordedPIN) + '|' + str(newAmount) + ' \n'
            f = open('accounts.txt', 'w')
            f.write("".join(lines))
        else:
            print('Sorry, it seems we have a system error checking Accounts List, Bank not operative.')
            os._exit(1)
    except KeyboardInterrupt:
        print ("You pressed Ctrl+C")
        os._exit(1)
    except ValueError:
        print ("There was an error")
        raise
    except IOError as e:
        print ("I/O error({0}): {1}".format(e.errno, e.strerror))
        raise
    except:
        print ("Unexpected error:", sys.exc_info()[0])
        raise
    finally:
        f.close()            

if __name__ == "__main__":
    main()
