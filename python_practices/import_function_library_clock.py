#!/bin/bash

from time import clock

start_time = clock()
sum = 0

for n in range(0,100):
    sum += 1

elapsed_time = clock() - start_time

print('Sum is = ', sum, ' and elapsed time was: ', elapsed_time)
