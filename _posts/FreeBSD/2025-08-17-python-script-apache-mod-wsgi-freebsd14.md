---
title: Running Python Scripts with Apache and Modules WSGI On FreeBSD 14
date: "2025-08-17 08:21:01 +0100"
id: python-script-apache-mod-wsgi-freebsd14
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: WebServer
excerpt: The wsgi module is often used in Python as a standard way to connect various web applications without any hassle. Some well-known python applications or frameworks provide wsgi for easy deployment and embedding. Look at the image below.
keywords: installation, configuration, python, script, apache, module, mod, wsgi, freebsd, openbsd, linux
---

Apache web server with wsgi module one of the best solutions for hosting Python based web applications. Whether you run a small website like a blog or a professional hosting system. The wsgi module on apache offers high performance capabilities.

The wsgi module is an Apache HTTP Server module created by Graham Dumpleton. This module provides a WSGI-compliant interface for hosting Python-based web applications on the Apache web server. The wsgi module is a bridge that Python uses to communicate with the NGINX or Apache web server. WSGI also uses Python to produce high-quality, high-performance web applications.

The wsgi module is often used in Python as a standard way to connect various web applications without any hassle. Some well-known python applications or frameworks provide wsgi for easy deployment and embedding. Look at the image below.

![diagram wsgi apache](https://raw.githubusercontent.com/unixwinbsd/unixshellbsd.github.io/refs/heads/master/Image/18diagram%20wsgi%20apache.jpg)


We have made all the script examples in this article not too complicated, so you can easily understand them even if you are new to Python. To benefit your learning, follow every instruction in this article..


## 1. System Requirements

- OS: FreeBSD 13.2
- IP address: 192.168.5.2
- Hostname: ns3
- Python version: python39
- Web Server: Apache24
- Module: mod_wsgi
- PHP-FPM


## 2. Install mod_python On Apache

Before you start activating the wsgi module, make sure the Apache server and PHP-FPM are installed correctly on FreeBSD. If you are sure that the Apache server is running normally, run the command below to start installing the wsgi module.

```
root@ns3:~ # cd /usr/ports/www/mod_wsgi4
root@ns3:/usr/ports/www/mod_wsgi4 # make install clean
```

After that, you activate mod_wsgi in Apache24.  
`(/usr/local/etc/apache24/modules.d)`

```
root@ns3:~ # touch /usr/local/etc/apache24/modules.d/270_mod_wsgi.conf
root@ns3:~ # ee /usr/local/etc/apache24/modules.d/270_mod_wsgi.conf
LoadModule wsgi_module        libexec/apache24/mod_wsgi.so
```
Create a new directory called `"wsgi"`, this directory we will use to store all Python files.

```
root@ns3:~ # mkdir -p /usr/local/www/apache24/wsgi
root@ns3:~ # chown -R www:www /usr/local/www/apache24/wsgi
root@ns3:~ # chmod -R 775 /usr/local/www/apache24/wsgi
```

Open the `httpd.conf file`, and type the script below in the file.


```
###/usr/local/etc/apache24/httpd.conf

<Directory /usr/local/www/apache24/wsgi/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        Options +ExecCGI
        SetHandler wsgi-script
</Directory>
Alias /wsgi "/usr/local/www/apache24/wsgi/"
```


## 3. WSGI Application

The first wsgi application that we create is called `"pythonwsgi.py"`, then you type the following script in that file.

`(/usr/local/www/apache24/wsgi/pythonwsgi.py)`

```
root@ns3:~ # touch /usr/local/www/apache24/wsgi/pythonwsgi.py
root@ns3:~ # ee /usr/local/www/apache24/wsgi/pythonwsgi.py

def application(environ, start_response):
    status = '200 OK'
    output = b'Hello FreeBSD The Power To Server!'

    response_headers = [('Content-type', 'text/plain'),
                        ('Content-Length', str(len(output)))]
    start_response(status, response_headers)

    return [output]
```

Do a test on the file, by opening Google Chrome, and typing the url `"http://192.168.5.2/wsgi/sample.py"`, and you will get the reply "Hello FreeBSD The Power To Server!".

Once you have successfully installed and configured the Python files with Apache mod_wsgi, we will show, the diagram below illustrates the relationship between the Python wsgi application and other entities.

![FreeBSD WSGI Application](https://raw.githubusercontent.com/unixwinbsd/unixshellbsd.github.io/refs/heads/master/Image/18FreeBSD%20WSGI%20Application.jpg)


Then you create another `pythonApp.py` file, type the script below in the `pythonApp.py` file.

`(/usr/local/www/apache24/wsgi/pythonApp.py)`

```
root@ns3:~ # touch /usr/local/www/apache24/wsgi/pythonApp.py
root@ns3:~ # ee /usr/local/www/apache24/wsgi/pythonApp.py

def application(environ, start_response):
    status = '200 OK'

    if environ['REQUEST_METHOD'] == 'GET' :
        rdict = handle_get(environ)
    elif environ['REQUEST_METHOD'] == 'POST' :
        rdict = handle_post(environ)
    else :
        rdict = { "name": "", "price": 0 }

    output = bytes(json.dumps(rdict), 'utf-8')

    response_headers = [('Content-type', 'application/json'),
                        ('Content-Length', str(len(output)))]
    start_response(status, response_headers)

    return [output]
```

Create index.html and post.html files.

- **/usr/local/www/apache24/data/index.html**

```
root@ns3:~ # touch /usr/local/www/apache24/data/index.html
root@ns3:~ # ee /usr/local/www/apache24/data/index.html

<!DOCTYPE html>
<html>
<body>
<form action="http://192.168.5.2/wsgi/pythonApp.py" method="get" enctype="multipart/form-data">
    <input type="hidden" name="id" value="A001">
    <input type="submit" value="List Product A001 Info">
</form>
</body>
</html>
```

- **/usr/local/www/apache24/data/post.html**

```
root@ns3:~ # touch /usr/local/www/apache24/data/post.html
root@ns3:~ # ee /usr/local/www/apache24/data/post.html

<!DOCTYPE html>
<html>
<body>
<form action="http://192.168.5.2/wsgi/pythonApp.py" method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" value="A002">
    <input type="submit" value="List Product A002 Info">
</form>
</body>
</html>
```
Now try running the two html files, by opening the Google Chrome web browser. In the Google Chrome address bar menu, type `"http://192.168.5.2/index.html"` and `"http://192.168.5.2/post.html"`. See the results displayed on your monitor screen.

Happy! You have successfully created a Python application with the wsgi module. WSGI comes from CGI. In this article, we have explained a Python implementation of WSGI using Apache mod_wsgi. Remember, each application may require additional configuration adjustments based on its specific needs, so always consult your application documentation for more detailed setup instructions.