# create a virtual environment for your Django project

[israel@w50019045l-mutworld-be first_django_project]$ python3 -m venv env
[israel@w50019045l-mutworld-be first_django_project]$ ls -lah
total 0
drwxrwxr-x. 1 israel israel  6 Dec 19 17:48 .
drwxrwxr-x. 1 israel israel 40 Dec 19 17:48 ..
drwxrwxr-x. 1 israel israel 56 Dec 19 17:48 env

# activate the project as a virtual env

[israel@w50019045l-mutworld-be first_django_project]$ source env/bin/activate
(env) [israel@w50019045l-mutworld-be first_django_project]$

# use the pip python package manager to install django

[israel@w50019045l-mutworld-be first_django_project]$ pip install django --user
Collecting django
  Using cached https://files.pythonhosted.org/packages/6a/23/08f7fd7afdd24184a400fcaebf921bd09b5b5235cbd62ffa02308a7d35d6/Django-3.0.1-py3-none-any.whl
Requirement already satisfied: sqlparse>=0.2.2 in /home/israel/.local/lib/python3.7/site-packages (from django) (0.3.0)
Requirement already satisfied: pytz in /usr/lib/python3.7/site-packages (from django) (2018.5)
Requirement already satisfied: asgiref~=3.2 in /home/israel/.local/lib/python3.7/site-packages (from django) (3.2.3)
Installing collected packages: django
Successfully installed django-3.0.1

## in case of timeout errors, try the following: clone official django git repo in the project's folder
git clone https://github.com/django/django.git
python -m pip install -e django/
##

# now you can create the project:

django-admin.py startproject bitcoin_tracker
# in theory, if well installed, you can also type: django-admin startproject bitcoin_tracker

# and you can create an app:

$ cd bitcoin_tracker
$ python manage.py startapp historical_data

[israel@w50019045l-mutworld-be bitcoin_tracker]$ tree
.
├── bitcoin_tracker
│   ├── asgi.py
│   ├── __init__.py
│   ├── __pycache__
│   │   ├── __init__.cpython-37.pyc
│   │   └── settings.cpython-37.pyc
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── historical_data
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   │   └── __init__.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
└── manage.py

4 directories, 15 files

# Now, to create a model, add this class in historical_data/models.py:

class PriceHistory(models.Model):
    date = models.DateTimeField(auto_now_add=True)
    price = models.DecimalField(max_digits=7, decimal_places=2)
    volume = models.PositiveIntegerField()

# This is the basic model to keep track of Bitcoin prices.

# Also, don’t forget to add the newly created app to settings.INSTALLED_APPS. 
# Open bitcoin_tracker/settings.py and append historical_data to the list INSTALLED_APPS, like this:

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'historical_data',
]

# The other settings are fine for this project. This tutorial assumes that your project is configured 
# to use an SQLite database, which is the default.

## CREATING MIGRATIONS:

[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py makemigrations historical_data
Migrations for 'historical_data':
  historical_data/migrations/0001_initial.py
    - Create model PriceHistory

# Specifying the application name is optional, by default (empty) will create migrations for all apps referenced in settings.py

[israel@w50019045l-mutworld-be bitcoin_tracker]$ tree
.
├── bitcoin_tracker
│   ├── asgi.py
│   ├── __init__.py
│   ├── __pycache__
│   │   ├── __init__.cpython-37.pyc
│   │   ├── settings.cpython-37.pyc
│   │   └── urls.cpython-37.pyc
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── db.sqlite3
├── historical_data
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   │   ├── 0001_initial.py
│   │   ├── __init__.py
│   │   └── __pycache__
│   │       └── __init__.cpython-37.pyc
│   ├── models.py
│   ├── __pycache__
│   │   ├── admin.cpython-37.pyc
│   │   ├── __init__.cpython-37.pyc
│   │   └── models.cpython-37.pyc
│   ├── tests.py
│   └── views.py
└── manage.py

6 directories, 22 files

# Note: You might notice that running the makemigrations command also created the file db.sqlite3, which contains your SQLite database.

# When you try to access a non-existing SQLite3 database file, it will automatically be created.

# This behavior is unique to SQLite3. If you use any other database backend like PostgreSQL or MySQL, you have to create the database 
# yourself before running makemigrations.

# You can take a look at the SQLite3 database:

[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py dbshell
SQLite version 3.26.0 2018-12-01 12:34:55
Enter ".help" for usage hints.
sqlite> .tables
sqlite> 

# Note that .tables does not return anything for now
# This will change when the created migration is applied

## APPLYING MIGRATIONS:

[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, historical_data, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying historical_data.0001_initial... OK
  Applying sessions.0001_initial... OK


# Now we can manage the database, and tables are listed:

[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py dbshell
SQLite version 3.26.0 2018-12-01 12:34:55
Enter ".help" for usage hints.
sqlite> .tables
auth_group                    django_admin_log            
auth_group_permissions        django_content_type         
auth_permission               django_migrations           
auth_user                     django_session              
auth_user_groups              historical_data_pricehistory
auth_user_user_permissions  
sqlite> 

# Now there are multiple tables. Their names give you an idea of their purpose. The migration that you generated 
# in the previous step has created the historical_data_pricehistory table. Let’s inspect it using the .schema command:

sqlite> .schema --indent historical_data_pricehistory
CREATE TABLE IF NOT EXISTS "historical_data_pricehistory"(
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  "date" datetime NOT NULL,
  "price" decimal NOT NULL,
  "volume" integer unsigned NOT NULL CHECK("volume" >= 0)
);
sqlite> 

# you can see that the schema of the historical_data_pricehistory table reflects the fields of the PriceHistory model.

### updating model and make new migration (change of field from int to dec)

    volume = models.DecimalField(max_digits=7, decimal_places=3)

[israel@w50019045l-mutworld-be bitcoin_tracker]$ vim historical_data/models.py 
[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py makemigrations historical_data
Migrations for 'historical_data':
  historical_data/migrations/0002_auto_20191219_1745.py
    - Alter field volume on pricehistory

# Note: The name of the migration file (0002_auto_20181112_1950.py) is based on the current time and will be different 
# if you follow along on your system.

# and now apply migration:

[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, historical_data, sessions
Running migrations:
  Applying historical_data.0002_auto_20191219_1745... OK

# checking the db:

[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py dbshell
SQLite version 3.26.0 2018-12-01 12:34:55
Enter ".help" for usage hints.
sqlite> .schema --indent historical_data_pricehistory
CREATE TABLE IF NOT EXISTS "historical_data_pricehistory"(
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  "date" datetime NOT NULL,
  "price" decimal NOT NULL,
  "volume" decimal NOT NULL
);
sqlite> 

## show all migrations:

[israel@w50019045l-mutworld-be bitcoin_tracker]$ python manage.py showmigrations
admin
 [X] 0001_initial
 [X] 0002_logentry_remove_auto_add
 [X] 0003_logentry_add_action_flag_choices
auth
 [X] 0001_initial
 [X] 0002_alter_permission_name_max_length
 [X] 0003_alter_user_email_max_length
 [X] 0004_alter_user_username_opts
 [X] 0005_alter_user_last_login_null
 [X] 0006_require_contenttypes_0002
 [X] 0007_alter_validators_add_error_messages
 [X] 0008_alter_user_username_max_length
 [X] 0009_alter_user_last_name_max_length
 [X] 0010_alter_group_name_max_length
 [X] 0011_update_proxy_permissions
contenttypes
 [X] 0001_initial
 [X] 0002_remove_content_type_name
historical_data
 [X] 0001_initial
 [X] 0002_auto_20191219_1745
sessions
 [X] 0001_initial


# This lists all apps in the project and the migrations associated with each app. Also, it will put a big X next 
# to the migrations that have already been applied.

## UNAPPLYING MIGRATIONS: ROLLBACK

# If you want to revert the migration 0002_auto_20181112_1950 in your historical_data app, you have to pass 0001_initial 
# as an argument to the migrate command:

manage.py migrate historical_data 0001_initial

Operations to perform:
  Target specific migration: 0001_initial, from historical_data
Running migrations:
  Rendering model states... DONE
  Unapplying historical_data.0002_auto_20181112_1950... OK

# Important note:
# Not all database operations can be completely reverted. If you remove a field from a model, create a migration, and 
# apply it, Django will remove the respective column from the database.
# Unapplying that migration will re-create the column, but it won’t bring back the data that was stored in that column!

# Unapplying a migration does not remove its migration file. The next time you run the migrate command, the 
# migration will be applied again.

rm historical_data/migrations/0002_auto_20181112_1950.py

## NAMING MIGRATIONS WITH OPTION --name :

manage.py makemigrations historical_data --name switch_to_decimals


