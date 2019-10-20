#!/usr/bin/python3

import sys

if __name__ == "__main__":
    print ('Starting with the list')
    list1 = ['A', 'B', 'C', 'D']
    for iteration, name in enumerate(list1):
        print ("Iteration %d name %s" % (iteration, name))
        #print ("Iteration {iteration} Name {name}".format(iteration=iteration, name=name))
    
    dict1 = {'Israel': 10, 'Natasa': 6, 'Ankica': 7}
    for name, count in dict1.items():
        print ("Name is %s | Count: %d" % (name, count)) 
