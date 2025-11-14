---
title: Nextcloud Installation on FreeBSD with Apache PHP Mysql Server
date: "2025-11-02 08:25:12 +0100"
updated: "2025-11-02 08:25:12 +0100"
id: nextcloud-installation-freebsd-with-apache-php-mysql
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-003.jpg
toc: true
comments: true
published: true
excerpt: In this article, we'll install Nextcloud on a FreeBSD system. For those unfamiliar, FreeBSD is an open-source operating system designed specifically for servers and desktops.
keywords: freebsd, mysql, nextcloud, php, fpm, openssl, mod, https, apache, apache24, bsd, linux
---

Nextcloud is one of the most popular open-source alternative offline cloud storage solutions. It has an attractive, easy-to-use, and intuitive interface for remote access to your data. You can install Nextcloud on FreeBSD and Linux servers to share files between colleagues. Or, if you want to install it on your VPS as an alternative to iCloud, Google Drive, or Dropbox, Nextcloud can do that too.

Nextcloud Hub provides a standalone solution for organizing collaboration between colleagues, friends, and teams developing various projects. You may be familiar with Google Docs and Microsoft 365; in terms of features, Nextcloud is quite similar to both. With Nextcloud Hub, you can implement a fully controlled collaboration infrastructure that runs on a local server and is not tied to external cloud services. Nextcloud's source code is distributed under the AGPL license.

Nextcloud Hub combines several open source applications through the Nextcloud cloud platform, allowing you to collaborate on documents, files, and office information to plan tasks and events. The platform also includes add-ons for accessing email, messaging, organizing video conferences, and chat.

In this article, we'll install Nextcloud on a FreeBSD system. For those unfamiliar, FreeBSD is an open-source operating system designed specifically for servers and desktops.

## A. System Specifications

- OS: FreeBSD 13.2
- PHP version: PHP 8.2.11
- MySql Server: mysql80-server-8
- Apache24: with php-fpm, php mod
- Nextcloud: nextcloud-php82-27.1.0
- IP Address: 192.168.5.2

## B. PHP-FPM Configuration
PHP-FPM is the primary library for running Nextcloud. PHP-FPM connects the Apache web server to the Nextcloud server. With PHP-FPM, Nextcloud runs as a proxy, meaning Nextcloud's performance is faster.

This article will not cover `PHP-FPM` installation; you can read the previous article explaining the installation and configuration of PHP-FPM on FreeBSD.

[Configuring PHP FPM and Apache24 on FreeBSD](https://unixwinbsd.site/freebsd/setup-php-fpm-apache-freebsd/)

To run PHP-FPM, we'll create a conf file in the same folder as Apache, namely `/usr/local/etc/apache24/Includes/php-fpm.conf`. In the `php-fpm.conf` file, write the script below.

```console
<IfModule proxy_fcgi_module>
   <IfModule dir_module>
       DirectoryIndex index.php
   </IfModule>

   <FilesMatch "\.(php|phtml|inc)$">
SetHandler proxy:unix:/tmp/php-fpm.sock|fcgi://localhost/
   </FilesMatch>
</IfModule>
```

To make `PHP-FPM` run automatically on a FreeBSD server, create a script in the `/etc/rc.conf` file, and paste the script below.

```yml
root@ns6:~ # ee /etc/rc.conf
php_fpm_enable="YES"
```

Restart PHP-FPM so it can run directly on FreeBSD.

```console
root@ns6:~ # service php-fpm restart
Performing sanity check on php-fpm configuration:
[27-Nov-2023 20:04:52] NOTICE: configuration file /usr/local/etc/php-fpm.conf test is successful

Stopping php_fpm.
Waiting for PIDS: 2037.
Performing sanity check on php-fpm configuration:
[27-Nov-2023 20:04:53] NOTICE: configuration file /usr/local/etc/php-fpm.conf test is successful

Starting php_fpm.
root@ns6:~ #
```

Next, we'll set up the database. Install the MySQL Server database and set it to start at boot. Nextcloud requires a database to store information and so on. We'll need to create a database in MySQL for Nextcloud, along with a username and password for Nextcloud to operate on that database.

You can read our previous article on the [MySQL Server installation guide](https://unixwinbsd.site/freebsd/create-coloumn-table-database-mysql-server-freebsd/).

After you have read the article above, proceed by logging into MySQL and creating the appropriate database, username, and password.

```yml
root@ns6:/usr/ports/www/nextcloud # mysql -u root -p
Enter password: Enter password
```

Then you run the following SQL query to create the nextcloud database and the username and password Nextclouduser.

```console
root@localhost [(none)]> CREATE DATABASE nextcloud;
Query OK, 1 row affected (0.14 sec)

root@localhost [(none)]> CREATE USER 'mary'@'localhost' IDENTIFIED BY 'mary123';
Query OK, 0 rows affected (0.04 sec)

root@localhost [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'mary'@'localhost';
Query OK, 0 rows affected (0.04 sec)

root@localhost [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.02 sec)

root@localhost [(none)]> exit;
```

The above SQL query command will create:
**Database name:** nextcloud
**IP address:** localhost (127.0.0.1)
**Username:** mary
**Password:** mary123

## D. Nextcloud Installation Process
Install PHP and all required modules for Nextcloud. I'm using PHP82. Nextcloud recommends using version 7.0 or later. PHP dependencies are essential for Nextcloud, as are almost all PHP libraries. Nextcloud uses PHP as a connection to the MySQL database and the Apache web browser.

Before installing PHP dependencies, you must first install PHP82.

```yml
root@ns6:~ # cd /usr/ports/lang/php82
root@ns6:/usr/ports/lang/php82 # make config-recursive
root@ns6:/usr/ports/lang/php82 # make install clean
```

Proceed with installing PHP dependencies.

```yml
root@ns6:~ # pkg install php82-xmlreader php82-ctype pkgconf php82-filter php82-iconv php82-xmlwriter php82-bz2 php82-mbstring php82-pdo_mysql php82-opcache
root@ns6:~ # pkg install php82-bcmath php82-dom php82-gmp php82-pcntl php82-pdo php82-posix php82-simplexml php82-xsl php82-intl php82-ldap php82-sysvsem
```

Okay, let's continue installing Nextcloud. Use the FreeBSD port system, as we'll be enabling the MySQL database server module.

```yml
root@ns6:/usr/ports/lang/php82 # cd /usr/ports/www/nextcloud
root@ns6:/usr/ports/www/nextcloud # make config
```
The results of the command above will display an image like the one below.

<br/>
<img alt="Installing PHP dependencies" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-001.jpg' | relative_url }}">
<br/>

Check the `"MySQL database support"` option. After that, continue with the following command.

```yml
root@ns6:/usr/ports/www/nextcloud # make config-recursive
root@ns6:/usr/ports/www/nextcloud # make install clean
```

## E. Edit the httpd.conf File

The next step is to configure the Apache server. This will allow Nextcloud to connect to web browsers like Google Chrome, Yandex, and others. The main Apache configuration file is httpd.conf. Open it using the built-in FreeBSD editor "ee" and paste the following script into the file `/usr/local/etc/apache24/httpd.conf`.

```console
Alias /nextcloud /usr/local/www/nextcloud
        AcceptPathInfo On
        <Directory /usr/local/www/nextcloud>
	#Options None
	#Options +FollowSymlinks
	Options Indexes ExecCGI FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>

AddType application/x-httpd-php-source .phps
AddType application/x-httpd-php		.php 
```

Enable some modules required by Nexcloud in the `/usr/local/etc/apache24/httpd.conf` file.

```console
LoadModule mpm_prefork_module libexec/apache24/mod_mpm_prefork.so
LoadModule cache_module libexec/apache24/mod_cache.so
LoadModule proxy_module libexec/apache24/mod_proxy.so
LoadModule proxy_connect_module libexec/apache24/mod_proxy_connect.so
LoadModule proxy_ftp_module libexec/apache24/mod_proxy_ftp.so
LoadModule proxy_http_module libexec/apache24/mod_proxy_http.so
LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so
LoadModule proxy_scgi_module libexec/apache24/mod_proxy_scgi.so
LoadModule session_module libexec/apache24/mod_session.so
LoadModule rewrite_module libexec/apache24/mod_rewrite.so
LoadModule php_module         libexec/apache24/libphp.so
```

Once the Nextcloud installation is complete, a new folder will be created at /usr/local/www/nextcloud. Type the following command to grant file ownership.

```yml
root@ns6:/usr/ports/www/nextcloud # chown -R www:www /usr/local/www/nextcloud/
```

## F. Test Nextcloud

Before you test Nextcloud, restart the entire application.

```yml
root@ns6:/usr/ports/www/nextcloud # service mysql-server restart
root@ns6:/usr/ports/www/nextcloud # service php-fpm restart
root@ns6:/usr/ports/www/nextcloud # service apache24 restart
```

Open the Google Chrome Web Browser, in the address bar menu type `"192.168.5.2/nextcloud"`.

<br/>
<img alt="login to nextcloud with password" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-002.jpg' | relative_url }}">

<br/>
<img alt="login to nextcloud" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-003.jpg' | relative_url }}">

<br/>
<img alt="good morning nextcloud" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-004.jpg' | relative_url }}">

<br/>
<img alt="dashboard nextcloud" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-005.jpg' | relative_url }}">
<br/>

To display the "Log In" menu, type `"http://192.168.5.2/nextcloud/index.php/login"`.

The only difficulty in installing Nextcloud is connecting and creating a MySQL database. Furthermore, incompatible dependencies can also affect Nextcloud servers that aren't connected to MySQL and Apache. Furthermore, the presence of PHP-FPM further complicates the Nextcloud installation process.
