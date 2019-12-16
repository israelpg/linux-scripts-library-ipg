In [73]: basketScoring = {'fg' : 2, '3p' : 3, 'ft' : 1}
    ...: myScore = { 'fg': 6, '3p': 5, 'ft': 10}
    ...: lastMatch = sum(basketScoring[shot] * myScore[shot]
    ...:                 for shot in myScore)
    ...: print('I scored %d points' % lastMatch)
    ...: 
I scored 37 points

In [74]: prices = {'apple': 0.40, 'banana': 0.50}
    ...: my_purchase = {
    ...:     'apple': 1,
    ...:     'banana': 6}
    ...: grocery_bill = sum(prices[fruit] * my_purchase[fruit]
    ...:                    for fruit in my_purchase)
    ...: print ('I owe the grocer $%.2f' % grocery_bill)
    ...:
I owe the grocer $3.40

## You can also use the items() for the dict:

grocery_bill = sum(prices[thisFruit] * thisQuant for thisFruit, thisQuant in my_purchase.items())