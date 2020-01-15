# open a file, read each line composed of integers, and multiply each of them by 2

import os
import sys
import subprocess

def main():
     subprocess.call('clear')
     sys.stdout.flush()
     try:
          # opening a file to read its lines (each line is a sequence of numbers)
          if os.path.isfile("listSeqNumbers.txt"):
               f = open("listSeqNumbers.txt", "r")
               if f.mode == "r":
                    content = f.readlines()
                    for line in content:
                         line = line.strip()
                         line2List = list(map(int, line.split()))
                         multiplied = [2*x for x in line2List]
                         print(multiplied)
               else:
                    print('Cannot read file')
          else:
               print('File does not exist')   
     except KeyboardInterrupt:
          print ("You pressed Ctrl+C")
          sys.exit()
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

if __name__ == '__main__':
     main()