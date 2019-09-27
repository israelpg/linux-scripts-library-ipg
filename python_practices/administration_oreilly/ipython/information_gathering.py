processes = !ps -aux

# pagination:
page processes


# pdef :: Checking the function signature:
In [31]: def sumaNumbers(a,b,c,d):
    ...:     resultado = a+b+c+d
    ...:     return resultado
    ...:

In [32]: sumaNumbers(2,4,6,3)
Out[32]: 15

In [33]: pdef sumaNumbers
 sumaNumbers(a, b, c, d)

# Return function documentation:
pdoc myFunction


