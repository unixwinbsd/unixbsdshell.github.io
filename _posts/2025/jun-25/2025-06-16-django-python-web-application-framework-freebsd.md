---
title: Setup FreeBSD Django Python Web Application Framework
date: "2025-06-16 08:45:23 +0100"
updated: "2025-06-16 08:45:23 +0100"
id: django-python-web-application-framework-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/37FreeBSD%20Django%20MVT%20Diagram.jpg&commit=9b8ece7748271f360ada79e41b78d6b04d15bf86
toc: true
comments: true
published: true
excerpt: Django is a high-level Python web development framework, which follows the model-view-template (MVT) design pattern. Created by experienced web developers, Django can handle the complexities that web developers face, so you can focus on writing applications without having to reinvent the wheel
keywords: framework, django, python, web, application, freebsd, static, generator
---

Django is a high-level Python web development framework, which follows the model-view-template (MVT) design pattern. Created by experienced web developers, Django can handle the complexities that web developers face, so you can focus on writing applications without having to reinvent the wheel.

The main features that Django relies on are simplicity, flexibility, reliability, and scalability. Not only that, another advantage of Django is that it provides all the necessary mechanisms for website programming, access to databases, translations, templates, modules and other features. Django also automatically provides a content administration interface, which eases the process of website creation, updating, and deleting objects. Another advantage is that it can record all actions performed, and provides an interface for managing users and user groups.

As mentioned above, Django follows the MVT framework for web development architecture. The MVT framework is generally very similar to MVC, Model, View, and Controller. Django does this controller work by using templates. To be precise, template files combine HTML and Django Template Language (DTL). Look at the image below.

<br/>
<img alt="FreeBSD Django MVT Diagram" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/37FreeBSD%20Django%20MVT%20Diagram.jpg&commit=9b8ece7748271f360ada79e41b78d6b04d15bf86' | relative_url }}">
<br/>

Django is provided for free and is open source and has a growing and active community that always documents every discussion or latest Django project. In this article we will explain how to create a web application using Django, a popular Python framework. The Django application implementation in this article uses the FreeBSD 13.2 server.


## 1. Install Python Venv

Because Django runs in Python, on FreeBSD we have to run Python with the Virtual Environment (venv) method. Follow the steps below to create a Python Venv.
```console
root@ns3:~ # cd /usr/ports/shells/bash
root@ns3:/usr/ports/shells/bash # make install clean
root@ns3:/usr/ports/shells/bash # cd /usr/ports/databases/py-sqlite3
root@ns3:/usr/ports/databases/py-sqlite3 # make install clean
root@ns3:/usr/ports/databases/py-sqlite3 # cd /usr/ports/graphics/py-pillow
root@ns3:/usr/ports/graphics/py-pillow # make install clean
root@ns3:/usr/ports/graphics/py-pillow # cd /usr/ports/devel/py-pip
root@ns3:/usr/ports/devel/py-pip # make install clean
```
To make it easier for you to understand the Python virtual working environment, we recommend that you read the previous article.

[How to Install Python PIP package manager on FreeBSD](https://unixwinbsd.site/openbsd/install-python-pip-on-openbsd/)

[How To Install FreeBSD Python VENV Virtual Environments and Packages](https://unixwinbsd.site/freebsd/python-wsgi-module-for-apache-on-freebsd/)

To start creating a website with Django you must create a Django working directory. This directory is located in the Python Venv environment and is where all the Python Django files are stored. The commands below will guide you through creating a Django working directory.

```console
root@ns3:~ # mkdir -p /tmp/Django
root@ns3:~ # cd /tmp/Django
root@ns3:/tmp/Django # virtualenv DjangoProject
root@ns3:/tmp/Django # cd DjangoProject
root@ns3:/tmp/Django/DjangoProject #
```

Now you have a Django working directory located in the `/tmp/Django/DjangoProject` directory. Activate Python Venv in that directory.

```console
root@ns3:/tmp/Django/DjangoProject # source bin/activate.csh
(DjangoProject) root@ns3:/tmp/Django/DjangoProject # pip install --upgrade pip
```

The blue shell indicates that you are active in the Python virtual environment.


## 2. Install Django

After you have successfully created a Python virtual environment, the next step is to install Django in the Python virtual environment.

```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject # pip install 'Django>=4,<5'
```

Check the version of Django you installed.

```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject # django-admin --version
4.2.10
```

You have successfully installed Django 4.2.10, next we create a Django website project with the name "FreeBSDWebApp".

```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject # django-admin startproject FreeBSDWebApp
(DjangoProject) root@ns3:/tmp/Django/DjangoProject # cd FreeBSDWebApp
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp #
```

Databases are important in creating a website. In FreeBSD Django the default database is SQLite. Configure SQLite database.

```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp # python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sessions
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
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying sessions.0001_initial... OK
```
After that we create a Django user and password. To make it easier for you, let's define both.
user: `freebsddjango`
password:  `router123`


```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp # python manage.py createsuperuser
Username (leave blank to use 'root'): freebsddjango
Email address: unixwinbsd@gmail.com
Password: router123
Password (again): router123
Superuser created successfully.
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp #
```

Open the **"/tmp/Django/DjangoProject/FreeBSDWebApp/FreeBSDWebApp/settings.py"** file, look for the script "ALLOWED_HOSTS", replace it with the script below.

```
ALLOWED_HOSTS = ['*']
```


## 3. Start Server Django

After you have configured everything, we can immediately start running Django.

```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp # python manage.py runserver 192.168.5.2:3000
```

`192.168.5.2` is the FreeBSD server IP address and port `3000` is the Django port. To see the results, you open Google Chrome and type **"http://192.168.5.2:3000/"**. If there is nothing wrong with the configuration above, Google Chrome will display the image below.


<br/>

![FreeBSD Django Test 1](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/38FreeBSD%20Django%20Test%201.jpg&commit=b9390968b0ce7b1bdba9972c9eb4120993686c52)
<br/>


We try using the user and password that we created above. In Google Chrome type **"http://192.168.5.2:3000/admin"**.

<br/>

![FreeBSD Django login](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/39FreeBSD%20Django%20login.jpg&commit=b8739fc29433b5ab1caa55378fa81d27546bd012)

<br/>

<br/>

![FreeBSD Django administration](https://gitea.com/UnixBSDShell/Web-Static-With-Ruby-Jekyll-Site-NetBSD/raw/branch/main/images/40FreeBSD%20Django%20administration.jpg)

<br/>


## 4. Create a Application

To deepen your understanding of the Django website, we will create a test application.

```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp # python manage.py startapp FreeBSDDjangoApp
```

Open the **"/tmp/Django/DjangoProject/FreeBSDWebApp/FreeBSDDjangoApp/views.py"** file, and enter the script below in the file.

```
from django.shortcuts import render

# Create your views here.

from django.http import HttpResponse
def main(request):
    html = '<html>\n' \
           '<body>\n' \
           '<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">\n' \
           'FreeBSD The Power To Server\n' \
           '</div>\n' \
           '</body>\n' \
           '</html>\n'
    return HttpResponse(html)
```

Open the **"/tmp/Django/DjangoProject/FreeBSDWebApp/FreeBSDWebApp/urls.py"** file, and replace the script in that file with the script below.

```python
"""
URL configuration for FreeBSDWebApp project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('FreeBSDDjangoApp/', include('FreeBSDDjangoApp.urls')),
]
```

In the **"/tmp/Django/DjangoProject/FreeBSDWebApp/FreeBSDDjangoApp"** directory, create a new file called **"urls.py"**.

```console
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp # touch /tmp/Django/DjangoProject/FreeBSDWebApp/FreeBSDDjangoApp/urls.py
```

Enter the script below in the **"/tmp/Django/DjangoProject/FreeBSDWebApp/FreeBSDDjangoApp/urls.py"** file.


```
from django.urls import path
from .views import main

urlpatterns = [
    path('', main, name='home')
]
```

Edit the **"/tmp/Django/DjangoProject/FreeBSDWebApp/FreeBSDWebApp/settings.py"** file, and add the script **'FreeBSDDjangoApp'**,


```
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'FreeBSDDjangoApp',
]
```

Now we run the Django server.

```
(DjangoProject) root@ns3:/tmp/Django/DjangoProject/FreeBSDWebApp # python manage.py runserver 192.168.5.2:3000
```

Open Google Chrome, type **"http://192.168.5.2:3000/FreeBSDDjangoApp/"**. The result will look like the image below.

<br/>
{% lazyload data-src="/img/oct-25/FreeBSDDjangoTestwithwebbrowser.jpg" src="/img/oct-25/FreeBSDDjangoTestwithwebbrowser.jpg" alt="FreeBSD Django Test dengan web browser" %}
<br/>

Even though it is considered a modern website, the process of creating a Django website is not as easy as you might imagine. It took a lot of script configuration to run the Django server. But don't give up, we will try to help you with the next Django article. So stay tuned for the latest articles about Django.