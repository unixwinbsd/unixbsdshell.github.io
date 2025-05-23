---
title: Install Joomla on OpenBSD 7.7 With Nginx PHP-FPM MariaDB
date: "2025-05-17 16:01:23 +0100"
id: install-joomla-openbsd-nginx-php-fpm-mariadb
lang: en
layout: single
author_profile: true
categories:
  - OpenBSD
tags: "WebServer"
excerpt: What exactly is FastCGI Mode that makes it so popular and how can it improve the performance of your website to run fast?.
keywords: nginx, mod ssl, mod, php, php-fpm, http, https, 80, 443, openssl, openbsd, web server
---

Website development and hosting is at the heart of any modern business, unless you’re already a professional web developer. You’ll need a fast, easy-to-manage, and reliable software system to help you get your website online.

For this, Joomla is often considered one of the best choices for web server hosting and website creation. Joomla is a free and open-source content management system (CMS) designed for building websites and online applications. Written in PHP, Joomla uses MySQL, MariaDB, or PostgreSQL databases to store content.

Joomla is known for its flexibility, comprehensive features, and active community of developers and users. With Joomla you can create a website without using HTML or CSS. That, along with its low price, makes it a favorite choice among many businesses and non-profit organizations.

Joomla offers a user-friendly interface, flexible features, and scalability. With Joomla, you can create different types of web pages, manage user access, customize the appearance, and extend its functionality using Joomla extensions. The Joomla CMS core is designed to allow the site to operate under high loads. Failure of one of the modules does not lead to a complete system crash.

Joomla is actively developed by the community and is regularly updated and is compatible with all popular web servers such as Nginx, Apache, Microsoft IIS and others. The official Joomla catalog contains a large number of add-ons. The interface is widely translated into many languages, including Russian.

## 1. What is Joomla? How Joomla CMS Works
Joomla CMS is an easy-to-use platform for creating, managing, and customizing websites. The process begins with an installation process that sets up the CMS and provides access to the administration area, where you can use the Joomla auto-installer. The administration area serves as a control panel for managing the website, including configuring settings, creating and editing content, adding extensions, and customizing the design.

Content creation and management in Joomla revolves around organizing articles into categories and using the built-in editor for formatting, embedding media, and styling. Templates play an important role in the visual appearance of the website, allowing users to choose from pre-designed templates or create their own. Templates can be customized to suit branding and design preferences.

Joomla’s extensibility is one of its standout features, offering a wide range of components, modules and plugins. Components provide core functionality, modules display specific content and plugins add specific features. These extensions can enhance the capabilities of your website and tailor it to specific requirements.

User management in Joomla allows the creation of user accounts, user groups and permissions. This allows control over website access and contributions, making it suitable for websites with multiple contributors or varying levels of access.

## 2. System Specifications
- OS: OPenBSD 7.7
- IP Address: 192.168.5.3
- Hostname: ns3
- Domain: unixwinbsd.site
- PHP version: PHP 8.3.21 (cli) (built: May  9 2025 07:05:21) (NTS)
- Nginx version: nginx/1.26.3
- MariaDB Client: mariadb-client-11.4.5v1 (installed)
- MariaDB Server: mariadb-server-11.4.5p0v1 (installed)
- PHP Dependencies: php-gd-8.3.21 php-zip-8.3.21 php-curl-8.3.21 php-bz2-8.3.21 php-intl-8.3.21 php-pdo_sqlite-8.3.21 php-mysqli-8.3.21 pecl83-imagick pecl83-redis

## 3. Editing the /etc/php-8.3.ini file
The /etc/php.ini file is the main PHP configuration file. This file contains PHP setup scripts. Almost all operating systems have the same /etc/php.ini script. In order for PHP to serve Joomla optimally, you must reset the contents of this file script.

In the **/etc/php.ini** file, you change or activate it, as in the following example:

```
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

## 4. Install PHP Extension
PHP extensions are dependencies that PHP has. There are many types of PHP dependencies, for database use usually php-pdo_sqlite and php-mysqli dependencies. These two dependencies will connect PHP to the MariaDB or MySQL database.

Below is the command to install PHP extensions.

```
ns3# pkg_add php-gd-8.3.21 php-zip-8.3.21 php-curl-8.3.21 php-bz2-8.3.21 php-intl-8.3.21 php-pdo_sqlite-8.3.21 php-mysqli-8.3.21 pecl83-imagick pecl83-redis
```
Even though you have installed the PHP extension, you cannot use it yet. In order for the extension to be directly connected to PHP, you must create a symlink file, as in the example below.

```
# ln -sf /etc/php-8.3.sample/* /etc/php-8.3/
```

## 5. Create a MariaDB Database
In order for PHP and Nginx to connect to Joomla, you must create a database. Otherwise, Joomla will not be able to connect to PHP and Nginx. The purpose of creating this database is none other than to store all the work activities that you do.

In this article, we assume that you have [installed MariaDB](https://unixwinbsd.site/en/openbsd/2025/02/11/tutorilas-mariadb-installation-configuration). So, we will continue by creating a database and username to login to Joomla.

```
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
In the command above you create a database:
- Database name: joomladb
- Username: userjoomla
- Password: passwdusejoomla
- Connection: 127.0.0.1 (localhost)

## 6. NGINX Configuration
This section is very important, because with the help of Nginx Joomla applications can be displayed in a web browser and can be published to the public. In this article we assume you have installed Nginx. So, we immediately configure Nginx.

To make it easier for you to understand, below is an example of the **/etc/nginx/nginx.conf** file that we use.

```
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
After that we create the file **"/etc/nginx/vhostsSSL.conf"**.

```
ns3# touch /etc/nginx/vhostsSSL.conf
```
In the **"/etc/nginx/vhostsSSL.conf"** file, you type the script as in the following example.

```
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

## 7. Install Joomla
On OpenBSD, Joomla repository is not available, you have to download Joomla from Github or the official Joomla website. In this article, we will download Joomla from the Github repository. Pay attention to the command below, how to download Joomla from Github and directly extract it to the **/var/www/joomla** directory.

```
ns3# mkdir -p /var/www/joomla
ns3# cd /var/www/joomla
ns3# curl -LO https://github.com/joomla/joomla-cms/releases/download/5.3.0/Joomla_5.3.0-Stable-Full_Package.tar.gz
ns3# tar -xzvf Joomla_5.3.0-Stable-Full_Package.tar.gz
```
After that, you run the chown and chmod commands, as in the following example.

```
ns3# chown -R www:www /var/www/joomla
ns3# chmod -R 775 /var/www/joomla
```

### 7.1. Editing the File /var/www/joomla/installation/configuration.php-dist

The **/var/www/joomla/installation/configuration.php-dist** file contains the Joomla configuration script to connect to PHP and Nginx. In this file there are database settings. You fill in the name, user and password of the MariaDB database that you created above.

Note the example of the **/var/www/joomla/installation/configuration.php-dist** file script, below.

```
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

- public $sitename = 'unixwinbsd.site;';
- public $dbtype = 'mysqli';
- public $host = '127.0.0.1';
- public $user = 'userjoomla';
- public $password = 'passwdusejoomla';
- public $db = 'joomladb';

After you have successfully logged in and set up Joomla, the /var/www/joomla/installation/configuration.php-dist file will be automatically deleted by the system.

## 8. Run Joomla
After you have configured everything according to the instructions above, at the end of this article we will run Joomla. You can prove whether Joomla can be run on OpenbSD or there is a wrong configuration so that Joomla cannot be run.

Before you run Joomla, reload all the applications that you have configured above, as in the example below.

```
ns3# rcctl restart mysqld
ns3# rcctl restart php83_fpm
ns3# rcctl restart nginx
```
After that you open Google Chrome, and type "https://192.168.5.3/index.php". If the configuration above is not missed, on your monitor screen will display a menu for creating a user name and password, as shown in the following image.

![MEnu Login Joomla](https://media.licdn.com/dms/image/v2/D5612AQEwU1hxnuHADg/article-inline_image-shrink_1000_1488/B56Zb.8ENZHgAQ-/0/1748033881532?e=1753315200&v=beta&t=vvTfO2zg_pEgZvyRlfIWePx4AQKzn0NMkTSjiBYC3WI)

![Database Configuration](https://media.licdn.com/dms/image/v2/D5612AQHeBI3t8CXy9Q/article-inline_image-shrink_1500_2232/B56Zb.8NZrHUAY-/0/1748033919486?e=1753315200&v=beta&t=mPlRZi4f1-OoPxgE01vC6lDtXL4k_X2jmmB7SIeALNo)

If it appears like the image above, it means that Joomla can run on OpenbSD. You only need to set the menu as needed. In this section the process is easier, because you are guided by the wizard menu, just follow each instruction given.

What you need to pay attention to is when filling in the "Database Configuration" menu. In the hostname column, do not fill in localhost, type the localhost IP "127.0.0.1". If you type localhost, the Joomla dashboard will not open.

The image below is the main Joomla dashboard after you have successfully connected to Joomla.

![Dashboar Joomla](https://media.licdn.com/dms/image/v2/D5612AQFJ-0f8qf8Ylw/article-inline_image-shrink_1500_2232/B56Zb.8R.QHcAU-/0/1748033938279?e=1753315200&v=beta&t=6CPh4pLfgAZtmVgLQDoWFYz5vHGl0-hU-DE3YATz8H0)

Now, your OpenBSD server has Joomla installed, you can create various beautiful and interesting websites with Joomla. Not only that, Joomla has been equipped with SEO techniques, you can use it by setting it in the settings menu.
