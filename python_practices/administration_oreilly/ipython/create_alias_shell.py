alias c clear

# create an alias which will handle arguments:

In [154]: alias ec echo "|%1|"

In [155]: echo this as argument
this as argument


# several arguments:

In [156]: alias ec2 echo first arg "|%s|" and second arg "|%s|"

In [157]: ec2
UsageError: Alias <ec2> requires 2 arguments, 0 given.

In [158]: ec2 uno dos
first arg |uno| and second arg |dos|

