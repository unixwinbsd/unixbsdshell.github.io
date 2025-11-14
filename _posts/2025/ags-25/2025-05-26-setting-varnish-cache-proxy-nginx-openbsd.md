---
title: OpenBSD Varnish Cache Proxy With NGINX Backend
date: "2025-05-26 08:25:35 +0100"
updated: "2025-08-29 16:21:33 +0100"
id: setting-varnish-cache-proxy-nginx-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: SysAdmin
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/test%20varnish%20with%20google%20chrome.jpg&commit=b166c24f5da03ee34f8bfb1d6bcddad406173ad5
toc: true
comments: true
published: true
excerpt: Varnish is a very reliable reverse proxy server, its ability to work in front of your web server and serve content from your server, not someone else's server or a remote web server
keywords: varnish, cache, proxy, reverse, openbsd, nginx, web server, web browser, reverse proxy, install
---

Varnish is an HTTP proxy cache that can increase the speed of website access from your local network. Because, Varnish is one of the software that provides a very fast website hosting cache compared to standard web services. However, there is one major limitation, namely that it will not serve HTTPS content.

Varnish is a very reliable reverse proxy server, its ability to work in front of your web server and serve content from your server, not someone else's server or a remote web server. The reverse proxy server is closely connected to the web server and can act on messages received from it. For example, a cached page can be refreshed with a purge command from the backend, something you can't do with a cache that is closer to the client. This means that reverse proxy servers, in some cases, can store content longer than other types of caches.

In this tutorial, I will show you how to install Varnish on an `OpenBSD 7.5` server with `NGINX` as the backend.

## 1. System specifications

Make sure your server computer has the following operating system and software installed.
- OS: OpenBSD 7.5
- Hostname: ns3
- Domain: cursor.my.id
- IP address: 192.168.5.3
- Nginx version: nginx-1.24.0p0
- Nginx port: 8080
- Varnish version: varnish-7.4.2
- Varnish port: 80


## 2. Install and Configure NGINX
Since we will be using NGINX as the Varnish backend, installing NGINX is the first step you should take. Here are the commands you should type to install NGINX.

```console
ns3# pkg_add nginx
```
After that, open the `/etc/nginx/nginx.conf` file and type the following script in the file.

```html
user  www;
worker_processes  1;
worker_rlimit_nofile 1024;
events {
    worker_connections  800;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    index         index.html index.htm;
    keepalive_timeout  65;
    server_tokens off;

    server {
        listen       8080;
        listen       [::]:80;
        server_name  localhost;
        root         /var/www/htdocs;
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root  /var/www/htdocs;
        }
    }
}
```

Then create an `index.html` file to check the NGINX server. The `index.html` file is located in the `/var/www/htdocs` directory. In the `index.html` file, type the following script.

```html
<html>
<head>
<title>Nginx port 8080</title>
</head>
<body>
<h1>
<p align="center">Welcome to Nginx port HTTP</p>
<p align="center">With Varnis Cache Proxy</p>
</h1>
</body>
</html>
```

Then, run the command below, to create ownership and usage permissions for the file.

```console
ns3# chown -R www:www /var/www/htdocs/
ns3# chmod -R 775 /var/www/htdocs/
```

By default OpenBSD disables NGINX, to run NGINX, you must enable the NGINX server first. Run the following command to enable NGINX.

```console
ns3# rcctl enable nginx
ns3# rcctl restart nginx
```


## 3. Install Varnish
Varnish fetches content from an Apache or NGINX backend server, which is the web server where your content is created. In this article, we will use the NGINX web server as the Varnish backend. Installing Varnish is very easy, because OpenBSD has provided the Varnish package, you can directly install and activate Varnish with just a few commands. To install Varnish, you can run the following command.

```console
ns3# pkg_add varnish
```

After that you activate Varnish.

```console
ns3# rcctl enable varnishd
```

## 4. Configure Varnish in OpenBSD
By default, the basic Varnish configuration file can run normally, but the configuration file cannot run if you do not set the flag for the daemon. In OpenBSD, setting the flag is very important, because this flag will set all Varnish configurations. In this section we will explain how to set the flag for Varnish. The first thing you have to do is add a script to the `/etc/rc.conf` file, as in the following example.

```console
varnishd_flags=
```

After that, add another script in the `/etc/rc.conf.local` file, with the rcctl command as in the example below.

```console
ns3# rcctl set varnishd flags "-a http=192.168.5.3:80,HTTP -a proxy=192.168.5.3:6081,PROXY -j unix,user=_varnish,ccgroup=_varnish -f /etc/varnish/default.vcl -T localhost:9999 -p feature=+http2"
```

To configure Varnish, you need to edit the `/etc/varnish/default.vcl` file. By default, the default.vcl file only enables the backend. Here is a complete example script for the `/etc/varnish/default.vcl` file.

```console
vcl 4.1;

backend default {
    .host = "192.168.5.3";
    .port = "8080";
}

sub vcl_recv {
 	call vcl_builtin_recv;
 	return (hash);
 }
 
 sub vcl_builtin_recv {
 	call vcl_req_host;
 	call vcl_req_method;
 	call vcl_req_authorization;
 	call vcl_req_cookie;
 }
 
 sub vcl_req_host {
 	if (req.http.host ~ "[[:upper:]]") {
 		set req.http.host = req.http.host.lower();
 	}
 	if (!req.http.host &&
 	    req.esi_level == 0 &&
 	    req.proto == "HTTP/2") {
 		return (synth(400));
 	}
 }
 
 sub vcl_req_method {
 	if (req.method == "PRI") {
 		# This will never happen in properly formed traffic.
 		return (synth(405));
 	}
 	if (req.method != "GET" &&
 	    req.method != "HEAD" &&
 	    req.method != "PUT" &&
 	    req.method != "POST" &&
 	    req.method != "TRACE" &&
 	    req.method != "OPTIONS" &&
 	    req.method != "DELETE" &&
 	    req.method != "PATCH") {
 		# Non-RFC2616 or CONNECT which is weird.
 		return (pipe);
 	}
 	if (req.method != "GET" && req.method != "HEAD") {
 		# We only deal with GET and HEAD by default.
 		return (pass);
 	}
 }
 
 sub vcl_req_authorization {
 	if (req.http.Authorization) {
 		# Not cacheable by default.
 		return (pass);
 	}
 }
 
 sub vcl_req_cookie {
 	if (req.http.Cookie) {
 		# Risky to cache by default.
 		return (pass);
 	}
 }
 
 sub vcl_pipe {
 	call vcl_builtin_pipe;
 	# unset bereq.http.connection;
 	return (pipe);
 }
 
 sub vcl_builtin_pipe {
 }
 
 sub vcl_pass {
 	call vcl_builtin_pass;
 	return (fetch);
 }
 
 sub vcl_builtin_pass {
 }
 
 sub vcl_hash {
 	call vcl_builtin_hash;
 	return (lookup);
 }
 
 sub vcl_builtin_hash {
 	hash_data(req.url);
 	if (req.http.host) {
 		hash_data(req.http.host);
 	} else {
 		hash_data(server.ip);
 	}
 }
 
 sub vcl_purge {
 	call vcl_builtin_purge;
 	return (synth(200, "Purged"));
 }
 
 sub vcl_builtin_purge {
 }
 
 sub vcl_hit {
 	call vcl_builtin_hit;
 	return (deliver);
 }
 
 sub vcl_builtin_hit {
 }
 
 sub vcl_miss {
 	call vcl_builtin_miss;
 	return (fetch);
 }
 
 sub vcl_builtin_miss {
 }
 
 sub vcl_deliver {
 	call vcl_builtin_deliver;
 	return (deliver);
 }
 
 sub vcl_builtin_deliver {
 }

sub vcl_synth {
 	call vcl_builtin_synth;
 	return (deliver);
 }
 
sub vcl_builtin_synth {
 	set resp.http.Content-Type = "text/html; charset=utf-8";
 	set resp.http.Retry-After = "5";
 	set resp.body = {"<!DOCTYPE html>
 <html>
   <head>
     <title>"} + resp.status + " " + resp.reason + {"</title>
   </head>
   <body>
     <h1>Error "} + resp.status + " " + resp.reason + {"</h1>
     <p>"} + resp.reason + {"</p>
     <h3>Guru Meditation:</h3>
     <p>XID: "} + req.xid + {"</p>
     <hr>
     <p>Varnish cache server</p>
   </body>
 </html>
 "};
 }
 
 sub vcl_backend_fetch {
 	call vcl_builtin_backend_fetch;
 	return (fetch);
 }
 
 sub vcl_builtin_backend_fetch {
 	if (bereq.method == "GET") {
 		unset bereq.body;
 	}
 }
 
 sub vcl_backend_response {
 	call vcl_builtin_backend_response;
 	return (deliver);
 }
 
 sub vcl_builtin_backend_response {
 	if (bereq.uncacheable) {
 		return (deliver);
 	}
 	call vcl_beresp_stale;
 	call vcl_beresp_cookie;
 	call vcl_beresp_control;
 	call vcl_beresp_vary;
 }
 
 sub vcl_beresp_stale {
 	if (beresp.ttl <= 0s) {
 		call vcl_beresp_hitmiss;
 	}
 }
 
 sub vcl_beresp_cookie {
 	if (beresp.http.Set-Cookie) {
 		call vcl_beresp_hitmiss;
 	}
 }
 
 sub vcl_beresp_control {
 	if (beresp.http.Surrogate-control ~ "(?i)no-store" ||
 	    (!beresp.http.Surrogate-Control &&
 	      beresp.http.Cache-Control ~ "(?i:no-cache|no-store|private)")) {
 		call vcl_beresp_hitmiss;
 	}
 }
 
 sub vcl_beresp_vary {
 	if (beresp.http.Vary == "*") {
 		call vcl_beresp_hitmiss;
 	}
 }
 
 sub vcl_beresp_hitmiss {
 	set beresp.ttl = 120s;
 	set beresp.uncacheable = true;
 	return (deliver);
 }
 
sub vcl_backend_error {
 	call vcl_builtin_backend_error;
 	return (deliver);
 }
 
sub vcl_builtin_backend_error {
 	set beresp.http.Content-Type = "text/html; charset=utf-8";
 	set beresp.http.Retry-After = "5";
 	set beresp.body = {"<!DOCTYPE html>
 <html>
   <head>
     <title>"} + beresp.status + " " + beresp.reason + {"</title>
   </head>
   <body>
     <h1>Error "} + beresp.status + " " + beresp.reason + {"</h1>
     <p>"} + beresp.reason + {"</p>
     <h3>Guru Meditation:</h3>
     <p>XID: "} + bereq.xid + {"</p>
     <hr>
     <p>Varnish cache server</p>
   </body>
 </html>
 "};
 }

sub vcl_init {
 	return (ok);
 }
 
 sub vcl_fini {
 	return (ok);
 }
```

The final step is to run Varnish with the rcctl command.

```console
ns3# rcctl restart varnishd
varnishd(ok)
varnishd(ok)
```

## 5. Test Varnish With Web Browser
To be more sure whether varnis has worked as a proxy cache from Nginx, we have to do a test to prove it. You can do this test on the Google Chrome, Yandex or other web browsers.

In the Google Chrome address bar menu, type the varnis IP address, which is `http://192.168.5.3:8080/`. The results will be visible on your monitor screen as shown in the following image.


![test varnish with google chrome](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/test%20varnish%20with%20google%20chrome.jpg&commit=b166c24f5da03ee34f8bfb1d6bcddad406173ad5)

Congratulations, you have successfully installed Varnish on OpenBSD and now you have a simple setup to speed up your site. In this article, you learned the basics of Varnish, the process of installing and configuring Varnish, what Varnish is, and what the default settings are. We also briefly discussed VCL, Varnish’s configuration language.

VCL can be a bit tricky to understand, especially since it’s an unconventional way to do configuration, but it’s actually very easy to use once you read this article, and it’s also more flexible than configuration files. If you’d like to continue learning about Varnish, visit varnish-cache.org for more information.