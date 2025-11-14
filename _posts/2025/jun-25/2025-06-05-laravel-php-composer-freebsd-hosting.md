---
title: FreeBSD Server for Composer Laravel Hosting - Installation and Configuration
date: "2025-06-05 07:40:05 +0100"
updated: "2025-06-05 07:40:05 +0100"
id: laravel-php-composer-freebsd-hosting
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/oct-25/Installation-Laravel-PHP-on-FreeBSD.jpg
toc: true
comments: true
published: true
excerpt: One of the popular programming languages ​​used in web development is PHP. PHP is a programming language that is widely used to create the most popular CMS platform in the world, namely WordPress. PHP is a back-end programming language or used for server-side development.
keywords: laravel, composer, php, framework, web, blog, freebsd, hosting
---

One of the popular programming languages ​​used in web development is PHP. PHP is a programming language that is widely used to create the most popular CMS platform in the world, namely WordPress. PHP is a back-end programming language or used for server-side development.

When developing a website, one of the important things to consider is choosing the right framework. Frameworks usually contain several code templates and simplify the application development process from previously having to build programming code from scratch to something simpler by utilizing the features in the framework.

That way, the resulting website will be optimal because its features are tailored to your needs. One of the recommended frameworks for creating applications or websites is the Laravel framework.

Laravel has a higher market share among other PHP frameworks. Also, it provides packages for building websites.

<br/>
![metric laravel google trends](/img/oct-25/Installation-Laravel-PHP-on-FreeBSD.jpg)
<br/>

In this article I will explain about installing a web application environment using Laravel installed on FreeBSD 13.2.

## 1. System Requirements
- OS: FreeBSD13.2 Stable.
- LAN Server IP: 192.168.9.3.
- Apache version: apache24 (We will not discuss this in this article, we will assume it is already installed).
MySQL version: mysql80-server (We will not discuss this in this article, we will assume it is already installed).
- php version: php82.
- php mod_fpm.

In this tutorial I will use the FreeBSD pkg tool to install packages, pkg is similar to the package management tools you find in Ubuntu (aptitude) and CentOS (yum) and allows us to install these packages and update them much faster than compiling with the FreeBSD port.


Installation Laravel PHP on FreeBSD


## 2. PHP Installation Process
Because in this tutorial we assume that our FreeBSD server has apache24 and mysql80-server installed, we will immediately install PHP.


```console
root@router2:~ # pkg install php82 mod_php82 php82-mysqli
```
If the above application is already installed, continue with the installation.

```console
root@router2:~ # pkg install php82-gd php82-phar php82-ctype php82-filter php82-iconv php82-curl php82-mysqli php82-pdo php82-tokenizer php82-mbstring php82-session php82-simplexml php82-xml php82-zlib php82-zip php82-dom php82-pdo_mysql php82-ctype
```
If the above application is installed, continue with the `PHP` configuration process.

```console
root@router2:~ # cd /usr/local/etc
root@router2:/usr/local/etc # cp php.ini-production php.ini
```
To make sure OpenSSL works (Composer requires this file when accessing files over the web using SSL), we will create a `cacert.pem` file.

```console
root@router2:~ # cd /etc/ssl
root@router2:/etc/ssl # wget http://curl.haxx.se/ca/cacert.pem
```
Now edit the `php.ini` file located in the `/usr/local/etc` folder and follow the following script:

```
openssl.cafile=/etc/ssl/cacert.pem
cgi.fix_pathinfo=0
```
Then add this script above the script in the `php.ini` file, place it right after the word `[PHP]` or below the word `[PHP]`.

```
listen.owner = www
listen.group = www
listen.mode = 0660
```

### 3. PHP-FPM Configuration
Now we need to "unite" apache24 and PHP, PHP-FPM stands for PHP Fork Process Manager and is the SAPI module that we will use for this installation. The next step is to edit the file `/usr/local/etc/php-fpm.d/www.conf` and activate some scripts like the following example.

```
listen = /var/run/php-fpm.sock
listen.owner = www
listen.group = www
listen.mode = 0660
```
The next step is to create a rc.d startup script for the boot process so that php-fpm can be loaded automatically. Add the `php_fpm_enable="YES"` script to the `/etc/rc.conf` file.

```console
root@router2:~ # ee /etc/rc.conf
php_fpm_enable="YES"
```
The final step in `php-fpm` configuration is to restart the application.

```console
root@router2:~ # service php-fpm restart
Performing sanity check on php-fpm configuration:
[18-Jun-2023 20:19:39] NOTICE: configuration file /usr/local/etc/php-fpm.conf test is successful

Stopping php_fpm.
Waiting for PIDS: 2399.
Performing sanity check on php-fpm configuration:
[18-Jun-2023 20:19:39] NOTICE: configuration file /usr/local/etc/php-fpm.conf test is successful

Starting php_fpm.
root@router2:~ #
```

## 4. PHP Mod Configuration
It should be noted once again, that in this tutorial we assume that the apache24 and mysql80-server applications are already installed on our FreeBSD server, so the httpd.conf file is also available in the `/usr/local/etc/apache24` folder. To activate the PHP module we must edit the **httpd.conf** file and include the PHP module script in the `httpd.conf` file.

The following script is to activate the php module in apache24, place the following script at the very bottom of the `/usr/local/etc/apache24/httpd.conf` file.

```
LoadModule php_module         libexec/apache24/libphp.so

AddType application/x-compress .Z
AddType application/x-gzip .gz .tgz

AddType application/x-httpd-php .php
AddType application/x-httpd-php .php .phtml .php3
AddType application/x-httpd-php-source .phps
```

## 5. Laravel Composer Installation Process
The next step is to install Composer and Laravel. Composer is a package manager for PHP and is widely used by Laravel.

```console
root@router2:~ # curl -sS https://getcomposer.org/installer -o composer-setup.php
root@router2:~ # php composer-setup.php --install-dir=/usr/local/bin --filename=composer
All settings correct for using Composer
Downloading...

Composer (version 2.5.8) successfully installed to: /usr/local/bin/composer
Use it: php /usr/local/bin/composer
root@router2:~ #
```
Test Composer, whether it is RUNNING or not.

```console
root@router2:~ # composer --version
Composer version 2.5.8 2023-06-09 17:13:21
root@router2:~ #
```
If the Composer version appears, it means Composer is RUNNING.

If Composer is RUNNING, we continue by installing Laravel. You can download the Laravel file from the Gihub website. Follow the script below to install Laravel.

```console
root@router2:~ # cd /usr/local/www
root@router2:/usr/local/www # git clone https://github.com/laravel/laravel.git
Cloning into 'laravel'...
remote: Enumerating objects: 34429, done.
remote: Counting objects: 100% (584/584), done.
remote: Compressing objects: 100% (293/293), done.
remote: Total 34429 (delta 325), reused 435 (delta 278), pack-reused 33845
Receiving objects: 100% (34429/34429), 10.43 MiB | 492.00 KiB/s, done.
Resolving deltas: 100% (20330/20330), done.
root@router2:/usr/local/www #
```
Once downloaded, continue with the following script to grant access rights and ownership of Laravel files.

```console
root@router2:~ # chown -R www:www /usr/local/www/laravel/
root@router2:~ # chmod -R g+w /usr/local/www/laravel/
```
If we have done all the steps above, now it's time to install Laravel.

```console
root@router2:~ # cd /usr/local/www/laravel
root@router2:/usr/local/www/laravel # composer install
```
If the composer installation above fails, you can try the script below.

```console
root@router2:~ # cd /usr/local/www/laravel
root@router2:/usr/local/www/laravel # composer install --ignore-platform-req=ext-fileinfo
```
This Laravel application is not only used by Apache Web Server, if you want to combine it with NGINX Laravel can also run well.