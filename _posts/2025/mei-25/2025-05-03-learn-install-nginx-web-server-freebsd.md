---
title: Learn How to Install NGINX Web Server on FreeBSD
date: "2025-05-03 19:05:35 +0100"
updated: "2025-05-03 19:05:35 +0100"
id: learn-install-nginx-web-server-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/Learn-nginx-freebsd.png
toc: true
comments: true
published: true
excerpt: Nginx pronounced engine-x is a powerful and versatile open-source software used as a web server, reverse proxy, load balancer, and more. It's known for its high performance, low resource utilization, and flexibility
keywords: nginx, mod_jk, modul, java, apache, server, install, freebsd, learn, web, http, https
---

In this discussion, we will try to install and configure the Nginx application. I will not explain what Nginx is, its uses and functions. Regarding Nginx, you can search for information on the internet. Here we will focus on how Nginx can run on FreeBSD.

We write this tutorial simply and systematically, to make it easier for readers to understand the contents of this article.

## A. Spesifikasi Sistem:
- OS: FreeBSD 13.2 Stable
- CPU: AMD Phenom(tm) II X4 955 Processor
- IP Server: 192.168.9.3
- Hostname: router2
- Domain: unixexplore.com
- nginx version: nginx/1.24.0 (nginx-quic)


## 1. Step 1 Installation
```
root@router2:~ # cd /usr/ports/www/nginx
root@router2:~ # make install clean
```
The installation is declared complete when the following image appears:

<br/>
{% lazyload data-src="/img/oct-25/Learn-nginx-freebsd.png" src="/img/oct-25/Learn-nginx-freebsd.png" alt="command how to install nginx on freebsd" %}
<br/>

In the final installation message in the image above it says the Nginx user and group are "www"

## 2. Step 2 File Ownership and Permissions

According to the instructions in the image above, we will grant file ownership rights to:

```
root@router2:~ # chown -R www:www /var/log/nginx
root@router2:~ # chown -R www:www /usr/local/www
root@router2:~ # chown -R www:www /usr/local/www/
root@router2:~ # chown -R www:www /usr/local/etc/nginx
``` 
```
root@router2:~ # chmod -R 755 /var/log/nginx
root@router2:~ # chmod -R 755 /usr/local/www
root@router2:~ # chmod -R 755 /usr/local/www/
```


## 3. Step 3 Enable Nginx at Boot Time
Add the following script to the /etc/rc.conf file:

> nginx_enable="YES"

> nginx_pid_prefix="/var/run"

> nginx_reload_quiet="YES"


The function of this script is so that Nginx can be loaded when our server computer is turned off or rebooted.

![edit file rc.conf](https://gitea.com/iwanse1212/Nginx-Web-Server-On-FreeBSD-Port-80-443/raw/branch/main/edit%20file%20rc.conf.jpg)

After that restart Nginx.

```
root@router2:~ # service nginx restart
Stopping nginx.
Waiting for PIDS: 9962.
Starting nginx.
root@router2:~ # nginx -t
nginx: the configuration file /usr/local/etc/nginx/nginx.conf syntax is ok
nginx: configuration file /usr/local/etc/nginx/nginx.conf test is successful
root@router2:~ #
```


## 4. Step 4 Server Block Configuration
When using a web server, Nginx server blocks (similar to Apache virtual hosts) can be used to encapsulate configuration details and host multiple domains from a single server. We will create a domain called unixexplore.com, which corresponds to the domain on my server system. However, you should replace it with your own domain name.

Before configuring the Server Block, we edit the /etc/hosts file and insert the following script:

```
root@router2:~ # ee /etc/hosts
127.0.0.1		localhost localhost.unixexplore.com
192.168.9.3		router2 router2.unixexplore.com
```
router 2 is the hostname of the FreeBSD server
unixexplore.com is the domain name of the FreeBSD server
192.168.9.3 is the FreeBSD server IP Address (see specifications above)

By default, the server block for Nginx is located at /usr/local/www/nginx-dist. You don't need to create a server block again, just create file ownership and access rights.

```
root@router2:~ # chown -R www:www /usr/local/www/nginx-dist
root@router2:~ # chmod -R 755 /usr/local/www/nginx-dist
```
Restart Nginx.

```
root@router2:~ # service nginx restart
Stopping nginx.
Waiting for PIDS: 9986.
Starting nginx.
root@router2:~ #
```


## 5. Step 5 Test NGINX
The final step is to test Nginx. Open a Web Browser program on Windows such as Yandex, Firefox, Opera or others.

We will try to test Nginx in the Yandex browser, type our FreeBSD server IP, namely 192.168.9.3, continue by pressing the enter key on the keyboard. If you successfully install Nginx the results will be like the following image.

![nginx dashboard page](https://gitea.com/iwanse1212/Nginx-Web-Server-On-FreeBSD-Port-80-443/raw/branch/main/nginx%20dashboard%20page.png)

If it looks like the image above, it means your Nginx server is RUNNING.

In practice, there are many uses for Nginx, not only as a web server. Nginx can be used as a gateway for DNS Over TLS or can even be used as a forward or reverse proxy.

Following is the complete source code of the file nginx.conf.



```

#user  nobody;
worker_processes  1;

# This default error log path is compiled-in to make sure configuration parsing
# errors are logged somewhere, especially during unattended boot when stderr
# isn't normally logged anywhere. This path will be touched on every nginx
# start regardless of error log location configured here. See
# https://trac.nginx.org/nginx/ticket/147 for more info. 
#
#error_log  /var/log/nginx/error.log;
#

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   /usr/local/www/nginx;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/local/www/nginx-dist;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
```

Nginx is a powerful and versatile web server that has become a cornerstone of modern web infrastructure. From its beginnings as a solution to the C10K problem, Nginx is capable of handling thousands of concurrent connections. Today, Nginx has evolved into a versatile tool that can act as a reverse proxy, load balancer, and even a caching server. Its lightweight architecture, coupled with high performance and reliability, makes Nginx the preferred choice for many of the world’s largest and most trafficked websites.
