In [47]: bikes = ['thunderbird' , 'Pulsar' , 'R15' , 'Duke']

In [48]: type(bikes)
Out[48]: list

In [49]: print("Bikes are :", bikes)
('Bikes are :', ['thunderbird', 'Pulsar', 'R15', 'Duke'])

In [50]: print("Bikes are : %s" %','.join(bikes))
Bikes are : thunderbird,Pulsar,R15,Duke

In [51]: print('Bikes are : ',(" and ".join(bikes)))
('Bikes are : ', 'thunderbird and Pulsar and R15 and Duke')

# Probably the best way in terms of screen output without ( or any other symbols:

In [53]: print("Bikes are : %s" %', '.join(bikes))
Bikes are : thunderbird, Pulsar, R15, Duke

##

In [55]: pistonsPlayers=['Drummond', 'Kennard', 'Griffin']

In [56]: type (pistonsPlayers)
Out[56]: list

In [57]: print (pistonsPlayers)
['Drummond', 'Kennard', 'Griffin']

In [58]: for player in pistonsPlayers:
    ...:     print (player)
    ...:
Drummond
Kennard
Griffin

In [59]: print ("%s" %', '.join(pistonsPlayers))
Drummond, Kennard, Griffin

In [60]:

