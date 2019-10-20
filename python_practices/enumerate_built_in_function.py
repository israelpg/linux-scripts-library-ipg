In [196]: friends = ['john', 'pat', 'gary', 'michael']
     ...: for name in enumerate(friends):
     ...:     print (name)
     ...:     
     ...:         
(0, 'john')
(1, 'pat')
(2, 'gary')
(3, 'michael')

In [194]: friends = ['john', 'pat', 'gary', 'michael']
     ...: for i, name in enumerate(friends):
     ...:     print ("iteration {iteration} is {name}".format(iteration=i, name=name))
     ...:     
iteration 0 is john
iteration 1 is pat
iteration 2 is gary
iteration 3 is michael

In [195]: friends = ['john', 'pat', 'gary', 'michael']
     ...: for i, name in enumerate(friends):
     ...:     print ("iteration %d is %s" % (i, name))
     ...:         
iteration 0 is john
iteration 1 is pat
iteration 2 is gary
iteration 3 is michael
