---
title: Nginx Configuration on OpenBSD - HTTP and HTTPS Ports
date: "2025-05-16 13:15:13 +0100"
updated: "2025-05-16 13:15:13 +0100"
id: configuration-nginx-openbsd-port-http-https-80-443
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: WebServer
background: /img/oct-25/oct-25-126.jpg
toc: true
comments: true
published: true
excerpt: Currently, Nginx is popular and equipped with various sophisticated features, so it will make your website look more attractive and of course powerful.
keywords: nginx, openbsd, web server, http, https, port, 80, 443, load balancer, reverse, proxy
---

Talking about web servers, what comes to mind for most of us is Apache. Okay, that's right, because Apache is one of the most popular web servers in the world and is widely used by many websites in cyberspace.

However, this time I will not discuss the Apache web server, this time I will discuss one of the web servers that is currently on the rise and starting to be popular, namely Nginx.

Nginx is an open source web server like Apache, but it is very light and fast in processing. Since its release, Nginx has only functioned as HTTP or as a web serving only. Unlike Apache which has complete features with various modules embedded in it, this actually makes it heavier.

Currently, Nginx is popular and equipped with various sophisticated features, so it will make your website look more attractive and of course powerful.

Nginx also has many features and can be used as various servers, such as:
- Reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols.
- HTTP load balancer and cache.
- Front-end proxy for Apache and other web servers, combining the flexibility of Apache with the great static content performance of Nginx.

## 1. How to Install Nginx
Of course, this is not the only tutorial explaining how to install Nginx. However, we have made the content of this article simple to make it easier for readers to understand the contents of the article.

To install Nginx on OpenBSD, you can do it in two ways, namely `pkg_add and ports`. In order for all libraries to be installed completely, we will use the ports system to install Nginx. Run the command below to start the Nginx installation process.

First, we will check the version of `Nginx` available in the `OpenBSD repository`.

```yml
foo# pkg_info -Q nginx
nginx-1.24.0p0
```
After knowing the version of Nginx in the OpenBSD repository, we start installing Nginx.

```console
foo# cd /usr/ports/www/nginx
foo# make build
foo# make install
foo# make clean
```

Alternatively, if you want to install Nginx with pkg_add, run the command below.

```console
foo# pkg_add nginx-1.24.0p0
```

After that, you start and enable Nginx to start at boot time on OpenBSD.

```console
foo# rcctl enable nginx
foo# rcctl restart nginx
```

## 2. Configure Nginx Port 80 HTTP

On OpenBSD, the main Nginx configuration file is located in the **/etc/nginx** directory. In that directory there is a file called nginx.conf. This file is the file that controls all Nginx behavior on the OpenBSD server.

Before continuing this discussion, make sure Nginx is running normally on OpenBSD. To configure Nginx port 80 or http, we will create a virtual host for port 80. To do this, open the `nginx.conf` file then delete all the contents of the script and replace it with the script below.

```yml
foo# cd /etc/nginx
foo# nano nginx.conf
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
    
include /etc/nginx/vhosts.conf;
}
```

After that, you create a vhosts.conf file.

```console
foo# touch /etc/nginx/vhosts.conf
```

In the **/etc/vhosts.conf** file, type the script below to run Nginx port 80.

```yml
foo# nano /etc/nginx/vhosts.conf
server {
        listen       80;
        listen       [::]:80;
        server_name  datainchi.com;
        root         /var/www/htdocs/serverblock;
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
        root  /var/www/htdocs/serverblock;
        }
    }
```

Create a directory for the virtual host, run the command below to create the **/var/www/htdocs/serverblock** directory.

```console
foo# mkdir -p /var/www/htdocs/serverblock
```
Proceed by creating an **index.html** file and run the command to create ownership and permissions.

```console
foo# touch /var/www/htdocs/serverblock/index.html
foo# chown -R www:www /var/www/htdocs/serverblock/
foo# chmod -R 775 /var/www/htdocs/serverblock
```

In the index.html file, type the script as in the example below.

```yml
foo# nano /var/www/htdocs/serverblock/index.html
<html>
<head>
<title>Nginx port 80</title>
</head>
<body>
<p align="center">Welcome to Nginx Virtual Host port HTTP</p>
</body>
</html>
```

Run Nginx with the rcctl command.

```yml
foo# rcctl restart nginx
nginx(ok)
nginx(ok)
```

To check whether the NGinx server is running normally or there are still script errors, run the curl command, as in the example below.

```yml
foo# curl 192.168.5.3:80
<html>
<head>
<title>Nginx port 80</title>
</head>
<body>
<p align="center">Welcome to Nginx Virtual Host port HTTP</p>
</body>
</html>
```

## 3. Configure Nginx Port 443 HTTPS
Once you understand how to run Nginx on port 80 or HTTP. We continue by running Nginx on port 443 or HTTPS. On port 443, NGinx requires SSL certificate encryption. Creating an SSL certificate, as the first step in starting the Nginx HTTPS configuration.

### a. Create an SSL certificate
We use OpenSSL to create SSL certificates for Nginx which is free. With OpenSSL you can create SSL certificates easily. Here is an example of creating an SSL certificate with OpenSSL.

```console
foo# cd /etc/nginx
foo# mkdir -p SSL
foo# cd SSL
```

Once you have created the SSL directory, proceed to run OpenSSL to begin generating SSL certificates.

```console
foo# openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/nginx/SSL/nginxssl.key -out /etc/nginx/SSL/nginxssl.crt
```

<br/>
### b. Create HTTPS root server
Once you have an SSL certificate, the next step is to create a virtual host directory for Nginx HTTPS and give it ownership and permissions. Take a look at the example below.

```console
foo# mkdir -p /var/www/htdocs/nginxssl
foo# chown -R www:www /var/www/htdocs/nginxssl/
foo# chmod -R 775 /var/www/htdocs/nginxssl/
```

Create an `index.html` file that we will use to test Nginx HTTPS. In the `index.html` file, type the script below.

```yml
foo# touch /var/www/htdocs/nginxssl/index.html
foo# nano /var/www/htdocs/nginxssl/index.html
<html>
<head>
<title>Nginx port 443</title>
</head>
<body>
<p align="center">Welcome to Nginx Virtual Host port 443 HTTPS</p>
</body>
</html>
```

<br/>
### c. Nginx HTTPS Configuration
To run Nginx port 443, you need to create a conf file for the HTTPS virtual host. Open the `nginx.conf` file, then add the script below.

```yml
foo# nano /etc/nginx/nginx.conf
include /etc/nginx/vhostsSSL.conf;
```

After that create a `vhostsSSL.conf` file and type the script below in the `vhostsSSL.conf` file.

```yml
foo# touch /etc/nginx/vhostsSSL.conf
foo# nano /etc/nginx/vhostsSSL.conf
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
    }
```

The next step is to run Nginx so it can run port 443 HTTPS.

```yml
foo# rcctl restart nginx
nginx(ok)
nginx(ok)
```

The last step, check the Nginx server. In this test, we use the curl command. Run the curl command as in the example below.

```yml
foo# curl -k https://192.168.5.3:443
<html>
<head>
<title>Nginx port 443</title>
</head>
<body>
<p align="center">Welcome to Nginx Virtual Host port 443 HTTPS</p>
</body>
</html>
```

If the script above looks like the command above, it means that all the configurations you have done are correct. You currently have an Nginx server running on port 80 and port 443. We recommend using port 443 for all Nginx server activities, to protect your important data.
