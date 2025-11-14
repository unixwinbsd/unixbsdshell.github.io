---
title: Enabling the Python WSGI Module for Apache on a FreeBSD Server
date: "2025-09-18 07:45:51 +0100"
updated: "2025-09-18 07:45:51 +0100"
id: python-wsgi-module-for-apache-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/FreeBSD-WSGI-Application.jpg
toc: true
comments: true
published: true
excerpt: mod_wsgi is an Apache HTTP Server module that embeds Python applications within the server and allows them to communicate via the Python WSGI interface, as defined in Python PEP 333. WSGI is one way for Python to produce high-quality, high-performance web applications
keywords: python, wsgi, module, apache, web server, freebsd, nginx, mod, enable
---

The mod_wsgi module package implements an easy-to-use Apache module that can host Python-based web applications, with Python WSGI support. This module is suitable for hosting high-performance websites and can also be used for personal websites or self-hosted blogs running on web hosting services.

mod_wsgi is an Apache HTTP Server module that embeds Python applications within the server and allows them to communicate via the Python WSGI interface, as defined in Python PEP 333. WSGI is one way for Python to produce high-quality, high-performance web applications.

WSGI provides a standard way to seamlessly connect different web applications. Several well-known Python applications or frameworks provide WSGI for easy deployment and embedding. This means we can embed a Django-powered personal blog and a Trac project into a single Pylons application, wrapping it to handle, for example, authentication without changing the previous one.

WSGI (Web Server Gateway Interface) is a simple method for a web server to forward requests to a web application or framework written in Python. WSGI is a specification that describes how web servers communicate with web applications. Mod_wsgi is an Apache module used to serve Python scripts over HTTP.

mod_wsgi is an Apache HTTP Server module created by Graham Dumpleton that provides a WSGI-compliant interface for hosting Python-based web applications on Apache. Since version 4.5.3, mod_wsgi supports Python 2 and 3 (since 2.6 and 3.2). It is an alternative to mod_python, CGI, and FastCGI solutions for integrating Python and the web. mod_wsgi was first available in 2007.

This article will show you how to install the Apache mod_wsgi module on a FreeBSD system. We will also explain how to create a Python file and run it on the Apache24 web server.

<br/>
<img alt="FreeBSD WSGI Application" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/FreeBSD-WSGI-Application.jpg' | relative_url }}">
<br/>

## 1. Process of Installing mod_wsgi on FreeBSD

To run mod_wsgi on the Apache24 web server, we first need to install it. On FreeBSD, there are two ways to install mod_wsgi. In this article, we'll install mod_wsgi using the ports system on FreeBSD. The mod_wsgi implementation in this article uses FreeBSD 13.2, which has Apache24, Python39, PHP8, and mods and extensions installed. Another PHP module you'll need to install to run mod_wsgi is PHP_FPM.

Here's how to install mod_wsgi on a FreeBSD system.

```yml
root@ns1:~ # cd /usr/ports/www/mod_wsgi4
root@ns1:/usr/ports/www/mod_wsgi4 # make install clean
```

After the installation process is complete, mod_wsgi is not immediately active. We need to enable the wsgi module on the Apache24 web server.


## 2. Enable mod_wsgi on Apache24
On a web server, the wsgi module can be placed in the httpd.conf file or created separately in the /usr/local/etc/apache24/modules.d folder. In this article, we will create a separate file for the wsgi module.

The first step is to create a wsgi file named "270_mod_wsgi.conf" and place it in the /usr/local/etc/apache24/modules.d folder. The "270_mod_wsgi.conf" file contains the module script to enable mod_wsgi on the Apache24 web server.

Here's how to create the `/usr/local/etc/apache24/modules.d/270_mod_wsgi.conf` file and include the script there, as in the example below.


```console
root@ns1:~ # touch /usr/local/etc/apache24/modules.d/270_mod_wsgi.conf
root@ns1:~ # ee /usr/local/etc/apache24/modules.d/270_mod_wsgi.conf
LoadModule wsgi_module        libexec/apache24/mod_wsgi.so
```

The first script in the command above creates the file `"270_mod_wsgi.conf"`, and the second script includes the wsgi_module in the `"270_mod_wsgi.conf"` file.

Then we continue by creating the `/usr/local/www/apache24/wsgi` folder.

```yml
root@ns1:~ # mkdir -p /usr/local/www/apache24/wsgi
```


Grant `www:www` user and group rights to the folder.


```yml
root@ns1:~ # chown -R www:www /usr/local/www/apache24/wsgi
```

After that, we edit the file `/usr/local/etc/apache24/httpd.conf` and enter the script below.

```console
root@ns1:~ # ee /usr/local/etc/apache24/httpd.conf
<Directory /usr/local/www/apache24/wsgi/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        Options +ExecCGI
        SetHandler wsgi-script
</Directory>
Alias /wsgi "/usr/local/www/apache24/wsgi/"
```

The above script can be placed at the very bottom of the `/usr/local/etc/apache24/httpd.conf` file.


## 3. Run mod_wsgi on Apache24

Once everything is configured correctly, it's time to test or run mod_wsgi to see if it works on the Apache24 web server. To facilitate testing, we'll create a Python file named `"/usr/local/www/apache24/wsgi/sample.py"` Here's how to create it.

```yml
root@ns1:~ # touch /usr/local/www/apache24/wsgi/sample.py
root@ns1:~ # chown -R www:www /usr/local/www/apache24/wsgi/sample.py
root@ns1:~ # chmod -R 777 /usr/local/www/apache24/wsgi/sample.py
```

In the python file `/usr/local/www/apache24/wsgi/sample.py"`, we enter the script as follows.

```console
root@ns1:~ # ee /usr/local/www/apache24/wsgi/sample.py
def application(environ, start_response):
    status = '200 OK'
    output = b'Selamat! Anda Telah Berhasil Menjalankan Modul wsgi Pada Web Server Apache24.'

    response_headers = [('Content-type', 'text/plain'),
                        ('Content-Length', str(len(output)))]
    start_response(status, response_headers)

    return [output]
```

After the python file `"/usr/local/www/apache24/wsgi/sample.py"` is successfully created, we restart Apache24 so that it can load the wsgi module.

```yml
root@ns1:~ # service apache24 restart
```

Next, open your Google Chrome, Yandex, or Firefox web browser. In the address bar, type `http://192.168.5.2/wsgi/sample.py` and view the results. If your Google Chrome browser displays "Congratulations! You have successfully run the wsgi module on the Apache24 web server," you have successfully run the wsgi module on the Apache24 web server.

WSGI is derived from CGI. In this article, we will introduce a WSGI implementation in Python using Apache24 mod_wsgi. You can also implement the WSGI module in conjunction with Django to create blogs, both large and small.