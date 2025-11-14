---
title: How to Install PHP PHP-FPM on NGINX with OpenBSD
date: "2025-05-27 19:55:13 +0100"
updated: "2025-05-27 19:55:13 +0100"
id: nginx-fastcgi-mode-php-fpm-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: WebServer
background: https://media.licdn.com/dms/image/v2/D5612AQEN1j7a-Qnl2g/article-cover_image-shrink_720_1280/B56ZbheMSlHgAI-/0/1747539511036?e=1763596800&v=beta&t=KpYo_UU_B9AdSaWI0noiH32lz53q1yuH3duGZ3jwjsQ
toc: true
comments: true
published: true
excerpt: Nginx, due to its architecture, processes requests quickly and returns static data, so the project has managed to capture a niche in the market, replacing giants such as Apache HTTP Server
keywords: nginx, extension, mod, php, php-fpm, http, https, 80, 443, openssl, openbsd, web server
---

Nginx is an excellent web server in terms of performance and security. Nginx uses the PHP-FPM (FastCGI Process Manager) interface to work together with PHP. Although nginx is already well configured by default, except for the open file cache setting, for PHP-FPM you need to set some important settings. Nginx has predictable memory usage.

Nginx, due to its architecture, processes requests quickly and returns static data, so the project has managed to capture a niche in the market, replacing giants such as Apache HTTP Server. Nginx's support for interfaces (CGI, FastCGI, etc.) allows it to be used together with external applications, such as PHP, Perl, Python, and others.

So, nginx is an HTTP server, and it can also be a proxy for TCP, UDP, IMAP, POP3, HTTP and other protocols. As far as I know, when writing nginx, the principles of event-oriented programming were used, which allows achieving fast and efficient query processing with minimal resource consumption.

This article will show the options for installing Nginx and PHP in the OpenBSD 7.6 operating system, analyze the main parameters of the nginx.conf and php-fpm.conf configuration files, and create a PHP-FPM stack.


## A. System Specifications
- root@ns2.datainchi.com
- OS: OpenBSD 7.6 amd64
- Host: Acer Aspire M1800
- Uptime: 8 mins
- Packages: 42 (pkg_info)
- Shell: ksh v5.2.14 99/07/13.2
- Terminal: /dev/ttyp0
- CPU: Intel Core 2 Duo E8400 (2) @ 3.000GHz
- Memory: 35MiB / 1775MiB
- IP Address: 192.168.5.3
- NGINX version: nginx-1.26.2
- PHP version: php-8.3.17
- PHP-FPM version: php83_fpm

<br/>
<img alt="Nginx PHP FPM OpenBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://media.licdn.com/dms/image/v2/D5612AQEN1j7a-Qnl2g/article-cover_image-shrink_720_1280/B56ZbheMSlHgAI-/0/1747539511036?e=1763596800&v=beta&t=KpYo_UU_B9AdSaWI0noiH32lz53q1yuH3duGZ3jwjsQ' | relative_url }}">
<br/>

## [B. Nginx Configuration on OpenBSD - HTTP and HTTPS Ports](https://unixwinbsd.site/en/openbsd/2025/05/16/configuration-nginx-openbsd-port-http-https-80-443/)
The Nginx installation process is the initial process that you must do. In this article we do not explain how to install Nginx on OpenBSD. You can read our previous article that discusses how to install Nginx on OpenBSD.

## [C. Install PHP and PHP-FPM](https://unixwinbsd.site/en/openbsd/2025/05/17/nginx-fastcgi-mode-php-fpm-openbsd)
PHP application is not installed when you install NGINX, but PHP-FPM will be installed automatically when you install PHP. So to be more precise, to activate PHP application you must install it first.

```console
ns2# pkg_add php
```

PHP-FPM is automatically installed with the PHP package. The next step you just need to activate `PHP-FPM`, so that it can run automatically when the server is restarted/rebooted.

```console
ns2# rcctl enable php83_fpm
ns2# rcctl restart php83_fpm
php83_fpm(ok)
php83_fpm(ok)
ns2#
```

### a. Create PHP simlink file
In order for PHP to be executed in PHP syntax, you must create 3 (three) simlinks, as in the following example.

```console
ns2# ln -s /usr/local/bin/php-8.3 /usr/local/bin/php
ns2# ln -s /usr/local/bin/php-config-8.3 /usr/local/bin/php-config
ns2# ln -s /usr/local/bin/phpize-8.3 /usr/local/bin/phpize
```

### b. Copy the *.ini file
In addition to creating a simlink file, you also have to copy several files with the `*.ini` extension.

```console
ns2# ln -sf /etc/php-8.3.sample/* /etc/php-8.3/
```

## D. How to Run PHP-FPM
Once you have enabled PHP-FPM, you will want to run/test PHP-FPM on Nginx. Follow these steps to run `PHP-FPM on Nginx`.

### a. Enable PHP-FPM in Nginx
In order for PHP-FPM to run with the Nginx web server, you must enable PHP-FPM in the Nginx configuration. Open the file **"/etc/nginx/vhostsSSL.conf"**.

**Note:** Nginx runs on the HTTPS port (443).

```console
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
            try_files      $uri $uri/ =404;
            fastcgi_pass   unix:run/php-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }


    }
```

### b. Create the file /var/www/htdocs/nginxssl/info.php
As a first step to test whether PHP-FPM is running or not, you create a file named **"info.php"**.

```console
ns2# touch /var/www/htdocs/nginxssl/info.php
```

Then in that file you type the script below.

```console
<?php
phpinfo();
?>
```


Click To View Script

### c. Run the chown command
Chown is a command in Unix operating systems such as FreeBSD and OpenBSD. The chown command is used to change the ownership of a file or directory.

```console
ns2# chown -R www:www /var/www/htdocs/nginxssl/info.php
```

### d. Open Google Chrome
In this section we will see the results of the PHP-FPM configuration above. To do this, open the Yandex or Google Chrome browser, then type **"https://192.168.5.3/info.php"**. If you only activate port 80 (http), type **"http://192.168.5.3/info.php"**.

In this article, we saw how to install php-fpm and configure it to run with Nginx. PHP-FPM provides reliability, security, scalability, and speed, and offers many performance tuning options. You can now split the standard PHP-FPM pool into multiple pools to serve different applications. This will not only improve the security of your server, but also allow you to allocate resources optimally.
