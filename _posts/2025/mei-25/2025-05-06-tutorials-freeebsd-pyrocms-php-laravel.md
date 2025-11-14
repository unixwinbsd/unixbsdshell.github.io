---
title: FreeBSD Tutorial Setting Up PyroCMS PHP CMS For Laravel Framework
date: "2025-05-06 20:07:19 +0100"
updated: "2025-05-06 20:07:19 +0100"
id: tutorials-freeebsd-pyrocms-php-laravel
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/10Test%20PyroCMS.jpg&commit=e8ebb8577f6fe1607118d88c7adabf5029e94c8b
toc: true
comments: true
published: true
excerpt: Laravel is one of the most popular web application frameworks for the PHP programming language. It has an expressive and elegant syntax and its development has been an amazing experience
keywords: pyrocms, php, freebsd, laravel, php-fpm, nginx, web server, database, cms, laravel, framework
---

Laravel is one of the most popular web application frameworks for the PHP programming language. It has an expressive and elegant syntax and its development has been an amazing experience. With Laravel, developers can easily build websites quickly and efficiently.

Meanwhile, PyroCMS is built with Laravel and feels like an extension and makes it easy to build better websites and applications quickly. PyroCMS is not only a content management system but also a powerful and modern engine and platform development.

This Content Management System (CMS) is often used by bloggers from beginners to professionals. PyroCMS uses a popular framework so it is easy to understand.

PyroCMS is an open-source object-oriented content management system application built using PHP and Laravel. PyroCMS is easy to use, looks great, and uses some smart caching to keep everything running smoothly. PyroCMS can be easily built with Modules, Widgets, and Plugins that are easy to create and can be customized with Themes.

According to the official PyroCMS website, here are the main features of this CMS.
- Made with PHP language which has proven its quality.
- OPEN SOURCE application.
- Has a very simple Control panel display that is based on standard patterns and principles such as API.
- Responsive Control Panel with easy content management.
- Multilingual support.
- Rapid development.


## 1. System requirements
To run PyroCMS on FreeBSD, you need to meet several conditions.
- OS: FreeBSD 13.2.
- Apache version: Apache24.
- PHP-FPM.
- PHP version: PHP82.
- mod PHP82, PHP82 extension, php82-xmlwriter, php82-xmlreader, php82-fileinfo.
- mysql80-server.

## 2. Enabling mod_PHP on Apache
Since PyroCMS is built with PHP, as the main topic in this article we will enable mod_PHP on Apache24 web server.

Use the following command to start enabling mod_PHP.
```console
root@ns3:~ # cd /usr/ports/lang/php82
root@ns3:/usr/ports/lang/php82 # make install clean
root@ns3:/usr/ports/lang/php82 # cd /usr/ports/www/mod_php82
root@ns3:/usr/ports/www/mod_php82 # make install clean
root@ns3:/usr/ports/www/mod_php82 # cd /usr/ports/databases/php82-mysqli
root@ns3:/usr/ports/databases/php82-mysqli # make install clean
```
```console
root@ns3:~ # pkg install php82-xmlwriter
root@ns3:~ # pkg install php82-xmlreader
root@ns3:~ # pkg install php82-fileinfo
```
After that, type the following script into the file `"/usr/local/etc/apache24/httpd.conf"`.

```html
LoadModule php_module         libexec/apache24/libphp.so

<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

AddType application/x-httpd-php .php
AddType application/x-httpd-php .php .phtml .php3
AddType application/x-httpd-php-source .phps
```

Proceed by creating a php.ini file, just copy it from the existing one.
```console
root@ns3:/usr/ports/databases/php82-mysqli # cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
```
Then you activate the following script.

```
cgi.fix_pathinfo=0
```

In this article we will enable PHP-FPM, with the aim of making the process of reading PHP files faster. We will not discuss the PHP-FPM installation process. You can read the previous article.

Restart PHP-FPM and Apache24, so that all PHP modules can be read by Apache.
```console
root@ns3:~ # service apache24 restart
root@ns3:~ # service php-fpm restart
```

## 3. How to Install PHP Composer
Before we install PHP composer, first enable SSL mod in "/usr/local/etc/php.ini" file. Use the command below to create SSL mod.
```console
root@ns3:~ # cd /etc/ssl
root@ns3:/etc/ssl # wget http://curl.haxx.se/ca/cacert.pem
```
Enter the SSL file that we created above into the file `"/usr/local/etc/php.ini"`.

```
openssl.cafile=/etc/ssl/cacert.pem
```

On FreeBSD, PHP composer can be installed in two ways, namely through the PKG package and curl. For convenience, we simply use Curl.
```console
root@ns3:/etc/ssl # cd /tmp
root@ns3:/tmp # curl -sS https://getcomposer.org/installer -o composer-setup.php
root@ns3:/tmp # php composer-setup.php --install-dir=/usr/local/bin --filename=composer
```
Check the Composer version.
```console
root@ns3:/tmp # composer --version
Composer version 2.6.6 2023-12-08 18:32:26
```

## 4. Creating a MySQL Database
In order for PyroCMS to run perfectly, a database is needed to support it. Okay, now let's move on to creating a database for PyroCMS. Since the one running on our FreeBSD server is a MySQL server, we use the MySQL server as the database.
```console
root@ns3:/tmp # mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.35 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]>
```
**Create a database:**
- database name: `pyrocma`
- username: `userpyrocms`
- Password: `router123`

```console
root@localhost [(none)]> CREATE DATABASE pyrocms CHARACTER SET utf8;
Query OK, 1 row affected, 1 warning (0.13 sec)

root@localhost [(none)]> CREATE USER 'userpyrocms'@'localhost' IDENTIFIED BY 'router123';
Query OK, 0 rows affected (0.20 sec)

root@localhost [(none)]> GRANT ALL PRIVILEGES ON pyrocms.* TO 'userpyrocms'@'localhost';
Query OK, 0 rows affected (0.09 sec)

root@localhost [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.02 sec)
```

## 5. How to Install PyroCMS
The last installation we have to do is PyroCMS. Because in this article we will use Apache24, then place the PyroCMS folder in `"/usr/local/www"`.

```console
root@ns3:~ # cd /usr/local/www root@ns3:/usr/local/www # git clone https://github.com/pyrocms/pyrocms.git
```

Update Composer.

```console
root@ns3:/usr/local/www # cd pyrocms
root@ns3:/usr/local/www/pyrocms # composer update
root@ns3:/usr/local/www/pyrocms # composer install
```
Use the following command to install PyroCMS.
```console
root@ns3:/usr/local/www/pyrocms # php artisan install
The MIT License (MIT)
Copyright (c) 2018 AnomalyLabs, Inc.
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
Other Licenses
All add-ons are offered under their own license. Most of the add-ons available and
in our marketplace are either completely free and licensed under MIT as well, or
they are commercial add-ons and offered under our standard commercial license.
These add-ons are sold on a &quot;per-instance&quot; basis. This means one add-on purchase
per live site. Development copies and stages are included.

 Do you agree to the provided license and terms of service? (yes/no) [no]:
 > yes

 What database driver would you like to use? [mysql, pgsql, sqlite, sqlsrv] [mysql]:
 >

 What is the hostname of your database? [localhost]:
 >

 What is the name of your database?:
 > pyrocms

 Enter the username for your database connection [root]:
 > userpyrocms

 Enter the password for your database connection:
 > router123

 Enter the name of your application [Default]:
 >

 Enter the reference slug for your application [default]:
 >

 Enter the primary domain for your application [localhost]:
 >

 Enter the desired username for the admin user [admin]:
 >

 Enter the desired email for the admin user:
 > datainchi@gmail.com

 Enter the desired password for the admin user:
 > router123456

 Enter the default locale [en]:
 >

 Enter the default timezone [UTC]:
 >

1/61 Running core migrations.
2/61 Running application migrations.
3/61 Installing: Navigation Module
4/61 Installing: Users Module
5/61 Installing: Configuration Module
6/61 Installing: Preferences Module
7/61 Installing: Settings Module
8/61 Installing: Blocks Module
9/61 Installing: Files Module
10/61 Installing: Search Module
11/61 Installing: Pages Module
12/61 Installing: Repeaters Module
13/61 Installing: Addons Module
14/61 Installing: Dashboard Module
15/61 Installing: Posts Module
16/61 Installing: Streams Module
17/61 Installing: Variables Module
18/61 Installing: Redirects Module
19/61 Installing: XML Feed Dashboard Widget
20/61 Installing: HTML Block Extension
21/61 Installing: Throttle Security Check Extension
22/61 Installing: Default Authenticator Extension
23/61 Installing: Private Storage Adapter Extension
24/61 Installing: User Security Check Extension
25/61 Installing: Default Page Handler Extension
26/61 Installing: Page Link Type
27/61 Installing: Robots Extension
28/61 Installing: URL Link Type Extension
29/61 Installing: WYSIWYG Block Extension
30/61 Installing: Sitemap Extension
31/61 Reloading application.
32/61 Seeding: Navigation Module
33/61 Seeding: Users Module
34/61 Seeding: Configuration Module
35/61 Seeding: Preferences Module
36/61 Seeding: Settings Module
37/61 Seeding: Blocks Module
38/61 Seeding: Files Module
39/61 Seeding: Search Module
40/61 Seeding: Pages Module
41/61 Seeding: Repeaters Module
42/61 Seeding: Addons Module
43/61 Seeding: Dashboard Module
44/61 Seeding: Posts Module
45/61 Seeding: Streams Module
46/61 Seeding: Variables Module
47/61 Seeding: Redirects Module
48/61 Seeding: XML Feed Dashboard Widget
49/61 Seeding: HTML Block Extension
50/61 Seeding: Throttle Security Check Extension
51/61 Seeding: Default Authenticator Extension
52/61 Seeding: Private Storage Adapter Extension
53/61 Seeding: User Security Check Extension
54/61 Seeding: Default Page Handler Extension
55/61 Seeding: Page Link Type
56/61 Seeding: Robots Extension
57/61 Seeding: URL Link Type Extension
58/61 Seeding: WYSIWYG Block Extension
59/61 Seeding: Sitemap Extension
60/61 Running other migrations.
61/61 Running project seeds.
root@ns3:/usr/local/www/pyrocms #
```
View the result by opening the file `"/usr/local/www/pyrocms/.env"`.
```console
root@ns3:/usr/local/www/pyrocms # ee .env
APP_ENV=local
INSTALLED="true"
APP_KEY=17gYmbMPAwfq0OYAwjLdOpVNXp9oYd1a
APP_DEBUG=true
DEBUG_BAR=false
DB_CONNECTION=mysql
DB_HOST=localhost
DB_DATABASE=pyrocms
DB_USERNAME=userpyrocms
DB_PASSWORD=router123
APPLICATION_NAME=Default
APPLICATION_REFERENCE=default
APPLICATION_DOMAIN=localhost
ADMIN_USERNAME=admin
ADMIN_EMAIL=datainchi@gmail.com
ADMIN_PASSWORD=router123456
APP_LOCALE=en
APP_TIMEZONE=UTC
```
Run the chown and chmod commands, for ownership and access rights to the files.
```console
root@ns3:/usr/local/www/pyrocms # chown -R www:www /usr/local/www/pyrocms/
root@ns3:/usr/local/www/pyrocms # chmod -R 775 /usr/local/www/pyrocms/
```
The final configuration is to type the following command in the file `"/usr/local/etc/apache24/httpd.conf"`.

```html
Alias /pyrocms "/usr/local/www/pyrocms/"
<Directory "/usr/local/www/pyrocms">
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
```

Restart PHP-FPM and Apache24.
```console
root@ns3:~ # service apache24 restart
root@ns3:~ # service php-fpm restart
```

## 6. Run PyroCMS Test
At this stage, we will test PyroCMS. Is there anything wrong with the configuration you did above?.

Open Google Chrome web browser, type `"http://192.168.5.2/pyrocms/"`.

![test pyrocms](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/10Test%20PyroCMS.jpg&commit=e8ebb8577f6fe1607118d88c7adabf5029e94c8b)

and `"http://192.168.5.2/pyrocms/public/"`.

![welcome pyrocms](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/11Welcomae%20pyroCMS.jpg&commit=391ba2050b840b70650fd816d45ce0a21848cc75)

By trying the guide in this article, you can learn more about what PyroCMS is, how to install PyroCMS, and using PyroCMS on Apache24. Once you understand it, you can apply PyroCMS to create a website or blog.
