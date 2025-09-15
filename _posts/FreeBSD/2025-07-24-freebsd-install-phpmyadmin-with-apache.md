---
title: How to Install phpMyAdmin on FreeBSD with Apache24
date: "2025-07-24 07:08:01 +0100"
id: freebsd-install-phpmyadmin-with-apache
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: DataBase
excerpt: phpMyAdmin supports multiple database servers. It can also import data from various formats such as CSV and SQL, and export data to various other formats such as CSV, SQL, XML, PDF, ISO/IEC 26300 - OpenDocument Text and Spreadsheets, Word, Excel, LATEX, and others. This application is free, open-source, and written in PHP
keywords: php, phpmyadmin, apache, web server, database, freebsd, installation, configurtion
---

This article presents a simple tutorial on how to install phpMyAdmin on FreeBSD 13.2 Stable. phpMyAdmin is a free and open-source application written in PHP for managing MySQL and MariaDB tasks such as creating, modifying, deleting, and dropping database tables, as well as executing other database management commands. It supports most MySQL features.

phpMyAdmin supports multiple database servers. It can also import data from various formats such as CSV and SQL, and export data to various other formats such as CSV, SQL, XML, PDF, ISO/IEC 26300 - OpenDocument Text and Spreadsheets, Word, Excel, LATEX, and others. This application is free, open-source, and written in PHP.

This article will not explain how to install the Apache Web Server; you can read the previous article on this blog for how to install Apache. In this article, we assume that our FreeBSD system already has apache24 installed.

To begin installing phpMyAdmin in this tutorial, the tip is to use the FreeBSD system ports. Installing phpMyAdmin using the system port shouldn't be too difficult. Simply follow the steps in this article.


## A. System Specifications
- OS: FreeBSD13.2 Stable
- IP LAN Server: 192.168.9.3
- Apache version: apache24 (In this article we will not discuss it, we will assume it is already installed)
- MySQL version: mysql80-server (In this article we will not discuss it, we will assume it is already installed)
- php version: php82
- phpMyAdmin version: phpMyAdmin5-php82


## B. phpMyAdmin Installation Process
Before we get into the installation process, let me remind you again that this tutorial doesn't cover installing apache24 and mysql80-server. You can read the previous article that covers these two applications. Now, let's start installing phpMyAdmin, but first, you'll need to install php82.


```
root@router2:~ # cd /usr/ports/lang/php82
root@router2:/usr/ports/lang/php82 # make install clean
```
After completing the installation of php82, then we continue by installing phpMyAdmin.

```
root@router2:~ # cd /usr/ports/databases/phpmyadmin5
root@router2:/usr/ports/databases/phpmyadmin5 # make install clean
```
The display below is the display when the phpMyAdmin installation is complete.

```
Installing phpMyAdmin5-php82-5.2.1_1...
===> Creating groups.
Using existing group 'www'.
phpMyAdmin5-php82-5.2.1_1 has been installed into:

    /usr/local/www/phpMyAdmin

Please edit config.inc.php to suit your needs.

To make phpMyAdmin available through your web site, I suggest
that you add something like the following to httpd.conf:

Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"

<Directory "/usr/local/www/phpMyAdmin/">
        Options None
        AllowOverride Limit

        Require local
        Require host .example.com
</Directory>

SECURITY NOTE: phpMyAdmin is an administrative tool that has had several
remote vulnerabilities discovered in the past, some allowing remote
attackers to execute arbitrary code with the web server's user credential.
All known problems have been fixed, but the FreeBSD Security Team strongly
advises that any instance be protected with an additional protection layer,
e.g. a different access control mechanism implemented by the web server
as shown in the example.  Do consider enabling phpMyAdmin only when it
is in use.
===>  Cleaning for php82-ctype-8.2.6
===>  Cleaning for php82-ctype-8.2.6
===>  Cleaning for php82-filter-8.2.6
===>  Cleaning for php82-filter-8.2.6
===>  Cleaning for php82-iconv-8.2.6
===>  Cleaning for php82-iconv-8.2.6
===>  Cleaning for php82-mysqli-8.2.6
===>  Cleaning for php82-mysqli-8.2.6
===>  Cleaning for php82-session-8.2.6
===>  Cleaning for php82-session-8.2.6
===>  Cleaning for php82-xml-8.2.6
===>  Cleaning for php82-xml-8.2.6
===>  Cleaning for php82-xmlwriter-8.2.6
===>  Cleaning for php82-xmlwriter-8.2.6
===>  Cleaning for php82-bz2-8.2.6
===>  Cleaning for php82-bz2-8.2.6
===>  Cleaning for php82-gd-8.2.6
===>  Cleaning for php82-gd-8.2.6
===>  Cleaning for php82-mbstring-8.2.6
===>  Cleaning for php82-mbstring-8.2.6
===>  Cleaning for oniguruma-6.9.8_1
===>  Cleaning for oniguruma-6.9.8_1
===>  Cleaning for php82-zip-8.2.6
===>  Cleaning for php82-zip-8.2.6
===>  Cleaning for libzip-1.9.2
===>  Cleaning for libzip-1.9.2
===>  Cleaning for php82-zlib-8.2.6
===>  Cleaning for php82-zlib-8.2.6
===>  Cleaning for phpMyAdmin5-php82-5.2.1_1
===>  Cleaning for phpMyAdmin5-php80-5.2.1_1
===>  Cleaning for php81-8.1.19
===>  Cleaning for php81-8.1.19
===>  Cleaning for php81-ctype-8.1.19
===>  Cleaning for php81-ctype-8.1.19
===>  Cleaning for php81-filter-8.1.19
===>  Cleaning for php81-filter-8.1.19
===>  Cleaning for php81-iconv-8.1.19
===>  Cleaning for php81-iconv-8.1.19
===>  Cleaning for php81-mysqli-8.1.19
===>  Cleaning for php81-mysqli-8.1.19
===>  Cleaning for php81-session-8.1.19
===>  Cleaning for php81-session-8.1.19
===>  Cleaning for php81-xml-8.1.19
===>  Cleaning for php81-xml-8.1.19
===>  Cleaning for php81-bz2-8.1.19
===>  Cleaning for php81-bz2-8.1.19
===>  Cleaning for php81-gd-8.1.19
===>  Cleaning for php81-gd-8.1.19
===>  Cleaning for php81-mbstring-8.1.19
===>  Cleaning for php81-mbstring-8.1.19
===>  Cleaning for oniguruma-6.9.8_1
===>  Cleaning for oniguruma-6.9.8_1
===>  Cleaning for php81-zip-8.1.19
===>  Cleaning for php81-zip-8.1.19
===>  Cleaning for libzip-1.9.2
===>  Cleaning for libzip-1.9.2
===>  Cleaning for php81-zlib-8.1.19
===>  Cleaning for php81-zlib-8.1.19
===>  Cleaning for phpMyAdmin5-php81-5.2.1_1
root@router2:/usr/ports/databases/phpmyadmin5 #
``````
The above command will appear after the phpMyAdmin installation is complete. Note the red text. Okay, let's continue with the configuration process. Once you've installed phpMyAdmin, copy the `config.sample.inc.php` file into the `/usr/local/www/phpMyAdmin` folder.

```
root@router2:~ # cd /usr/local/www/phpMyAdmin
root@router2:/usr/local/www/phpMyAdmin # cp config.sample.inc.php config.inc.php
```

## C. Edit the httpd.conf file
In this third step, we'll edit the `/usr/local/etc/apache24/httpd.conf` file. Editing this file will provide the URL for accessing phpMyAdmin. Insert the red script above into the httpd.conf file. Place the script below at the very bottom or end of the httpd.conf script.

```
Alias /phpmyadmin "/usr/local/www/phpMyAdmin/"
<Directory "/usr/local/www/phpMyAdmin">
    AllowOverride None
    Options None
    Require all granted
</Directory>
```

## D. Apache24 mod php installation

Now we continue by installing the php mod so that it can run on the apache24 web server.

```
root@router2:~ # cd /usr/ports/www/mod_php82
root@router2:/usr/ports/www/mod_php82 # make install clean

root@router2:~ # cd /usr/ports/databases/php82-mysqli
root@router2:/usr/ports/databases/php82-mysqli # make install clean
```
After the two applications above are installed, we continue by editing the httpd.conf file, in the script below.

```
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
```
Add the `index.php` script, so the script looks like the following.

```
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>
```

Still in the `httpd.conf` file, place the following script at the end or bottom of the httpd.conf file script.

```
LoadModule php_module         libexec/apache24/libphp.so

<FilesMatch "\.php$">
    SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch "\.phps$">
    SetHandler application/x-httpd-php-source
</FilesMatch>
```

Next, we create a php.ini file by copying the php.ini-production file to `php.ini`. This file is located in the `/usr/local/etc` folder.

```
root@router2:~ # cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
```
After that, in the `/usr/local/etc/php.ini` file, we add the following script.

```
extension=mysqli.so
```

Create a new file named info.php and place it in the /usr/local/www/apache24/data folder. In the info.php file, enter the following script **"<?php phpinfo(); ?>"**.

```
root@router2:~ # touch /usr/local/www/apache24/data/info.php
root@router2:~ # ee /usr/local/www/apache24/data/info.php
<?php phpinfo(); ?>
```

After that, test it by typing the URL: `http://192.168.9.3/info.php` in the address bar of Google Chrome or Yandex.

We also tested phpMyAdmin by typing the URL: `http://192.168.9.3/phpmyadmin/` in the Yandex. Browser or Google Chrome.

Use the username and password from the MySQL Server to log in.

![login phpmyadmin](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/login_phpmyadmin.jpg)


Now, if it appears like the image above, it means we've successfully installed phpMyAdmin on the FreeBSD system. To enter the password, use the name and password of the MySQL server we installed previously.