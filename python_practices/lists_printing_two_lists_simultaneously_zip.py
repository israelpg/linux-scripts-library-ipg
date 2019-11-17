In [74]: bikes = ['thunderbird' , 'Pulsar' , 'R15' , 'Duke']

In [75]: speed = ['142' , '135' , '137' , '145']

In [76]: for bike, maxspeed in zip(bikes , speed):
    ...:     print(bike, maxspeed)
    ...:     
('thunderbird', '142')
('Pulsar', '135')
('R15', '137')
('Duke', '145')

# another cool example with zip for listing simulteanously two lists:

In [77]: playersPistons = ['Griffin', 'Kennard', 'Drummond']

In [78]: relatedPPG = [26, 18, 17.4]

In [79]: for player, ppg in zip(playersPistons, relatedPPG):
    ...:     print ("This player {namePlayer} averages {thisPPG}".format(namePlayer=player, thisPPG=ppg))
    ...:
This player Griffin averages 26
This player Kennard averages 18
This player Drummond averages 17.4

