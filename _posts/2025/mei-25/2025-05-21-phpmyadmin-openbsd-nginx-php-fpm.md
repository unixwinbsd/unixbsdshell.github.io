---
title: Configuring PHPMyAdmin and Nginx on OpenBSD 7.6
date: "2025-05-21 08:01:35 +0100"
updated: "2025-05-21 08:01:35 +0100"
id: phpmyadmin-openbsd-nginx-php-fpm
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DataBase
background: /img/oct-25/oct-25-126.jpg
toc: true
comments: true
published: true
excerpt: PHPMyAdmin is an open source software introduced on September 9, 1998, written in PHP.
keywords: openbsd, php, phpmyadmin, php-fpm, nginx, website, database, mariadb, sql, mysql
---

What is PHPMyAdmin? PHPMyAdmin is an open-source PHP-based tool that is useful for handling MySQL/MariaDB database server administration through a Web-based interface. It has a simple interface that is easy to navigate and learn quickly.

phpMyAdmin is widely used to manage MySQL and MariaDB databases. This tool offers an intuitive interface for database administrators, making it easy to perform various operations such as creating, modifying, and deleting databases, tables, and users.

With phpMyAdmin you can interact directly with MySQL databases, manage user accounts and privileges, execute SQL statements, import and export data in various data formats, and much more.

phpMyAdmin is one of the applications that consists of XHTML, CSS, and JavaScript client code, making it easy for users to manage MySQL databases. This application is widely recognized as a leading application in the database field.

Because it is open source since its inception, this application has been supported by many developers and translators around the world (it has been translated into 50 languages).

While Nginx is an open source software that is used primarily as a web server, reverse proxy, cache server. It is also used as a load balancer, for media streaming, etc. In this article we will explain the installation process of PHPMyAdmin with Nginx running on an OpenBSD server.

## 1. phpMyAdmin Features

PHPMyAdmin is an open source software introduced on September 9, 1998, written in PHP. Basically, it is a third-party software for managing tables and data in a database. phpMyAdmin supports various types of operations on MariaDB and MySQL. The main purpose of phpMyAdmin is to handle MySQL administration via the web.

phpMyAdmin supports several features that you can use to manage databases, including:
- Supports foreign keys and InnoDB tables.
- PHPMyAdmin can track changes made to databases, views, and tables.
- We can also create PDF graphs of our database layout.
- PHPMyAdmin can create, alter, search, and drop databases, views, tables, columns, and indexes.
- It can display multiple result sets through queries and stored procedures.
- phpMyAdmin uses stored procedures and queries to display multiple result sets.
- phpMyAdmin can edit, execute, and tag SQL statements and even batch queries.
- Using a set of predefined functions, it can convert stored data into any format. For example, BLOB data as images or download links.
- Provides the facility to backup databases into various formats.
- phpMyAdmin can be exported to various formats such as XML, CSV, PDF, ISO/IEC 26300 – OpenDocument Text and Spreadsheet.
- Supports mysqli, which is an enhanced MySQL extension.
- phpMyAdmin can interact with 80 different languages.

## 2. System Specifications
- OS: OPenBSD 7.6
- IP Address: 192.168.5.3
- Versi PHPMyAdmin: phpMyAdmin-5.2.2
- Versi PHP: PHP 8.3.20
- Versi Nginx: nginx/1.26.2
- Dependensi PHP: pecl83-imagick php-gd-8.3.20  php-zip-8.3.20 pecl83-redis php-curl-8.3.20 php-bz2-8.3.20 php-intl-8.3.20 php-pdo_sqlite-8.3.20 php-mysqli-8.3.20 php-pdo_mysql-8.3.20

## 3. PHPMyAdmin Installation Process

The PHPMyadmin program is available in the OpenBSD PKG package repository, you can install it directly. Run the pkg_add command to install PHPMyAdmin to the OpenBSD server.

```yml
# pkg_add -D snap phpmyadmin

quirks-7.111 signed on 2025-05-16T22:28:45Z
phpMyAdmin-5.2.2:php-mysqli-8.2.28p0: ok
phpMyAdmin-5.2.2: ok
New and changed readme(s):
/usr/local/share/doc/pkg-readmes/phpMyAdmin
```
<br/>

### 3.1. PHP Extension Installation Process

As explained above, PHPMyAdmin is made with the PHP programming language, so it is very natural that the PHP extension is the most widely used dependency to run PHPMyAdmin. There are so many PHP extensions that you have to install, if there is even one dependency missing, then the way PHPMyAdmin works will be disrupted.

You can use the command below to install all PHPMyAdmin dependencies.

```console
# pkg_add pecl83-imagick php-gd-8.3.20  php-zip-8.3.20 pecl83-redis php-curl-8.3.20 php-bz2-8.3.20 php-intl-8.3.20 php-pdo_sqlite-8.3.20 php-mysqli-8.3.20 php-pdo_mysql-8.3.20
```
<br/>

### 3.2. Create PHP Extension Symlink

OpenBSD is a bit different from other BSD systems, every time you install a PHP extension, the `*.ini` file is stored in the `/etc/php-8.3.sample` directory. All extension files must be placed in the /etc/php-8.3 directory. You can use the symlink command or copy directly to the destination directory. In this case I prefer to use the symlink command.


```console
# ln -sf /etc/php-8.3.sample/* /etc/php-8.3/
```

<br/>

### 3.3. Enable the /etc/php-8.3.ini Script

As we know the main PHP configuration file has the extension *.ini, each operating system has a different name. On OpenBSD the PHP configuration file is php-8.3.ini, the file contains PHP configuration scripts that you can set according to your needs.

You can enable or disable each script in the file. Because in this article we will use PHP to be used with Nginx and PHPMyadmin, so that PHP functions can run optimally, you must enable several scripts in the /etc/php-8.3.ini file as in the following example.

```yml
expose_php = Off
max_execution_time = 90
memory_limit = 512M
opcache.enable=1
opcache.enable_cli=1
opcache.revalidate_freq=1
opcache.enable=1
opcache.memory_consumption=512
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=1
opcache.save_comments=1
cgi.fix_pathinfo=0
```

We created this article to be interrelated, to activate PHP-FPM you can read our previous article.

### 3.4. Change Host config.inc.php

The main PHPMyAdmin configuration file is config.inc.php, which is located in the /var/www/phpMyAdmin directory. Check for the config.inc.php file in that directory. If it is not there, you can copy it from the existing sample file. To copy the config.inc.php file, use the following command.

```console
# cp -f /var/www/phpMyAdmin/config.sample.inc.php /var/www/phpMyAdmin/config.inc.php
```

After that, in the /var/www/phpMyAdmin/config.inc.php file, look for the script "$cfg['Servers'][$i]['host'] = 'localhost'; replace localhosts with IP 127.0.0.1.

```yml
$cfg['Servers'][$i]['host'] = '127.0.0.1';
```

## 4. Create MariaDB Database

Creating this database is very important, besides being used to connect to PHPMyAdmin. All your work will be stored in the database. You don't have to use MariaDB, if you are used to using MysQL it is much better, because MySQL is very popular and easy to use.

In addition, the database is used to log in to the PHPMyAdmin server. The username and password that we create will be used to log in to PHPMyAdmin. Run the command mysql -u root -p to create a database login to PHPMyAdmin.

```yml
# mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 10.9.8-MariaDB OpenBSD port: mariadb-server-10.9.8p1v1

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE DATABASE phpmyadmin;
Query OK, 1 row affected (0.035 sec)

MariaDB [(none)]> CREATE USER 'userphp'@'localhost' IDENTIFIED BY 'passwdphp';
Query OK, 0 rows affected (0.135 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'userphp'@'localhost';
Query OK, 0 rows affected (0.053 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]>
```

In creating the database above, we create an account and password:
Database name: **phpmyadmin**
User name: **userphp**
Database password: **passwdphp**
Database connection: **127.0.0.1**

For the MariaDB installation and configuration process, you can read the article we wrote earlier about MariaDB.

## 5. NGINX Configuration

We assume you have installed Nginx on OpenBSD. As a guide to connecting Nginx with PHPMyAdmin, below is an example of the nginx.conf script that we use.

```console
user  www;
worker_processes  1;

error_log  logs/error.log;
pid        logs/nginx.pid;
worker_rlimit_nofile 1024;

events {
    worker_connections  800;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    index         index.html index.htm;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log  main;
    keepalive_timeout  65;
    server_tokens off;
    
#include /etc/nginx/vhosts.conf;
include /etc/nginx/vhostsSSL.conf;
}
```

At the bottom, note the script `"include /etc/nginx/vhostsSSL.conf;"`, we will create a vhostsSSL.conf file. The file contains the Nginx configuration script so that it can connect to PHPMyAdmin.

Below is an example script from the file **"/etc/nginx/vhostsSSL.conf"**.

```console
server {
        listen       443 ssl;
        server_name  datainchi.com;
        #root         /var/www/phpMyAdmin;

        ssl_certificate      /etc/nginx/SSL/nginxssl.crt;
        ssl_certificate_key  /etc/nginx/SSL/nginxssl.key;
        ssl_session_timeout  5m;
        ssl_session_cache    shared:SSL:1m;

        ssl_ciphers  HIGH:!aNULL:!MD5:!RC4;
        ssl_prefer_server_ciphers   on;

location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass   unix:run/php-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
	    root         /var/www/phpMyAdmin;
    }

location / {
     root         /var/www/phpMyAdmin;
     index  index.html index.htm index.php;
            autoindex on;
            autoindex_exact_size off;
            autoindex_localtime on;
 }

 location ~ ^/(doc|sql|setup)/ {
    deny all;
  }

location = /robots.txt {
    deny all;
    log_not_found off;
    access_log off;
  }

 location ~ /\. {
    deny all;
    access_log off;
    log_not_found off;
  }


    }
```

## 6. Run PHPMyAdmin

After all configurations and dependencies have been installed, in this section we will run PHPMyAdmin. This section is very important, because if there are dependencies that are not installed or you type the script incorrectly, don't expect PHPMyAdmin to run on the OpenBSD server.

Before you run PHPMyAdmin, reload all applications used with the command below.

```console
# rcctl restart mysqld
mysqld(ok)
mysqld(ok)
# rcctl restart nginx
nginx(ok)
nginx(ok)
# rcctl restart php83_fpm
php83_fpm(ok)
php83_fpm(ok)
```

To Run PHPMyAdmin, we just use the Google Chrome browser, at the top you type **"https://192.168.5.3/index.php"**, if everything is fine, your monitor screen will display the login menu.

In this login menu you type the username and password from MariaDB that you have created at the top.

If you successfully log in, the main dashboard will appear, you can set it according to your work needs.

The tutorial we created is a continuous tutorial. Between one article and another are interconnected. If you do not understand the article you are reading, you read the article we attached as a complement to the contents of the article we wrote.
