# a good utility is to substitute awk
# for instance, reading a log file, we want to get the first field corresponding to IP
# we indicate the delimiter as space ' ' and get the first attribute:

# nginx log file:
# 47.29.201.179 - - [28/Feb/2019:13:17:10 +0000] "GET /?p=1 HTTP/2.0" 200 5316 "https://domain1.com/?p=1" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36" "2.75"

# equivalent to awk -F ' ' '{print $ }'

ip = line.split(" ")[0]

# last element of a line:

ip = line.split(' ')[-1]

# obviously you can use another delimiter:

line.split('|')[2]
