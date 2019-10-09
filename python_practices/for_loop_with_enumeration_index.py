In [60]: friends = ['john', 'pat', 'gary', 'michael']
    ...: for i, name in enumerate(friends):
    ...:     print ("iteration {iteration} is {name}".format(iteration=i, name=name))
    ...:     
iteration 0 is john
iteration 1 is pat
iteration 2 is gary
iteration 3 is michael

# note that the for loop uses the enumerate bif so that you can use i as index
# en la i va la enumeracion del index de la lista, y en name cada uno de los elementos de la lista

# below the equivalent using % to display the value of each argument:

In [63]: friends = ['john', 'pat', 'gary', 'michael']
    ...: for i, name in enumerate(friends):
    ...:     print ("iteration %d is %s" % (i, name))
    ...:
    ...:
iteration 0 is john
iteration 1 is pat
iteration 2 is gary
iteration 3 is michael

