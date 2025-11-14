---
title: Learn How to Install and Configure Apache Web Server on FreeBSD
date: "2025-06-10 09:07:15 +0100"
updated: "2025-06-10 09:07:15 +0100"
id: install-apache24-web-server-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/menu%20make%20config%20apache.jpg&commit=b967a230b25a4193c76a3b726ea57f841531099b
toc: true
comments: true
published: true
excerpt: Apache web server is a software application that allows you to host websites and web applications over the internet. This web server provides a platform for the Apache HTTP server that handles HTTP requests and responses. If you want to run a website or web application but don't know how to prepare the infrastructure needed to run it, you can use the Apache web server as a starting point.
keywords: apache, web server, http, https, port 80, freebsd, browser
---

In this tutorial, I will show you how to install and configure Apache24 on a FreeBSD server. This tutorial will not guide you how to run Apache24 Web Server on a FreeBSD server. If you haven't already done so, please follow our tutorial on the basic setup for installing Apache24 on FreeBSD. The first thing you need to do to install Apache24 is that you already have a FreeBSD server.


## 💻 Step 1 Apache24 installation

By default, when we have installed the FreeBSD server, if we look at the FreeBSD ports option, there are many versions of the Apache web server. In this tutorial we will use the Apache24 version which we will install on the FreeBSD 13.2 Stable server. I recommend that you use FreeBSD ports to install Apache24, because you can determine what modules will be installed along with Apache24.

```console
root@router2:~ # cd /usr/ports/www/apache24
root@router2:/usr/ports/www/apache24 # make config
root@router2:/usr/ports/www/apache24 # make config-recursive
root@router2:/usr/ports/www/apache24 # make install clean
```

<br/>
![menu make config apache](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/menu%20make%20config%20apache.jpg&commit=b967a230b25a4193c76a3b726ea57f841531099b)
<br/>


## 💻 Step 2 Apache24 configuration

To configure Apache24, we need the file `/usr/local/etc/apache24/httpd.conf`, edit the `httpd.conf` file and make changes according to your needs. The basic thing in editing the httpd.conf file is to enter the script `"ServerName, ServerAdmin and ServerRoot"`, using the domain name on your FreeBSD server. In this tutorial I use the domain "unixexplore.com" on `ports 80 and 443`.

```
ServerName www.unixexplore.com:80
ServerAdmin router@unixexplore.com
ServerRoot "/usr/local"
Listen 192.168.9.3:80
Listen 192.168.9.3:443
```
Also check the "DocumentRoot and ErrorLog" script, adjust the folder location.

```
DocumentRoot "/usr/local/www/apache24/data"
<Directory "/usr/local/www/apache24/data">
ErrorLog "/var/log/httpd-error.log"
CustomLog "/var/log/httpd-access.log" common
```

Then you specify the user name and group that Apache24 will use.


```
User www
Group www
```
To activate the module, you can adjust it according to your needs, for example you will run Apache as a reverse proxy, then activate the proxy module in the httpd.conf file.

Once you are sure that all httpd.conf files have been configured, the next step is to create a startup script in the rc.conf file.

```console
root@router2:~ # ee /etc/rc.conf
apache24_enable="YES"
apache24_http_accept_enable="YES"
apache24_limits_args="-e -C"
```
Create file ownership rights and access rights.

```console
root@router2:~ # chown -R www:www /var/log/httpd-access.log
root@router2:~ # chown -R www:www /var/log/httpd-error.log
root@router2:~ # chown -R www:www /usr/local/www/apache24/
root@router2:~ # chown -R www:www /usr/local/etc/apache24/
root@router2:~ # chmod -R 755 /var/log/httpd-access.log
root@router2:~ # chmod -R 755 /var/log/httpd-error.log
root@router2:~ # chmod -R 755 /usr/local/www/apache24/
```
Now you restart the apache24 program.

```console
root@router2:~ # service apache24 restart
Performing sanity check on apache24 configuration:
Syntax OK
Stopping apache24.
Waiting for PIDS: 1029.
Performing sanity check on apache24 configuration:
Syntax OK
Starting apache24.
root@router2:~ #
```


## 💻 Step 3 Test Apache24

To make sure whether the Apache web server that we have installed and configured can run well, we carry out a test in the Yandex, Chrome or Firefox browser. Now let's try testing via Yandex browser. Type our FreeBSD Server IP, namely http://192.168.9.3 in the Yandex browser. The image below shows the Apache24 test results on the Yandex browser.

Before carrying out the test, you first restart the Apache24 program.

```console
root@router2:~ # apachectl restart
root@router2:~ # service apache24 restart
```
After that you type `http://192.168.9.3` in the Google Chrome or Yandex browser. See the results on your monitor screen.

On your monitor screen the words **It works!** will appear.

This means that you have successfully configured Apache24 on the FreeBSD server. After successfully installing apache24 on the FreeBSD server, you can install other applications that run under apache24 such as WordPress websites. Apache24 can also be used in conjunction with content management systems (Joomla, Drupal, etc.), web frameworks (Django, Laravel, etc.), and other programming languages. In conclusion, Apache is the right choice for all types of web hosting platforms.