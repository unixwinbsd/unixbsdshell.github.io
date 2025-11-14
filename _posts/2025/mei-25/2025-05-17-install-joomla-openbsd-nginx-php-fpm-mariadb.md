---
title: Install Joomla on OpenBSD 7.7 With Nginx PHP-FPM MariaDB
date: "2025-05-17 18:01:23 +0100"
updated: "2025-05-17 18:01:23 +0100"
id: install-joomla-openbsd-nginx-php-fpm-mariadb
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: WebServer
background: https://gitflic.ru/project/unixbsdshell/upravlenie-polosoi-propuskaniya-pfsense-qos/blob/raw?file=menu-login-joomla.png&commit=34f8823f1b0c9cfd6d0658a6b2770be41bc34f3e
toc: true
comments: true
published: true
excerpt: What exactly is FastCGI Mode that makes it so popular and how can it improve the performance of your website to run fast.
keywords: nginx, mod ssl, mod, php, php-fpm, http, https, 80, 443, openssl, openbsd, web server
---

Website development and hosting are at the heart of any modern business, unless you're already a professional web developer. You'll undoubtedly need a fast, easy-to-manage, and reliable software system to help you bring your website online.

For this purpose, Joomla is often considered one of the best choices for web server hosting and website creation. Joomla is a free and open-source content management system (CMS) designed for building websites and online applications. Written in PHP, Joomla uses MySQL, MariaDB, or PostgreSQL databases to store content.

Joomla is renowned for its flexibility, comprehensive features, and active community of developers and users. With Joomla, you can create a website without using HTML or CSS. This, along with its low price, makes it a favorite choice among many businesses and non-profit organizations.

Joomla offers an easy-to-use interface, flexible features, and scalability. With Joomla, you can create various types of web pages, manage user access, customize the appearance, and extend its functionality using Joomla extensions. The core Joomla CMS is designed to ensure your site can operate under high loads. The failure of one module does not result in a complete system crash.

Joomla is actively developed by the community and regularly updated. It is compatible with all popular web servers such as Nginx, Apache, Microsoft IIS, and others. The official Joomla catalog contains a large number of add-ons. The interface is widely translated into many languages, including Russian.

## A. What is Joomla? How the Joomla CMS Works

The Joomla CMS is an easy-to-use platform for creating, managing, and customizing websites. The installation process begins with the CMS setup process and provides access to the administration area, where you can use the Joomla auto-installer. The administration area serves as a control panel for managing the website, including configuring settings, creating and editing content, adding extensions, and customizing the design.

Content creation and management in Joomla revolves around organizing articles into categories and using the built-in editor for formatting, embedding media, and styling. Templates play a crucial role in the visual appearance of a website, allowing users to choose from pre-designed templates or create their own. Templates can be customized to suit branding and design preferences.

Joomla's extensibility is one of its most prominent features, offering a wide variety of components, modules, and plugins. Components provide core functionality, modules display specific content, and plugins add specific features. These extensions can enhance the capabilities of your website and tailor it to specific requirements.

User management in Joomla allows the creation of user accounts, user groups, and permissions. This allows control over website access and contributions, making it suitable for websites with multiple contributors or varying levels of access.

## B. System Specifications

- OS: OpenBSD 7.7
- IP Address: 192.168.5.3
- Hostname: ns3
- Domain: unixwinbsd.site
- PHP version: PHP 8.3.21 (cli) (built: May 9 2025 07:05:21) (NTS)
- Nginx version: nginx/1.26.3
- PHP dependencies: php-gd-8.3.21 php-zip-8.3.21 php-curl-8.3.21 php-bz2-8.3.21 php-intl-8.3.21 php-pdo_sqlite-8.3.21 php-mysqli-8.3.21 pecl83-imagick pecl83-redis
- MariaDB Client Version: mariadb-client-11.4.5v1 (installed)
- MariaDB Server version: mariadb-server-11.4.5p0v1 (installed)

## C. Editing the /etc/php-8.3.ini File

The `/etc/php.ini` file is PHP's main configuration file. This file contains PHP configuration scripts. The `/etc/php.ini` script is the same for almost all operating systems. To ensure PHP can optimally serve Joomla, you must reconfigure the contents of this file.

In the `/etc/php.ini` file, modify or activate it, as in the following example:

```yml
expose_php = Off
max_execution_time = 90
memory_limit = 512M
opcache.enable=1
opcache.enable_cli=1
upload_max_filesize = 64M
opcache.revalidate_freq=1
opcache.enable=1
max_execution_time = 120
post_max_size = 64M
opcache.memory_consumption=512
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=1
opcache.save_comments=1
cgi.fix_pathinfo=0
```

## D. Install PHP Extensions

A PHP extension is a dependency that PHP has. There are many types of PHP dependencies, but for database use, the most common dependencies are `php-pdo_sqlite` and `php-mysqli`. These two dependencies connect PHP to a MariaDB or MySQL database.

Below are the commands for installing PHP extensions.

```console
ns3# pkg_add php-gd-8.3.21 php-zip-8.3.21 php-curl-8.3.21 php-bz2-8.3.21 php-intl-8.3.21 php-pdo_sqlite-8.3.21 php-mysqli-8.3.21 pecl83-imagick pecl83-redis
```

Even if you've installed a PHP extension, you can't use it yet. To connect the extension directly to PHP, you'll need to create a symlink file, as shown in the example below.

```console
# ln -sf /etc/php-8.3.sample/* /etc/php-8.3/
```

## E. Create a MariaDB Database

To connect PHP and Nginx to Joomla, you must create a database. Otherwise, Joomla will not be able to connect to PHP and Nginx. The purpose of creating a database is simply to store all your work activities.

In this article, we assume you have already installed MariaDB. So, let's move on to creating a database and a username for logging into Joomla.

```yml
ns3# mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 11.4.5-MariaDB OpenBSD port: mariadb-server-11.4.5p0v1

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE DATABASE joomladb;
Query OK, 1 row affected (0.195 sec)

MariaDB [(none)]> CREATE USER 'userjoomla'@'localhost' IDENTIFIED BY 'passwdusejoomla';
Query OK, 0 rows affected (0.414 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON joomladb.* TO 'userjoomla'@'localhost';
Query OK, 0 rows affected (0.252 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]>
```

In the command above, you create a database:

- Database Name: **joomladb**
- User Name: **userjoomla**
- Password: **passwdusejoomla**
- Connection: **127.0.0.1 (localhost)**

## F. NGINX Configuration

This section is crucial because Nginx allows Joomla applications to be displayed in a web browser and published publicly. In this article, we assume you have already installed Nginx. So, let's jump straight into configuring Nginx.

To make it easier to understand, below is an example of the `/etc/nginx/nginx.conf` file we use.

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

After that we create the file `"/etc/nginx/vhostsSSL.conf"`.

```console
ns3# touch /etc/nginx/vhostsSSL.conf
```

In the file `"/etc/nginx/vhostsSSL.conf"`, you type the script as in the following example.

```console
server {
        listen       443 ssl;
        server_name  unixwinbsd.site;
        root         /var/www/joomla;
	index index.php index.html index.htm default.html default.htm;

        ssl_certificate      /etc/nginx/SSL/nginxssl.crt;
        ssl_certificate_key  /etc/nginx/SSL/nginxssl.key;
        ssl_session_timeout  5m;
        ssl_session_cache    shared:SSL:1m;

        ssl_ciphers  HIGH:!aNULL:!MD5:!RC4;
        ssl_prefer_server_ciphers   on;

gzip on;
gzip_static on;
gzip_http_version 1.1;
gzip_comp_level 6;
gzip_min_length 1100;
gzip_buffers 4 8k;
gzip_types text/plain application/xhtml+xml text/css application/xml application/xml+rss text/javascript application/javascript application/x-javascript
gzip_proxied any;
gzip_disable "MSIE [1-6]\.";

location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass   unix:run/php-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
	    root         /var/www/joomla;
    }

 # Support API
    location /api/ {
	try_files $uri $uri/ /api/index.php?$args;
    }

    # Support Clean (aka Search Engine Friendly) URLs
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

 # add global x-content-type-options header
    add_header X-Content-Type-Options nosniff;

    # deny running scripts inside writable directories
    location ~* /(images|cache|media|logs|tmp)/.*\.(php|pl|py|jsp|asp|sh|cgi)$ {
        return 403;
        error_page 403 /403_error.html;
    }

 # caching of files 
    location ~* \.(ico|pdf|flv)$ {
        expires 1y;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|swf|xml|txt)$ {
        expires 14d;
    }

    }
```

## G. Install Joomla

On OpenBSD, the Joomla repository is not available; you must download Joomla from GitHub or the official Joomla website. In this article, we will download Joomla from the GitHub repository. Note the commands below to download Joomla from GitHub and extract it directly to the `/var/www/joomla` directory.

```console
ns3# mkdir -p /var/www/joomla
ns3# cd /var/www/joomla
ns3# curl -LO https://github.com/joomla/joomla-cms/releases/download/5.3.0/Joomla_5.3.0-Stable-Full_Package.tar.gz
ns3# tar -xzvf Joomla_5.3.0-Stable-Full_Package.tar.gz
```

After that, you run the chown and chmod commands, as in the following example.

```console
ns3# chown -R www:www /var/www/joomla
ns3# chmod -R 775 /var/www/joomla
```

<br/>
### a. Editing the /var/www/joomla/installation/configuration.php-dist File

The `/var/www/joomla/installation/configuration.php-dist` file contains the Joomla configuration script for connecting to PHP and Nginx. This file contains the database settings.

Enter the name, username, and password for the MariaDB database you created above.

See the **example script** for the `/var/www/joomla/installation/configuration.php-dist` file below.

```console
<?php
/**
 * @package    Joomla.Installation
 *
 * @copyright  (C) 2005 Open Source Matters, Inc. <https://www.joomla.org>
 * @license    GNU General Public License version 2 or later; see LICENSE.txt
 *
 * -------------------------------------------------------------------------
 * THIS SHOULD ONLY BE USED AS A LAST RESORT WHEN THE WEB INSTALLER FAILS
 *
 * If you are installing Joomla! manually ie not using the web browser installer
 * then rename this file to configuration.php eg
 *
 * UNIX -> mv configuration.php-dist configuration.php
 * Windows -> rename configuration.php-dist configuration.php
 *
 * Now edit this file and configure the parameters for your site and
 * database.
 *
 * Finally move this file to the root folder of your Joomla installation eg
 *
 * UNIX -> mv configuration.php ../
 * Windows -> copy configuration.php ../
 *
 */
class JConfig
{
	/* Site Settings */
	public $offline = false;
	public $offline_message = 'This site is down for maintenance.<br> Please check back again soon.';
	public $display_offline_message = 1;
	public $offline_image = '';
	public $sitename = 'unixwinbsd.site;';            // Name of Joomla site
	public $editor = 'tinymce';
	public $captcha = 0;
	public $list_limit = 20;
	public $access = 1;
	public $frontediting = 1;

	/* Database Settings */
	public $dbtype = 'mysqli';               // Normally mysqli
	public $host = '127.0.0.1';              // This is normally set to localhost
	public $user = 'userjoomla';                       // Database username
	public $password = 'passwdusejoomla';                   // Database password
	public $db = 'joomladb';                         // Database name
	public $dbprefix = 'jos_';               // Any random string ending with _
	public $dbencryption = 0;
	public $dbsslverifyservercert = false;
	public $dbsslkey = '';
	public $dbsslcert = '';
	public $dbsslca = '';
	public $dbsslcipher = '';

	/* Server Settings */
	public $secret = '';     // Use something very secure. For example on linux the following command `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-16} | head -n 1`
	public $gzip = false;
	public $error_reporting = 'default';
	public $helpurl = 'https://help.joomla.org/proxy?keyref=Help{major}{minor}:{keyref}&lang={langcode}';
	public $tmp_path = '/tmp';                // This path needs to be writable by Joomla!
	public $log_path = '/administrator/logs'; // This path needs to be writable by Joomla!
	public $live_site = '';                   // Optional, full URL to Joomla install eg https://www.example.com
	public $force_ssl = 0;                    // Force areas of the site to be SSL ONLY.  0 = None, 1 = Administrator, 2 = Both Site and Administrator

	/* Locale Settings */
	public $offset = 'UTC';

	/* Session settings */
	public $lifetime = 15;                    // Session time
	public $session_handler = 'database';
	public $shared_session = false;
	public $session_filesystem_path = '';
	public $session_memcached_server_host = 'localhost';
	public $session_memcached_server_port = 11211;
	public $session_metadata = true;
	public $session_redis_persist = 1;
	public $session_redis_server_auth = '';
	public $session_redis_server_db = 0;
	public $session_redis_server_host = 'localhost';
	public $session_redis_server_port = 6379;

	/* Mail Settings */
	public $mailonline  = true;
	public $mailer      = 'mail';
	public $mailfrom    = '';
	public $fromname    = '';
	public $massmailoff = false;
	public $replyto     = '';
	public $replytoname = '';
	public $sendmail    = '/usr/sbin/sendmail';
	public $smtpauth    = false;
	public $smtpuser    = '';
	public $smtppass    = '';
	public $smtphost    = 'localhost';
	public $smtpsecure  = 'none';
	public $smtpport    = 25;

	/* Cache Settings */
	public $caching = 0;
	public $cachetime = 15;
	public $cache_handler = 'file';
	public $cache_platformprefix = false;
	public $memcached_persist = true;
	public $memcached_compress = false;
	public $memcached_server_host = 'localhost';
	public $memcached_server_port = 11211;
	public $redis_persist = true;
	public $redis_server_host = 'localhost';
	public $redis_server_port = 6379;
	public $redis_server_auth = '';
	public $redis_server_db = 0;

	/* Log Settings */
	public $log_categories = '';
	public $log_category_mode = 0;
	public $log_deprecated = 0;
	public $log_everything = 0;
	public $log_priorities = array('0' => 'all');

	/* CORS Settings */
	public $cors = false;
	public $cors_allow_headers = 'Content-Type,X-Joomla-Token';
	public $cors_allow_methods = '';
	public $cors_allow_origin = '*';

	/* Proxy Settings */
	public $proxy_enable = false;
	public $proxy_host = '';
	public $proxy_port = '';
	public $proxy_user = '';
	public $proxy_pass = '';

	/* Debug Settings */
	public $debug = false;
	public $debug_lang = false;
	public $debug_lang_const = true;

	/* Meta Settings */
	public $MetaDesc = 'Joomla! - the dynamic portal engine and content management system';
	public $MetaAuthor = true;
	public $MetaVersion = false;
	public $MetaRights = '';
	public $robots = '';
	public $sitename_pagetitles = 0;

	/* SEO Settings */
	public $sef = true;
	public $sef_rewrite = false;
	public $sef_suffix = false;
	public $unicodeslugs = false;

	/* Feed Settings */
	public $feed_limit = 10;
	public $feed_email = 'none';

	/* Cookie Settings */
	public $cookie_domain = '';
	public $cookie_path = '';

	/* Miscellaneous Settings */
	public $asset_id = 1;
	public $behind_loadbalancer = false;
}
```

In the script above, the most important thing is the settings in the script, which you must adjust to the database you have created.

```yml
public $sitename = 'unixwinbsd.site;';
public $dbtype = 'mysqli';
public $host = '127.0.0.1';
public $user = 'userjoomla';
public $password = 'passwdusejoomla';
public $db = 'joomladb';
```

After you have successfully logged in and configured Joomla, the file `/var/www/joomla/installation/configuration.php-dist` will be automatically deleted by the system.

## H. Run Joomla

After everything has been configured according to the instructions above, at the end of this article, we will run Joomla. You can verify whether Joomla can run on OpenBSD or whether there is a configuration error preventing it from running.

Before running Joomla, reload all the applications you configured above, as shown in the example below.

```console
ns3# rcctl restart mysqld
ns3# rcctl restart php83_fpm
ns3# rcctl restart nginx
```

After that, open Google Chrome and type **"https://192.168.5.3/index.php"**. If you've followed all the above settings, your screen will display a menu for creating a username and password, as shown in the image below.

<br/>
<img alt="Menu ogin Joomla" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/upravlenie-polosoi-propuskaniya-pfsense-qos/blob/raw?file=menu-login-joomla.png&commit=34f8823f1b0c9cfd6d0658a6b2770be41bc34f3e' | relative_url }}">
<br/>

<img alt="Joomla Database Configuration" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/database-configuration.png' | relative_url }}">
<br/>

If the image above appears, it means Joomla is now running on OpenBSD. Simply configure the menus as needed. This section is easier because you'll be guided by a wizard; simply follow the instructions.

Note: When filling in the `"Database Configuration"` menu, don't type localhost in the hostname field; type the localhost IP address `"127.0.0.1"`. If you type localhost, the Joomla dashboard won't open.

The image below shows the main Joomla dashboard after successfully connecting to Joomla.

<br/>
<img alt="cassiopeia" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/upravlenie-polosoi-propuskaniya-pfsense-qos/blob/raw?file=cassiopeia.png&commit=d41ed1314a340a69b9e82b1c0f06c77435319495' | relative_url }}">
<br/>

Now that Joomla is installed on your OpenBSD server, you can create a wide variety of beautiful and engaging websites with it.

Furthermore, Joomla is equipped with SEO techniques, you can simply configure them in the Joomla settings menu.