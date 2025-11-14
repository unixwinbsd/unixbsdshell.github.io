---
title: Using WordPress on Freebsd - Installation and Configuration for Blogs
date: "2025-09-17 07:45:51 +0100"
updated: "2025-09-17 07:45:51 +0100"
id: installation-wordpress-for-blogs-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/Wellcome-Wordpress.jpg
toc: true
comments: true
published: true
excerpt: WordPress is a popular content management system (CMS) and blogging platform that allows you to quickly create a website. Thanks to support for plugins and templates, this CMS is highly customizable, allowing you to customize site functionality according to your developer's needs
keywords: wordpress, blog, installer, freebsd, apache, php, proxy, reverse proxy, web server
---

A blog is a type of website that is regularly updated and provides insight into a specific topic. The word `"blog"` is a combination of the words "web" and "log." Initially, blogs were simply online diaries where people could record daily events. Gradually, blogs evolved into important websites for individuals and companies to share information and knowledge. Furthermore, many of us can also make money from blogging.

In this article, we will discuss how to create a blog on a FreeBSD server. To make it easier for readers to learn how to create a blog on FreeBSD, this blog discussion will be divided into several sections. Each section will guide you from the preparation stage to publishing your blog. In this first section, we will discuss how to create a WordPress site on a FreeBSD server.

WordPress is a popular content management system (CMS) and blogging platform that allows you to quickly create a website. Thanks to support for plugins and templates, this CMS is highly customizable, allowing you to customize site functionality according to your developer's needs. WordPress supports a wide range of sites, from simple blogs to full-fledged e-commerce sites.

## A. System specifications used

- OS: FreeBSD 13.2 Stable
- CPU: Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz
- IP Address: 192.168.5.2
- Hostname dan Domain: ns1.unixexplore.com
- Web Server: Apache24
- PHP: php82: 8.2.7
- WordPress: 6.2.2,1
- MySQL: mysql80-server
- WordPress Database Name: wordpress
- User name WordPress Database: bromo
- WordPress Database Passwords: mahameru


## B. Install Apache and PHP
Apache and PHP will be used as web servers, allowing WordPress to run in a web browser. This application installation is the initial setup before building WordPress. Below is the script for installing Apache and PHP.

```yml
root@ns1:~ # pkg install apache24
root@ns1:~ # pkg install php82 mod_php82 php82-mysqli
root@ns1:~ # pkg install php82-gd php82-phar php82-ctype php82-filter php82-iconv php82-curl php82-mysqli php82-pdo php82-tokenizer php82-mbstring php82-session php82-simplexml php82-xml php82-zlib php82-zip php82-dom php82-pdo_mysql php82-ctype
```

To enable PHP mods to run on Apache, edit the `/usr/local/etc/apache24/httpd.conf` file. Place the following script at the very end of the `httpd.conf` file.

```console
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

LoadModule php_module         libexec/apache24/libphp.so

<FilesMatch "\.php$">
    SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch "\.phps$">
    SetHandler application/x-httpd-php-source
</FilesMatch>
AddType application/x-compress .Z
AddType application/x-gzip .gz .tgz

AddType application/x-httpd-php .php
AddType application/x-httpd-php .php .phtml .php3
AddType application/x-httpd-php-source .phps
```

Create a `php.ini` file by copying the `php.ini-production` file to php.ini. The file is located in the `/usr/local/etc` directory.

```yml
root@ns1:~ # cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
```

Create an SSL certificate.

```yml
root@ns1:~ # cd /etc/ssl
root@ns1:/etc/ssl # wget http://curl.haxx.se/ca/cacert.pem
```

The next step is to edit the `/usr/local/etc/php.ini` file and enable the script below in the `php.ini` file.

```yml
extension=mysqli.soopenssl.cafile=/etc/ssl/cacert.pemcgi.fix_pathinfo=0
```

Then add this script at the top of the script in the php.ini file, place it right after the word `[PHP]` or at the bottom of the word `[PHP]`.

```console
listen.owner = www
listen.group = www
listen.mode = 0660
```

To test PHP modules, you need the info.php file. Create a new file with the name `info.php` and place it in the `/usr/local/www/apache24/data` folder. In the `info.php` file, enter the script as below.

```console
root@ns1:~ # touch /usr/local/www/apache24/data/info.php
root@ns1:~ # ee /usr/local/www/apache24/data/info.php
<?php phpinfo(); ?>
```

The next step is to create a server name and server IP address in the httpd.conf file. Open the `/usr/local/etc/apache24/httpd.conf` file and find the `"Listen"` and `"ServerName"` scripts, then replace them with the scripts below.

```console
Listen 192.168.5.2:80
ServerName www.unixexplore.com:80
```

Simply disable the default `"Listen 80"` script by adding a **"#"** sign at the beginning of the `#Listen 80` script. After all the above configurations are done, enable the Apache web server application by typing the following script in the `/etc/rc.conf` file.

```yml
root@ns1:~ # ee /etc/rc.conf
apache24_enable="YES"
```

So that the Apache application runs immediately, restart the Apache application.

```yml
root@ns1:~ # service apache24 restart
```

## C. Test Apache and PHP

It's time to test the Apache and PHP applications. First, let's test the Apache application. Open Yandex, Chrome, Firefox, or your preferred browser. In the web browser, type the FreeBSD server IP address, which is `http://192.168.5.2`. If the message **"It works!"** appears, the Apache24 web server is running normally.

Continue testing the PHP module by still typing the FreeBSD server IP address in the web browser, which is `http://192.168.5.2/info.php`.


## D. Install MySQL Server Database

Another application required by WordPress is MySQL Server. This application is used to access the Dashboard and store the WordPress database. Enter the following script to install MySQL Server.

```yml
root@ns1:~ # pkg install mysql80-client
root@ns1:~ # pkg install mysql80-server
```

Wait until the installation process is complete, after that delete the files in the `/var/db/mysql` directory.

```yml
root@ns1:~ # rm -rf /var/db/mysql/
```

Provide the username and group `"mysql"` in the `/usr/local/etc/mysql` folder.

```yml
root@ns1:~ # chown -R mysql:mysql /usr/local/etc/mysql
```

Enable MySQL Server at Start Up `rc.d`, by typing `mysql_enable="YES"` in the `/etc/rc.conf` file.

```console
root@router2:~ # ee /etc/rc.conf
mysql_enable="YES"
```

Next, run the Mysql Server application.

```yml
root@ns1:~ # service mysql-server restart
```

Once the computer is back to normal, create a MySQL Server root password.

```yml
root@ns1:~ # mysql_secure_installation
```

Make a note of the MySQL Server password you created and don't forget it. This password will be used to log in to the MySQL server. Now, let's test the password we created earlier. If it's correct, proceed to creating the `"WordPress"` database.

```console
root@ns1:~ # mysql -u root -p
Enter password: masukkan password mysql yang anda buat diatas
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.32 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> exit script exit untuk keluar dari mysql server
Bye
root@ns1:~ #
```

## E. Install and configure WordPress

The quickest and easiest way to install WordPress on a FreeBSD system is to install the pkg package from the FreeBSD repositories. The script below is for installing WordPress.

```yml
root@ns1:~ # pkg install wordpress
```

Before we can run WordPress on a web server, it needs to be configured to connect to the database we created earlier. Open the WordPress directory, `/usr/local/www/wordpress`, and copy the wp-config-sample.php file into `wp-config.php`.

```yml
root@ns1:~ # cd /usr/local/www/wordpress
root@ns1:/usr/local/www/wordpress # cp wp-config-sample.php wp-config.php
```

The script above will create a new file called `wp-config.php`. Edit it. When editing this file, pay attention to the `DB_NAME DB_USER DB_PASSWORD` script. To fill this script, it is taken from the MySQL Server database. Now, let's open and edit the `"/usr/local/www/wordpress/wp-config.php"` file.

```console
<?php
/**
* The base configuration for WordPress
*
* The wp-config.php creation script uses this file during the installation.
* You don't have to use the web site, you can copy this file to "wp-config.php"
* and fill in the values.
*
* This file contains the following configurations:
*
* * Database settings
* * Secret keys
* * Database table prefix
* * ABSPATH
*
* @link https://wordpress.org/documentation/article/editing-wp-config-php/
*
* @package WordPress
*/

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'bromo' );

/** Database password */
define( 'DB_PASSWORD', 'mahameru' );

/** Database hostname */
/**define( 'DB_HOST', 'localhost' );*/
define( 'ns1', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
* Authentication unique keys and salts.
*
* Change these to different unique phrases! You can generate these using
* the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
*
* You can change these at any point in time to invalidate all existing cookies.
* This will force all users to have to log in again.
*
* @since 2.6.0
*/
define( 'AUTH_KEY', 'put your unique phrase here' );
define( 'SECURE_AUTH_KEY', 'put your unique phrase here' );
define( 'LOGGED_IN_KEY', 'put your unique phrase here' );
define( 'NONCE_KEY', 'put your unique phrase here' );
define( 'AUTH_SALT', 'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT', 'put your unique phrase here' );
define( 'NONCE_SALT', 'put your unique phrase here' );

/**#@-*/

/**
* WordPress database table prefix.
*
* You can have multiple installations in one database if you give each
* a unique prefix. Only numbers, letters, and underscores please!
*/
$table_prefix = 'wp_';

/**
* For developers: WordPress debugging mode.
*
* Change this to true to enable the display of notices during development.
* It is strongly recommended that plugin and theme developers use WP_DEBUG
* in their development environments.
*
* For information on other constants that can be used for debugging,
* visit the documentation.
*
* @link https://wordpress.org/documentation/article/debugging-in-wordpress/
*/
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
```

<br/>

```console
root@ns1:~ # mysql -u root -p
Enter password:
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.32 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> create database wordpress;
root@localhost [(none)]> CREATE USER bromo@localhost IDENTIFIED BY 'mahameru';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON wordpress.* TO bromo@localhost;
root@localhost [(none)]> FLUSH PRIVILEGES;
oot@localhost [(none)]> exit
Bye
root@ns1:~ #
```

Since by default `Apache24 DocumentRoot` is in `/usr/local/www/apache24/data` folder, move `/usr/local/www/wordpress` folder to `/usr/local/www/apache24/data` folder.

```yml
root@ns1:~ # cd /usr/local/www
root@ns1:/usr/local/www # cp -rf wordpress/* /usr/local/www/apache24/data/
```

Once everything is configured correctly and nothing is missing, it's time to open your WordPress blog. If there are no errors or omissions in the configuration, WordPress should open. In the Yandex or Chrome Web Browser, type `http://192.168.5.2/index.php`.

The result will look like the image below.

<br/>
{% lazyload data-src="/img/oct-25/Wellcome-Wordpress.jpg" src="/img/oct-25/Wellcome-Wordpress.jpg" alt="Wellcome Wordpress" %}
<br/>

<br/>
{% lazyload data-src="/img/oct-25/oct-25-9.jpg" src="/img/oct-25/oct-25-9.jpg" alt="oct-25-9" %}

<br/>
{% lazyload data-src="/img/oct-25/oct-25-8.jpg" src="/img/oct-25/oct-25-8.jpg" alt="oct-25-9" %}
<br/>

If it looks like the image above, your WordPress has been successfully opened. Click the **"Continue"** button, then a menu will appear to enter your username and password. Enter the appropriate WordPress database username and password: user bromo password semeru.

When typing `http://192.168.5.2/index.php` in the Web Browser, a PHP error occurs, reinstall the PHP application as in discussion 2. Usually in the Mozilla Firefox browser when you type `http://192.168.5.2/index.php` and press enter, Firefox will redirect to https. It is recommended to use the Yandex browser or Google Chrome.