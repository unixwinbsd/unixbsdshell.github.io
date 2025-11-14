---
title: Nginx FastCGI mode and PHP-FPM 8.3 on OpenBSD 7.6
date: "2025-05-17 09:13:13 +0100"
updated: "2025-07-21 11:36:45 +0100"
id: nginx-fastcgi-mode-php-fpm-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: WebServer
background: /img/oct-25/nginx-fastcgi-php.jpg
toc: true
comments: true
published: true
excerpt: What exactly is FastCGI Mode that makes it so popular and how can it improve the performance of your website to run fast?.
keywords: nginx, mod ssl, mod, php, php-fpm, http, https, 80, 443, openssl, openbsd, web server
---

Nginx is the most preferred http and https web server by DevOps developers. Most of them like Nginx because it is easy to combine with PHP programming language. The collaboration of both makes it easy for DevOps developers to build and deploy interactive websites quickly.

Nginx is very easy to operate and can run on all operating systems. Therefore, it is not surprising that many system admins configure Nginx with PHP, and PHP-FPM on Linux, BSD, MacOS and Windows servers.

One of the reasons they like Nginx is because of the support for FastCGI Mode (Nginx + PHP-FPM). FastCGI Mode is one of the most productive Nginx features, which is often used to optimize and speed up website performance. However, when transferring a site to PHP-FPM, you need to make additional settings.

What exactly is FastCGI Mode that makes it so popular and how to improve the performance of your website so that it runs quickly. In this article, we will answer these questions and show you how to use PHP-FPM together with Nginx on an `OpenBSD 7.6` server.

<br/>
{% lazyload data-src="/img/oct-25/nginx-fastcgi-php.jpg" src="/img/oct-25/nginx-fastcgi-php.jpg" alt="Nginx FastCGI PHP" %}
<br/>

## 1. What is PHP-FPM?

PHP-FPM PHP FastCGI Process Manager is part of the default way PHP handles requests, which is via mod_php. Instead PHP-FPM runs as a separate process that communicates with the web server via the FastCGI protocol.

PHP-FPM is a PHP implementation that runs with the FastCGI protocol for PHP that improves the performance and scalability of PHP web applications.

PHP-FPM can help improve the performance of PHP applications by running the PHP process as a separate daemon from the web server.

PHP-FPM offers a number of advantages over `mod_php`.
- Performance Enhancement.
- Resource Efficiency.
- Stability and Isolation.
- Capable of providing a stable and secure environment for running PHP applications by isolating running processes.
- Customizable Pool Configuration.

In addition, another advantage of PHP-FPM is that it provides greater flexibility in managing PHP processes. For example, it is possible to apply certain settings to different groups of processes, which can optimize the performance of PHP processes. This allows you to optimize the stability and performance of your website.

## 2. System Specifications
- OS: OpenBSD 7.6
- IP address: 192.168.53
- PHP version: PHP 8.3.20
- Nginx version: nginx/1.26.2

## 3. Install NGINX
In this section we will not explain the Nginx installation process, you can read our previous article about the Nginx installation process on OpenBSD. You can adjust the Nginx version with this article, or you can also use a version below or above it.

We assume you have installed Nginx and Nginx has run normally on OpenBSD. To make it easier for you to configure the **"/etc/nginx conf"** file. Below is an example of the nginx.conf file script that we use.

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
Note the example of the **/etc/nginx/nginx.conf** script above, you see the bottom script **"include /etc/nginx/vhostsSSL.conf;"**. PHP-FPM will be run with SSL OpenSSL mode. The location of the PHP-FPM configuration file is in the **/etc/nginx** directory with the name **"vhostsSSL.conf"**.

## 4. Install PHP (PHP-FPM)
In this article we use PHP version 8.3.2, and by default that version is available in the OpenBSD package system. You can install it directly. You need to know, PHP-FPM is part of PHP, so when you install PHP, PHP-FPM is automatically installed too. Here is how to install PHP with the `pkg_add` command (choose number 3).

```console
# pkg_add php
quirks-7.50 signed on 2025-04-20T09:56:12Z
Ambiguous: choose package for php
a       0: <None>
        1: php-8.1.32p0
        2: php-8.2.28
        3: php-8.3.20
Your choice: 3
php-8.3.20: ok
The following new rcscripts were installed: /etc/rc.d/php83_fpm
See rcctl(8) for details.
New and changed readme(s):
        /usr/local/share/doc/pkg-readmes/php-8.3
```

## 5. PHP Configuration (PHP-FPM)
This process is very important, because it will determine whether PHP-FPM can be integrated with Nginx or not. If you are wrong in this process, then do not expect PHP-FPM to run with Nginx.

### 5.1. Create Symlink File
The PHP directory is located in `/etc/php-8.3`. At the beginning of the installation, this directory is still empty and will always be empty if you do not create a symlink. By default, every time you install a PHP extension, the extension file will be placed in the **/etc/php-8.3.sample** directory. Below is the command you can use to create a PHP symlink file.

```console
# ln -sf /etc/php-8.3.sample/* /etc/php-8.3/
```

In addition to the symlink files above, you also need to create 3 symlink files for PHP executable files.

```console
# ln -s /usr/local/bin/php-8.3 /usr/local/bin/php
# ln -s /usr/local/bin/php-config-8.3 /usr/local/bin/php-config
# ln -s /usr/local/bin/phpize-8.3 /usr/local/bin/phpize
```

<br/>
### 5.2. Change the Script files /etc/php-8.3.ini and /etc/php-fpm.conf
All PHP configurations are stored in the /etc/php-8.3.ini file, you can set this file as needed. In this article we only enable a few scripts. Below are some **/etc/php-8.3.ini** scripts that you should enable (leave the others as default).

```yml
memory_limit = 512M
post_max_size = 30M
upload_max_filesize = 24M
allow_url_fopen = On
```
In addition, you also have to activate some scripts in the `/etc/php-fpm.conf` file. The most important thing in this script file is that you have to activate what PHP-FPM can be run with. There are two ways to run PHP-FPM, namely with UNIX socket and IP Address. In this article, we will run PHP-FPM with UNIX socket.

Below is an example of the **/etc/php-fpm.conf** script that we activate (leave the others as default).

```yml
daemonize = yes
user = www
group = www
listen = /var/www/run/php-fpm.sock
listen.owner = www
listen.group = www
listen.mode = 0660
pm.max_children = 15
chroot = /var/www
```

<br/>
### 5.3. Enable PHP (PHP-FPM)
Even though you have installed PHP, but the PHP application is not active, you must activate PHP manually. Open the **/etc/rc.conf.local** file, and type the following script.

```console
pkg_scripts=php83_fpm
```

After that you enable PHP-FPM and start reloading.

```yml
# rcctl enable php83_fpm
# rcctl restart php83_fpm
php83_fpm(ok)
php83_fpm(ok)
```

Now that `PHP-FPM` is active, we continue by configuring Nginx.

## 6. NGINX Configuration
This section is very important, because you will set how to connect PHP-FPM with the Nginx web server. Referring to the `/etc/nginx/nginx.conf` script, which we have discussed in point **"3. Install NGINX"**. You create the `/etc/nginx/vhostsSSL.conf` file with the touch command.

```console
# touch /etc/nginx/vhostsSSL.conf
```

After that, in the `/etc/nginx/vhostsSSL.conf` file, you type the script as in the following example.

```yml
server {
        listen       443 ssl;
        server_name  datainchi.com;
        root         /var/www/htdocs/nginxssl;

        ssl_certificate      /etc/nginx/SSL/nginxssl.crt;
        ssl_certificate_key  /etc/nginx/SSL/nginxssl.key;
        ssl_session_timeout  5m;
        ssl_session_cache    shared:SSL:1m;

        ssl_ciphers  HIGH:!aNULL:!MD5:!RC4;
        ssl_prefer_server_ciphers   on;

#location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on unix socket
        #
location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass   unix:run/php-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
    }


    }
```

About how to create an SSL certificate for Nginx, you can read our previous article.

## 7. Creating PHP pages in Nginx
This page will be used to address PHP and Nginx, whether they are connected or not. To prove it, create a PHP file in the **/var/www/htdocs/nginxssl** folder, and create an **info.php** file.

```console
# mkdir -p /var/www/htdocs/nginxssl
# touch /var/www/htdocs/nginxssl/info.php
```

In the file **/var/www/htdocs/nginxssl/info.php**, you type the script as in the following example.

```yml
<?php
phpinfo();
?>
```

Reload all the applications you have configured above.

```yml
# rcctl restart php83_fpm
php83_fpm(ok)
php83_fpm(ok)
# rcctl restart nginx
nginx(ok)
nginx(ok)
```
To test Nginx and PHP-FPM, open Google Chrome and type **"https://192.168.5.3/info.php"**. See the results on your monitor screen. All information about PHP is displayed in detail.

In this guide we deliberately provide only minimal working configuration. It is highly recommended that the server administrator understand each added parameter independently. In the future, this will save you a lot of time and effort in case of an unexpected "crash" of your site.

