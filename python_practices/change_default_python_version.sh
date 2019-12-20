sudo alternatives --install /usr/bin/python python /usr/bin/python3.7 2
sudo alternatives --install /usr/bin/python python /usr/bin/python2.7 2

# then you can list:

sudo alternatives --list | grep -i python
python	auto	/usr/bin/python3.7

# and make sure the default python uses the latest version as a priority:

[israel@w50019045l-mutworld-be /]$ python --version
Python 3.7.5

