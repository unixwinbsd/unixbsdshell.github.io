---
title: FreeBSD Lighttpd Plus Mod OpenSSL Installation and Configuration
date: "2025-09-28 14:14:29 +0100"
updated: "2025-09-28 14:14:29 +0100"
id: freebsd-lighttpd-plus-mod-openssl-installation
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-67.jpg
toc: true
comments: true
published: true
excerpt: In this article, you will learn how to install and configure Lighttpd on a FreeBSD server. Furthermore, to improve the security of the Lighttp web server, we have also added OpenSSL mode to this article.
keywords: freebsd, lighttpd, installation, configuration, plus, mod, openssl, ssl, http, https
---

This web server, distributed under the BSD license, is one of the lightest, most secure, and fastest web servers. It is highly reliable in high-performance environments with a small memory footprint compared to other web servers, and effectively manages CPU load from an extended set of functions such as SCGI, Output Compression, Auth, FastCGI, URL Rewriting, and many others.

For users experiencing heavy workloads when operating a web server, Lighttpd is an ideal solution. Lighttpd is a great alternative to the widely used Nginx and Apache web servers. Because Lighttpd is a lightweight, open-source web server optimized for high-speed environments and low resource usage, it reduces CPU performance.

In web server processing, you probably already know that some sites process thousands of files in parallel, requiring large amounts of memory and a high maximum number of threads or processes.

To address this issue, Dan Kegel detailed the problem of processing thousands of concurrent requests in his C10K problem page. In 2003, a German MySQL developer named `Jan Kneschke` became interested in this problem and decided that he could write a faster web server than Apache by focusing on the right techniques.

`Jan Kneschke` then designed lighttpd as a single process with a single thread and non-blocking I/O. Lighttpd also uses the fastest event handler on the target system: polling, epoll, kqueue, or `/dev/polling`. Lighttpd prefers unconnected system calls like sendfile over reads and writes. The result of his efforts was that, within a few months, lighttpd began processing static files faster than Apache.

In this article, you will learn how to install and configure Lighttpd on a FreeBSD server. Furthermore, to improve the security of the Lighttp web server, we have also added OpenSSL mode to this article.

## A. System specifications

- OS: FreeBSD 13.2 Stable
- Hostname: ns5
- IP Address: 192.168.5.2
- Domain: datainchi.com
- Lighttpd version: lighttpd/1.4.67 (ssl) - a light and fast webserver

## B. Lighttpd Installation Process

As you may know, on FreeBSD servers, there are two ways to install each application: the port system and the PKG package. For Lighttpd installations, we prefer using the port system because it allows you to build all the libraries Lighttpd requires.

Before starting the Lighttpd installation process, you must first install the Lighttpd dependencies, namely `"Build dependencies"` and `"Library dependencies"`. Here's how to install these dependencies.

```
root@ns5:~ # pkg install cmake-core ninja pkgconf
```

The above command is used to install `Build dependencies`. Now we install the `"Library dependencies"` that Lighttpd will use.

```
root@ns5:~ # pkg install pcre2 nettle lua54
```

We have installed all the dependencies, we continue by installing Lighttpd.

```
root@ns5:~ # cd /usr/ports/www/lighttpd
root@ns5:/usr/ports/www/lighttpd # make config
```

In the `make config` command, you have to enable some options, since we will use the OpenSSL mod, enable the `OPENSSL` option.

![lighttpd installation menu](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-66.jpg)


Use the `make install clean` command to start the installation process.

```
root@ns5:/usr/ports/www/lighttpd # make install clean
```

## C. Create Start Up rc.d

You certainly don't want to have to run every application manually. Running Lighttpd manually would be incredibly cumbersome. Here's how to automate Lighttpd on your FreeBSD server.

Linux uses systemd to automate applications, while FreeBSD uses rc.d. To automate your Lighttpd, open the `/etc/rc/conf` file and type the following command.

```
lighttpd_enable="YES"
lighttpd_conf="/usr/local/etc/lighttpd/lighttpd.conf"
lighttpd_pidfile="/var/run/lighttpd.pid"
lighttpd_instances=""
```

In the script above, the Lighttpd configuration file is located in the `/usr/local/etc/lighttpd` folder, with the configuration file name `lighttpd.conf`.

You can run Lighttpd with the following command.

```
root@ns5:~ # service lighttpd restart
```

## D. Lighttpd Configuration

Lighttpd's main configuration file is `/usr/local/etc/lighttpd/lighttpd.conf`. Open that file and edit only the scripts you need. To enable private ports and IP addresses, run the script below.


```
server.port = 80
server.use-ipv6 = "disable"
server.bind = "192.168.5.2"
server.username  = "www"
server.groupname = "www"
server.document-root = "/usr/local/www" + "/data"
server.pid-file = state_dir + "/lighttpd.pid"
```

For those of you new to Lighttpd, configuring the `"log"` is important, as many things fail or Lighttpd won't start because of incorrect `"log"` configuration. Follow the script below to configure the `"log"`.

```
server.errorlog-use-syslog = "enable"
include conf_dir + "/conf.d/debug.conf"
```

The above log configuration will grant LightTPD the privileges to manage its own logs.

Often, when running LightTPD, an error message like the following appears.

> 2024-01-15 10:31:51: (configfile.c.1287) WARNING: unknown config-key: dir-listing.encoding (ignored)

> 2024-01-15 10:31:51: (configfile.c.1287) WARNING: unknown config-key: dir-listing.exclude (ignored)


To overcome this, you can enable the `dir-listing.activate` option in the `"/usr/local/etc/lighttpd/lighttpd.conf"` file.

```
include conf_dir + "/conf.d/dirlisting.conf"
dir-listing.activate = "enable"
```

Now you are running Lighttpd.

```
root@ns5:~ # service lighttpd restart
Performing sanity check on lighttpd configuration:
Stopping lighttpd.
Waiting for PIDS: 12730.
Starting lighttpd.
```

You can see the complete script for the file `/usr/local/etc/lighttpd/lighttpd.conf` at [Github unixwinbsd](https://github.com/unixwinbsd/FreeBSD_Lighttpd_Mod_OpenSSL)

All Lighttpd data is stored in the `/usr/local/www/data` folder. Create an `index.html` file and type the script you downloaded from [GitHub unixwinbsd](https://github.com/unixwinbsd/FreeBSD_Lighttpd_Mod_OpenSSL).

```
root@ns5:~ # cd /usr/local/www
root@ns5:/usr/local/www # mkdir -p data
root@ns5:/usr/local/www # cd data
root@ns5:/usr/local/www/data # touch index.html
root@ns5:/usr/local/www/data # chown -R www:www /usr/local/www/data/
```

## E. Create Openssl Mod

The primary function of encryption is to convert plaintext communications into ciphertext that cannot be read by unauthorized parties. All sensitive user data, such as login credentials and personal information, is encrypted before being sent over the network. Then, only the recipient with the correct decryption key can access the website.

Generally, web servers use two primary encryption protocols:

- SSL: Secure Sockets Layer.
- TLS: Transport Layer Security (pengganti SSL).

Lighttpd also has very advanced encryption capabilities. There are many ways to encrypt a web server. In this article, we'll only discuss encryption with OpenSSL.

As a first step, we'll generate private keys and CSRs. We'll save the private key and CSR files in the `/etc/ssl` directory on FreeBSD. Activate that directory and run the command below.

```
root@ns5:~ # cd /etc/ssl
root@ns5:/etc/ssl # openssl genrsa -out /etc/ssl/unixwinbsd.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
....................................................................................................................................................++++
.........................++++
e is 65537 (0x010001)
```

For better security, set restricted file permissions to 400 or 600.

```
root@ns5:/etc/ssl # chmod 400 /etc/ssl/unixwinbsd.key
```

The next step is to create a .csr file that provides the necessary domain/organization details about your website.

```
root@ns5:/etc/ssl # openssl req -new -sha256 -key /etc/ssl/unixwinbsd.key -out /etc/ssl/unixwinbsd.csr
```

Sign your CSR file.


```
root@ns5:/etc/ssl # openssl x509 -req -days 365 -in unixwinbsd.csr -signkey unixwinbsd.key -out unixwinbsd.crt
Signature ok
```

Combine the primary certificate, intermediate certificate, and private key into one.

```
root@ns5:/etc/ssl # cat unixwinbsd.crt unixwinbsd.key > unixwinbsd-ssl.pem
```

Once you've successfully created an SSL certificate, edit the Lighttpd configuration file, `/usr/local/etc/lighttpd/lighttpd.conf`.

Enter the script below to enable OpenSSL in Lighttpd.

```
server.modules += ( "mod_openssl" )
ssl.pemfile = "/etc/ssl/unixwinbsd-ssl.pem"

   $SERVER["socket"] == "*:443" {
     ssl.engine  = "enable"
   }
```

## F. Test Lighttpd

As a final step in the above configuration, we perform a test, run the Lighttpd web server first with the following command.

```
root@ns5:/etc/ssl # service lighttpd restart
```

If with the command above, an error occurs in the SSL file, because Lighttpd is often slow in responding to the SSL file you created, to avoid this, you can repeat the command.

```
root@ns5:/etc/ssl # openssl x509 -req -days 365 -in unixwinbsd.csr -signkey unixwinbsd.key -out unixwinbsd.crt
root@ns5:/etc/ssl # cat unixwinbsd.crt unixwinbsd.key > unixwinbsd-ssl.pem
```

Now open the Google Chrome web browser, and in the address bar, type `"http://192.168.5.2"` or `"https://192.168.5.2."` The result will look like the image below.

![Test-Results lighttpd](/img/oct-25/oct-25-67.jpg)


Download the full script [Instalasi dan Konfigurasi FreeBSD Lighttpd Plus Mod OpenSSL](https://github.com/unixwinbsd/FreeBSD_Lighttpd_Mod_OpenSSL.git)

In conclusion, Lighttpd is a lightweight, efficient, robust, and versatile web server that stands out among other web server software like NGINX and Apache. Its event-driven architecture, advanced features, and focus on security make it an excellent choice for serving web content across a variety of environments.