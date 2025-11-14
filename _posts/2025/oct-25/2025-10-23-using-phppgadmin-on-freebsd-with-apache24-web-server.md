---
title: Using phpPgAdmin on FreeBSD with Apache24 Web Server
date: "2025-10-23 07:31:11 +0100"
updated: "2025-10-23 07:31:11 +0100"
id: using-phppgadmin-on-freebsd-with-apache24-web-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/oct-25/oct-25-132.jpg
toc: true
comments: true
published: true
excerpt: This article will review the phpPgAdmin application, complete with installation and configuration instructions. At the time of writing, phpPgAdmin was running on a FreeBSD 13.2 server, which has proven to be robust and stable.
keywords: php, phppgadmin, freebsd, apache, apache24, web server, modul, mod, install
---

phpPgAdmin is similar to phpMyAdmin. phpPgAdmin is used in conjunction with PostgreSQL, while phpMyAdmin is used in conjunction with MySQL. This means that phpPgAdmin allows you to access and manage databases that are relied on on your website more easily when used in conjunction with a web browser.

If you're using a PostgreSQL database, phpPgAdmin should be your preferred management tool, an integral part of your PostgreSQL database. Like phpMyAdmin, phpPgAdmin is also PHP-based and is used to simplify database creation and management, even for users with little experience.

Indirectly, the relationship between phpPgAdmin and PostgreSQL is similar to the relationship between phpMyAdmin and MySQL. More specifically, phpPgAdmin is a web-based utility or software that allows users to manage PostgreSQL databases with ease. The phpPgAdmin application can be opened in a web browser as a regular page and will function the same regardless of the operating system used.

As the name suggests, phpPgAdmin is written in PHP and offers a variety of easy-to-use features for [managing PostgreSQL databases](https://forums.freebsd.org/threads/phppgadmin-installation-issues-on-freebsd-13-2.90099/). If you've used phpMyAdmin before, the phpPgAdmin interface will feel familiar, as its graphical GUI looks and feels inspired by phpMyAdmin.

<br/>

![How to install phppgadmin on FreeBSD](/img/oct-25/oct-25-132.jpg)

<br/>

Through phpPgAdmin, you can view information stored in tables, create new records, edit existing records, and delete unnecessary records. Furthermore, you have advanced sorting and filtering features at your disposal. However, perhaps phpPgAdmin's greatest strength is its support for Structured Query Language (SQL).

This article will review the phpPgAdmin application, complete with installation and configuration instructions. At the time of writing, phpPgAdmin was running on a FreeBSD 13.2 server, which has proven to be robust and stable.

["Creating a PostgreSQL database connection with PHP and Apache on FreeBSD"](https://unixwinbsd.site/freebsd/database-website-apache-php-postgresql/)


## A. System Specifications

- OS: FreeBSD 13.2
- Domain: unixexplore.com
- IP Address: 192.168.5.2
- Apache Version: Apacje24
- PHP Version: PHP82
- PHP mods and extensions
- PHP-FPM
- Postgresql version: postgresql15


## B. How to Install phpPgAdmin

Since phpPgAdmin is used to manage PostgresQL databases, it is a good idea to check whether the PostgresQL application is installed on the FreeBSD server before performing the installation.

```sh
root@ns1:~ # service -e
/etc/rc.d/hostid
/etc/rc.d/devd
/etc/rc.d/resolv
/etc/rc.d/newsyslog
/etc/rc.d/dmesg
/etc/rc.d/os-release
/etc/rc.d/gptboot
/etc/rc.d/linux
/etc/rc.d/syslogd
/etc/rc.d/ntpdate
/etc/rc.d/ntpd
/usr/local/etc/rc.d/openssh
/usr/local/etc/rc.d/postgresql
/usr/local/etc/rc.d/php-fpm
/usr/local/etc/rc.d/apache24
/etc/rc.d/bgfsck
```

From the script above, we can see that PostgreSQL, Apache24, and php-fpm are already installed, so we can proceed directly to installing phppgadmin. Use the command below to install phpPgAdmin.

```sh
root@ns1:~ # cd /usr/ports/databases/phppgadmin
root@ns1:/usr/ports/databases/phppgadmin # make install clean
```

## C. Edit/Change the php.ini file

For the PHP pgsql module to run alongside PHP, it must be enabled. Edit the `/usr/local/etc/php.ini` file and remove the **";"** at the beginning of the script. To edit the `/usr/local/etc/php.ini` file, we use the **"ee"** editor. Here's how to enable the PHP pgsql module.

```sh
root@ns1:~ # ee /usr/local/etc/php.ini
extension=pgsql
```

The above command will enable the PHP pgsql module.


## D. Edit/Change the httpd.conf file

The `httpd.conf` file is the Apache24 application's configuration file. Since phpPgAdmin runs in the Apache24 web browser, we need to edit the `httpd.conf` file so that phpPgAdmin can be opened in Google Chrome or Yandex. In the `/usr/local/etc/apache24/httpd.conf` file, add the **"index.php"** script to the following line.

```
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
```

After adding the `"index.php"` script, the result will be as below.

```
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>
```

Then add the following script to the very bottom of the `/usr/local/etc/apache24/httpd.conf` file.

```
Alias /phpPgAdmin "/usr/local/www/phpPgAdmin/"
<Directory "/usr/local/www/phpPgAdmin">
    AllowOverride None
    Options None
    Require all granted
</Directory>
```

Since in this article we are using PHP-FPM, the following scripts should be disabled in the `/usr/local/etc/apache24/httpd.conf` file.

```
#<FilesMatch "\.php$">
#    SetHandler application/x-httpd-php
#</FilesMatch>
#<FilesMatch "\.phps$">
#    SetHandler application/x-httpd-php-source
#</FilesMatch>
```

## E. Test phpPgAdmin

Once all the above configurations are complete and nothing is missing, the next step is to test the phpPgAdmin application. Before retesting, the apache24 application must be installed so that all PHP and phpPgAdmin modules can be loaded by the apache24 web server.

```sh
root@ns1:~ # service apache24 restart
root@ns1:~ # service php-fpm restart
```

Now we open the Yandex or Google Chrome web browser, in the address bar menu type `"http://192.168.5.2:8080/phpPgAdmin/"`.

If a display like the image above appears, it means that the phpPgAdmin application has been successfully installed on your server computer, and now we can do PostgreSQL work with a GUI display that can make it easier for us to edit, add, delete and so on for each table and database in PostgreSQL.