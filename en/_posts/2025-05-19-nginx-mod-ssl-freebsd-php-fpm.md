---
title: FreeBSD14 and NGINX WITH mod_SSL PHP-FPM
date: "2025-05-19 10:11:13 +0100"
id: nginx-mod-ssl-freebsd-php-fpm
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
excerpt: Server blocks, known in Apache as virtual hosts, are the foundation of Nginx's ability to host multiple domains from a single server.
keywords: nginx, mod ssl, mod, php, php-fpm, http, https, 80, 443, openssl, freebsd, web server
---

When you’re setting up a web server, whether for personal or commercial use, it’s important to understand how the server responds to different types of requests. This knowledge becomes especially relevant when working with Nginx, a popular web server used for its high performance and flexibility in hosting multiple websites on a single machine.

Server blocks, known in Apache as virtual hosts, are the foundation of Nginx’s ability to host multiple domains from a single server. Each block can be configured with specific rules to handle requests for different domain names. This functionality allows Nginx to serve the correct content based on the domain name of the incoming request.

In serving client requests to access the web server, NGINX does not work alone. There are other applications that help it. The role of this third-party application is not only to improve the security system but also often used to integrate NGINX so that it can communicate with other applications.

For security matters, there are many applications that can be used, but the most widely used is OpenSSL. Meanwhile, to connect NGINX with other applications such as databases, PHP is usually used.

In this article, we will discuss how to configure the NGINX web server with OpenSSL and PHP-FPM.

## 1. System Specifications
- Sistem FreeBSD: FreeBSD 14.3-PRERELEASE
- IP Address: 192.168.5.71
- Hostname: ns4
- Versi PHP: PHP83
- Versi NGINX: nginx/1.24.0
- Dependensi: php83-ctype, php83-mbstring, php83-extensions dan php83-mysqli

## 2. Configuring NGINX with OpenSSL
The main function of OpenSSL is so that NGINX can run on port 443, which is the HTTPS port supporting the SSL/TLS protocol. By default, configuring NGINX on the FreeBSD system is very easy, even with just a few commands and setting the /etc/rc.conf file on the FreeBSD system, NGINX can run properly.

However, all of that does not guarantee a security system because NGINX can only run on port 80 and does not support a database as a place to store all NGINX data. Because by default NGINX is set to port 80, before we configure PHP-FPM, it would be better if we configure port 443 first. In this article to configure port 443, we use OpenSSL.









Mengatur NGINX dan FreeBSD 14 Dengan mod_SSL dan PHP-FPM
