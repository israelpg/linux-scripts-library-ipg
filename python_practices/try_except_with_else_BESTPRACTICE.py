In [72]: def divide(x, y):
    ...: ...     try:
    ...: ...         result = x / y
    ...: ...     except ZeroDivisionError:
    ...: ...         print("division by zero!")
    ...: ...     else:
    ...: ...         print("result is", result)
    ...: ...     finally:
    ...: ...         print("executing finally clause")
    ...: ...
    ...: >>> divide(2, 1)
    ...: 
('result is', 2)
executing finally clause

