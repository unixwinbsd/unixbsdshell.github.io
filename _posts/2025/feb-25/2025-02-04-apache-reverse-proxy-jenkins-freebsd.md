---
title: Apache as Reverse Proxy Jenkins CI CID on FreeBSD Server
date: "2025-02-04 10:11:21 +0100"
updated: "2025-06-04 09:11:21 +0100"
id: apache-reverse-proxy-jenkins-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/ApacheImplementationjenkins-reverseproxy.jpg
toc: true
comments: true
published: true
excerpt: A reverse proxy is a type of proxy server that accepts HTTP/HTTPS requests and transparently distributes them to one or more backend servers. Reverse proxies are useful because many modern web applications handle incoming HTTP/HTTPS requests using backend application servers that do not need to be directly accessible to users and often only support basic HTTP functionality.
keywords: apache, proxy, reverse, jenkins, ci, cid, freebsd, installation, github, gitlab
---

If you are running Jenkins on a Unix environment, you may want to hide it behind an Apache HTTP server to align the server URL and simplify maintenance and access. This way, users can access the Jenkins server using a proxy URL from apache. One way to do this is by using the Apache modules mod_proxy and mod_proxy_ajp. These modules allow you to use proxying on the Apache server.

A reverse proxy is a type of proxy server that accepts HTTP/HTTPS requests and transparently distributes them to one or more backend servers. Reverse proxies are useful because many modern web applications handle incoming HTTP/HTTPS requests using backend application servers that do not need to be directly accessible to users and often only support basic HTTP functionality.

In its use, we can use a reverse proxy to prevent direct access to the main application server. A reverse proxy can also be used to balance incoming requests across multiple application servers, improving performance at scale, and providing fault tolerance. A reverse proxy will fill in the gaps with application server features that it does not provide, such as caching, compression, and SSL encryption.

<br/>
![Apache Implementation as jenkins reverse proxy](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/ApacheImplementationjenkins-reverseproxy.jpg)
<br/>

This article will explain how to set up Apache as the main reverse proxy server using the mod_proxy extension to redirect incoming connections to one or more internal servers running on the same network.

## A. System Specifications
- OS: FreeBSD 13.2
- Server IP: 192.168.5.2
- Domain: unixwinbsd.site
- Apache version: Apache24
- Jenkin IP: 192.168.5.2
- Port Jenkins: 8180
- Apache IP: 192.168.5.2
- Apache Reverse Proxy Ports: 8080

## B. Enable Apache24 proxy mod
In order for Apache24 to be used as a reverse proxy server, the proxy module in Apache24 must be enabled first. To do this, edit the `/usr/local/etc/apache24/httpd.conf` file and remove the **"#"** sign in the loadmodule script, as in the example below:


```console
root@ns1:~ # ee /usr/local/etc/apache24/httpd.conf
LoadModule proxy_module libexec/apache24/mod_proxy.so
LoadModule proxy_http_module libexec/apache24/mod_proxy_http.so
LoadModule proxy_connect_module libexec/apache24/mod_proxy_connect.so
LoadModule proxy_ftp_module libexec/apache24/mod_proxy_ftp.so
```
So far, we haven't talked much about `mod_proxy`. However, mod_proxy is actually a bit more complicated than that. In keeping with Apache's modular architecture, `mod_proxy` itself is modular, and proxy servers typically need to have several modules enabled. The modules relevant to proxies and this article include:

- `mod_proxy:` Core module handles proxy infrastructure and configuration and manages proxy requests.
- `mod_proxy_http:` Handles document fetching with HTTP and HTTPS.
- `mod_proxy_ftp:` Handles document fetching with FTP.
- `mod_proxy_connect:` Handles the CONNECT method for secure tunneling (SSL).
- `mod_proxy_ajp:` Handles the AJP protocol for Tomcat and similar backend servers.
- `mod_proxy_balancer:` Implements clustering and load balancing across multiple backends.
- `mod_cache, mod_disk_cache, mod_mem_cache:` These mods handle document cache management. To enable caching, mod_cache and one or both disk_cache and mem_cache are required.

- `mod_proxy_html:` This mod will rewrite HTML links into the proxy address space.
- `mod_headers:` Will modify HTTP request and response headers.
- `mod_deflate:` Negotiates compression with the client and backend.

## C. Change Apache Default Port
Since Apache runs on port `80`, the reverse proxy must also be on port `8080`, change the apache24 port in the `/usr/local/etc/apache24/httpd.conf` file.

```console
root@ns1:~ # ee /usr/local/etc/apache24/httpd.conf
Listen 192.168.5.2:8080
ServerName www.unixwinbsd.site:8080
```
Now, let's configure a default HTTP vhost that will accept all proxy requests. Open the httpd-vhosts.conf file and edit it. In this article we will make Jenkins a "Backend" proxy for apache24.

We suggest, before continuing this article you should also read another article "How to Configure Jenkins Continuous Integration on FreeBSD" which is related to Jenkins Configuration on FreeBSD.

After we configure Jenkins, we get Jenkins ID: iwanse1212. Enter the script below in the file `/usr/local/etc/apache24/extra/httpd-vhosts.conf`.

```html
root@ns1:~ # ee /usr/local/etc/apache24/extra/httpd-vhosts.conf
<Virtualhost 192.168.5.2:8080>
    ServerName        iwanse1212
    ProxyRequests     Off
    ProxyPreserveHost On
    AllowEncodedSlashes NoDecode
 
    <Proxy http://192.168.5.2:8180/*>
      Order deny,allow
      Allow from all
    </Proxy>
 
    ProxyPass         /  http://192.168.5.2:8180/ nocanon
    ProxyPassReverse  /  http://192.168.5.2:8180/
    ProxyPassReverse  /  http://iwanse1212/
</Virtualhost>
```
In the above script, it is clear that we will run apache24 reverse proxy with private IP `192.168.5.2` with port `8080`. While the server name "iwanse1212" is the Jenkins user ID. After that, we restart the apache web server, so that it can load the Jenkins proxy.

```console
root@ns1:~ # service apache24 restart
Performing sanity check on apache24 configuration:
Syntax OK
Stopping apache24.
Waiting for PIDS: 74121.
Performing sanity check on apache24 configuration:
Syntax OK
Starting apache24.
```
After that, we test by opening the `Yandex or Google Chrome web browser`, type `"http://192.168.5.2:8080"` in the browser address bar menu. See the results on your Google Chrome screen.

I am sure, the information in the article above will be useful for you. However, there are hundreds of other creative people who may also need other information to complete their knowledge about Apache and Jenkins servers.