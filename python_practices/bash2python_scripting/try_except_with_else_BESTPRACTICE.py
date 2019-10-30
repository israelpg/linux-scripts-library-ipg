In [72]: def divide(x, y):
    ...: ...     try:
    ...: ...         result = x / y
    ...: ...     except ZeroDivisionError:
    ...: ...         print("division by zero!")
    ...: ...     except KeyboardInterrupt:
    ...: ...         print "You pressed Ctrl+C"
    ...: ...         sys.exit()
    ...: ...     else:
    ...: ...         print("result is", result)
    ...: ...     finally:
    ...: ...         print("executing finally clause")
    ...: ...
    ...: >>> divide(2, 1)
    ...: 
('result is', 2)
executing finally clause

