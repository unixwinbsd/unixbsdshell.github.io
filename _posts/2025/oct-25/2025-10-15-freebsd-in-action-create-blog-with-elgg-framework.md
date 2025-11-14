---
title: FreeBSD in Action - Create a Blog with the ELGG Development Framework
date: "2025-10-15 19:57:13 +0100"
updated: "2025-10-15 19:57:13 +0100"
id: freebsd-in-action-create-blog-with-elgg-framework
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-78.jpg
toc: true
comments: true
published: true
excerpt: In this article, we assume that apache24 and mysql80-server are installed on your FreeBSD server. Ensure that both applications run smoothly on your FreeBSD server. Since Elgg is written in PHP, the primary requirement is that we must have PHP installed to connect to apache24. Here's how to install PHP82 and the PHP dependencies required to run Elgg.
keywords: freebsd, elgg, development, php, laravel, composer, framework, web server, apache, nginx, blog, site
---

Elgg is a free, open-source social networking platform that offers blogging, networking, community, news gathering, feed aggregation, and file sharing features. All content can be shared between users with access control and can also be cataloged by tags.

Elgg is a free, open-source social collaboration tool for campuses, companies, and individuals. Its presence competes with modern hosting services because it offers independent hosting capabilities and advanced features for building open-source social networking applications. Furthermore, this free social networking platform is known for its reliability, lightweight design, and well-documented API that easily interfaces with third-party applications.

The free social collaboration tool Elgg is written in PHP. Therefore, comprehensive documentation on development and implementation is available. Naturally, there are thousands of plugins available that can be easily installed according to functionality needs. Furthermore, Elgg provides very robust security and authentication mechanisms using robust techniques.

Elgg's free collaborative platform offers a variety of features such as an access control system, notification service, fog-resistant display system, clean file storage, a cacheable asset statistics system, and much more. Therefore, Elgg is easy to set up and provides a smart user interface for quick and easy navigation.

## 1. Key Features of Elgg

At the time of writing, the latest version of Elgg is Elgg 5.1.4. Since its inception, Elgg has been equipped with a suite of plugins that provide basic functionality for social networking and blogging. 

**Elgg offers the following key features:**

- Groups: Flexible grouping tool. Includes profiles, forums, pages, message boards, and RSS feeds.
- Diagnostics and administration tools.
- Cryptography-based security.
- Notification service.
- File repository. Allows users to upload any authorized file type. Also includes a photo gallery.
- Pages: Create hierarchically organized text pages and define read and write privileges.
- Access control system.
- Messages: Private "letters."
- The Wire, a Twitter-style microblogging plugin that allows users to post notes to the wire.
- Documented API.
- User validation via email.
- Message Board: Similar to 'The Wall' on Facebook or comment walls on other networks, this plugin allows users to place a message board widget on their profile. Other users can then post messages that will appear on the message board.
- Profile: Provides information about the user, configurable from the plugin's start.php. One can change the available fields from the admin panel. Each profile field has its own access restrictions, so users can choose exactly who can see each individual element.

## 2. System Requirements

To run Elgg on a FreeBSD server, several system requirements are required. In this article, we've installed some of the dependencies required by Elgg.

- OS: FreeBSD 13.2
- Database: mysql80-server
- PHP version: PHP82
- Apache version: apache24
- PHP-FPM
- mod PHP82 dan PHP82 extension
- Composer PHP

## 3. How to Install PHP82

In this article, we assume that apache24 and mysql80-server are installed on your FreeBSD server. Ensure that both applications run smoothly on your FreeBSD server.

Since Elgg is written in PHP, the primary requirement is that we must have PHP installed to connect to apache24. Here's how to install PHP82 and the PHP dependencies required to run Elgg.

```console
root@ns3:~ # pkg install php82 php82-tokenizer mod_php82 php82-fileinfo php82-xmlreader php82-xmlwriter php82-mysqli php82-iconv
```

We continue by installing other PHP dependencies.

```console
root@ns3:~ # pkg install php82-curl php82-dom php82-filter php82-gd php82-intl php82-mbstring php82-pdo_mysql php82-pdo php82-simplexml php82-soap php82-xml php82-pecl-xmlrpc
```

<br/>

```
root@ns3:~ # pkg install libssh2 curl libpsl meson py39-setuptools sqlite3 libedit
```

Connect PHP with apache24, so that all PHP modules can be run on the apache24 web server. Type the following command in the file `"/usr/local/etc/apache24/httpd.conf"`.

```
LoadModule rewrite_module libexec/apache24/mod_rewrite.so
LoadModule php_module         libexec/apache24/libphp.so

<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

AddType application/x-httpd-php .php
AddType application/x-httpd-php .php .phtml .php3
AddType application/x-httpd-php-source .phps

```

After that, you'll need to enable PHP-FPM. This article won't cover PHP-FPM installation.

You can read the following articles:

[Configuring PHP FPM and Apache24 on FreeBSD](https://unixwinbsd.site/freebsd/configuring-php-fpm-apache24-freebsd-14/)

Let's assume PHP-FPM is already running on your FreeBSD server. So, let's quickly restart apache24 and PHP-FPM.

```
root@ns3:~ # service php-fpm restart
root@ns3:~ # service apache24 restart
```

## 4. Create Elgg Database

Elgg uses a database to store all user information. Elgg can support multiple databases; in this article, we'll use a MySQL server as the Elgg database.

On the MySQL server, we create a database, user, and password that we'll later use to connect to the Elgg server. The commands below will guide you through creating an Elgg database.


```
root@ns3:~ # mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 74
Server version: 8.0.35 Source distribution

root@localhost [(none)]>
```

The above command is used to log into the MySQL server. To create an Elgg database, use the following command.

```
root@localhost [(none)]> CREATE DATABASE elgg CHARACTER SET utf8;
root@localhost [(none)]> CREATE USER 'userelgg'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON elgg.* TO 'userelgg'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]>
```

The above command is used to create a database `"elgg"` with the username `"userelgg"` and password `"router123"`.

## 5. How to Install Elgg and Composer PHP

On FreeBSD, Elgg can be installed in several ways, including through GitHub, PHP Composer, and the FreeBSD PKG package. We'll use the standard FreeBSD installation, which uses the PKG package. Before we begin installing Elgg, we'll first install PHP Composer.

```
root@ns3:~ # pkg install php82-composer php82-ctype php82-phar
```

After you have successfully installed PHP composer, we continue by installing Elgg.


```
root@ns3:~ # cd /usr/ports/www/elgg
root@ns3:/usr/ports/www/elgg # make install clean
```

Build Elgg with PHP composer.

```
root@ns3:/usr/ports/www/elgg # composer update
root@ns3:/usr/ports/www/elgg # composer install
```

After that, you run the chmod and chown commands.

```
root@ns3:/usr/ports/www/elgg # chown -R www:www /usr/local/www/elgg
root@ns3:/usr/ports/www/elgg # chmod -R 775 /usr/local/www/elgg
root@ns3:/usr/ports/www/elgg # chown -R www:www /tmp/elgginstaller
root@ns3:/usr/ports/www/elgg # chmod -R 775 /tmp/elgginstaller
```

Even though you've installed Elgg, you can't use it yet. To connect to the Elgg server, you need to connect your MySQL database server to Elgg. There are two ways to connect your MySQL server to Elgg: using the CLI and using the Google Chrome web browser. If you want to use the CLI, type the following command.

```
root@ns3:/usr/local/www/elgg # vendor/bin/elgg-cli install
```

We recommend using Google Chrome, as it's both more practical and easier to use. In the Google Chrome web browser, type `"http://192.168.5.2/elgg/install.php"`.

If there are no errors with the configuration above, you should see a screen similar to the image below.

<br/>

![elgg welcome](/img/oct-25/oct-25-78.jpg)

<br/>

![check elgg system](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-79.jpg)

<br/>

![database elgg](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-80.jpg)

<br/>

![elgg configuration](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-81.jpg)

<br/>

![create an elgg account](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-82.jpg)

<br/>

![dashboard elgg unixwinbsd site](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-83.jpg)

<br/>


Congratulations! You've successfully installed Elgg on your FreeBSD server. Thank you for using this tutorial to install Elgg on your FreeBSD computer. By mastering the discussion in this article, you'll have a blog that's an alternative to Blogspot or WordPress.