---
title: How to Install and Example of Using Swoole PHP on FreeBSD 14.1
date: "2025-05-06 07:05:19 +0100"
updated: "2025-05-06 07:05:19 +0100"
id: swoole-php-freebsd-install-example
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/10_diagram_swoole_php_for_freebsd.jpg
toc: true
comments: true
published: true
excerpt: Swoole is a framework for PHP based on asynchronous co-routines. Swoole is specifically designed to build large-scale concurrent systems
keywords: swoole, php, freebsd, laravel, php-fpm, nginx, web server, database
---

Swoole is a PHP framework based on asynchronous co-routines. Swoole is specifically designed for building large-scale concurrent systems. It is written in C or C++ and installed as a PHP extension. If you want to build Swoole PHP on your local computer, you must install it via pecl. Meanwhile, on FreeBSD, Swole is easily installed, and its repositories are available.

Swoole PHP originates from neighboring China and is primarily developed by Chinese developers working on large-scale applications for the Chinese market. Therefore, this product has been tested and proven in high-traffic production environments. Swoole is a truly reliable application for your work, and it's a pleasure to use.
<br/>

## 1. Advantages of Swoole PHP
Compared to other asynchronous programming frameworks or software such as Apache, Nginx, and Node.js, Swoole supports asynchronous programming through multi-threaded I/O modules (HTTP Server, WebSockets, TaskWorkers). Additionally, Swoole PHP also supports Redis, CURL, TCP/UDP protocols, and Unix sockets.

With Swoole's advantages, you can freely create large-scale PHP applications (web servers), API-enabled applications, chat systems, CMS platforms, and even applications with real-time web services.

<br/>

![diagram swoole php freebsd](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/10_diagram_swoole_php_for_freebsd.jpg)

<br/>

Swoole offers several advantages that other applications like NodeJS don't, including multiple web workers and separate task workers, coroutine support, and the ability to significantly increase request limits. Here are some of the advantages of Swoole PHP:

- event-driven
- full asynchronous non-blocking
- multi-thread reactor
- Supports Separate Task Workers
- millisecond timer
- Supports Multiple Web Workers
- async MySQL
- async task
- async read/write file system
- Can Increase Request Ceiling
- async dns lookup
- No Web Server Needed
- support IPv4/IPv6/UnixSocket/TCP/UDP
- Coroutine Support

At first glance, Swoole's features are similar to NodeJS, both have Event Loop features, provide asynchronous HTTP, network clients and sockets, you can create network servers, and much more.


## 2. Install Swoole
Installing Swoole on FreeBSD is very easy: there are no configuration files or `rc.d` startup files. To run it, simply add a PHP script. Here's how to install Swoole on FreeBSD.

```console
root@ns3:~ # cd /usr/ports/devel/pecl-swoole
root@ns3:/usr/ports/devel/pecl-swoole # make config
```

When you run the `"make config"` command, a menu will appear that you must enable along with Swoole. You should adjust these options to suit your needs and your FreeBSD system.

<br/>

![install swoole with system ports](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/11_install_swoole_with_system_ports.jpg)

<br/>



After that, continue with the command `"make install clean"`.

```console
root@ns3:/usr/ports/devel/pecl-swoole # make install clean
```

## 3. Creating a Swoole Application

To complete the tutorial, in this article, we'll provide an example of using Swoole on FreeBSD. The first step is to create a working directory. We'll place the Swoole project in `"/var/freebsd-swoole-app"`.

```
root@ns3:~ # cd /var
root@ns3:/var # mkdir -p freebsd-swoole-app
root@ns3:/var # cd freebsd-swoole-app
root@ns3:/var/freebsd-swoole-app #
```

Proceed by creating an `"index.html"` file, using your favorite editor.

```console
root@ns3:/var/freebsd-swoole-app # touch index.html
root@ns3:/var/freebsd-swoole-app # chmod -R 775 index.html
```

In the file `"/var/freebsd-swoole-app/index.html"`, type the script below.

[Click here](https://gitea.com/UnixBSDShell/Web-Static-With-Ruby-Jekyll-Site-NetBSD/raw/branch/main/img/index.html)

<br/>

Next, create a `server.php` file.

```console
root@ns3:/var/freebsd-swoole-app # touch server.php
root@ns3:/var/freebsd-swoole-app # chmod -R 775 server.php
```

In the `"/var/freebsd-swoole-app/server.php"` file, type the script below.

```php
#!/usr/bin/php
<?php
$server = new \Swoole\Http\Server('192.168.5.2', 3000);
$server->on('Request', function (\Swoole\Http\Request $request, \Swoole\Http\Response $response) {
    $response->write(file_get_contents('index.html'));
    $response->status(200);
    $response->end();
});
$server->start();
```

Note the script `\Swoole\Http\Server('192.168.5.2', 3000)`. In this script, Swoole runs with
IP = 192.168.5.2 (your FreeBSD server's private IP)
Port = 3000

Run the `"server.php"` file.

```console
root@ns3:/var/freebsd-swoole-app # php server.php
```

To see the results, you open `"Google Chrome"` and type the command `"http://192.168.5.2:3000/"`.

As additional learning, you create a file called `"app.php"` and enter the following script in that file.

```php
root@ns3:/var/freebsd-swoole-app # touch app.php
root@ns3:/var/freebsd-swoole-app # chmod 775 app.php
root@ns3:/var/freebsd-swoole-app # ee app.php

<?php
$http = new swoole\Http\Server('192.168.5.2', 3000);
$http->on('Request', function ($request, $response) {
    $response->header('Content-Type', 'text/html; charset=utf-8');
    $response->end('<h1>Hello FreeBSD Swoole' . rand(1, 9999) );
});

$http->start();
?>
```
Run Swoole file `"app.php"`.

```console
root@ns3:/var/freebsd-swoole-app # php app.php
```

Open Google Chrome and type "http://192.168.5.2:3000/" and see the results: "Hello FreeBSD Swoole" will appear.

You can also use Apache, Nginx, and Node.js to support large-scale websites. You can also use Swoole PHP. Swoole PHP is specifically designed for building large-scale, concurrent systems.