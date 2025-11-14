---
title: DokuWiki Implementation on FreeBSD - Installation and Configuration
date: "2025-10-01 07:45:51 +0100"
updated: "2025-10-01 07:45:51 +0100"
id: dokuwiki-on-freebsd-installation-configuration
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-56.jpg
toc: true
comments: true
published: true
excerpt: DokuWiki is very easy to use and versatile and does not require a database. This program is well-liked by users for its clean and easy-to-read syntax. Ease of maintenance, backup, and integration make it an administrator favorite
keywords: dokuwiki, archive, freebsd, nginx, apache, web server, openbsd, installation, configuration, setup, repository, open source
---

Maybe for some people DokuWiki still sounds strange. DokuWiki is still less popular than its sibling Wikipedia. DokuWiki, created in 2004 by Andreas Gohr, is a free Open Source program for wiki software. If you are familiar with Wikipedia, then you will understand what DokuWIki is designed for. DokuWiki software is designed primarily to store information and manage it with site contributors. In other words, DokuWiki is an open repository of information created by different people who edit the site. This makes it easier to create content for a wiki site and have it sponsored by more than one person.


DokuWiki is very easy to use and versatile and does not require a database. This program is well-liked by users for its clean and easy-to-read syntax. Ease of maintenance, backup, and integration make it an administrator favorite. Built-in access controls and authentication connectors make DokuWiki especially useful in enterprise contexts and the many plugins contributed by its active community enable a variety of use cases beyond traditional wikis.

![oct-25-5](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-5.jpg)


## 1. Why Choose DokuWiki?

DokuWiki falls into the category of popular choices when choosing Wiki software and has many advantages over similar software.
- Easy to install and use.
- Low system requirements.
- Built-in Access Control List.
- Wide variety of extensions.
- More than 50 languages supported.
- Independent device.
- Open source.

Dokuwiki's advantages are not only that, this program can support adjustments at all skill levels. From easy configuration via the admin interface through downloading templates and plugins to developing your own extensions.

DokuWiki is a `GPLv2` licensed wiki application and written in the PHP programming language. DokuWiki works on plain text files and therefore does not require a database. The syntax is similar to that used by MediaWiki. So it's not surprising that almost everyone recommends DokuWiki as a lighter and more customizable alternative to MediaWiki.


## 2. DokuWiki On FreeBSD

General requirements for using DokuWiki on a FreeBSD system include:

1. The FreeBSD computer has the Apache24 Web server installed.
2. FreeBSD computer has PHP82 installed.
3. The FreeBSD computer has the PHP mod installed.

In this article we will not discuss installing Apache24 and PHP, you can read the previous article about installing and configuring Apache24 and PHP.
[Wordpress on Freebsd - Installation and Configuration For Blog](https://unixwinbsd.site/freebsd/installation-wordpress-for-blogs-on-freebsd)


## 3. DokuWiki Installation on FreeBSD

To start installing DokuWiki, you should use the `FreeBSD ports system`. Follow the following guide to install DokuWiki.


```
root@ns1:~ # portupgrade dokuwiki
[Reading data from pkg(8) ... - 582 packages found - done]

```

The script above is to update `DokuWiki ports`. Below is the command to install DokuWiki using the ports system.


```
root@ns1:~ # cd /usr/ports/www/dokuwiki
root@ns1:/usr/ports/www/dokuwiki # make install clean

```

Wait a few minutes until the DokuWiki installation process is complete. Once finished, type the following command.

```
root@ns1:~ # chown -R www:www /usr/local/www/dokuwiki
root@ns1:~ # chmod -R 777 /usr/local/www/dokuwiki
```

The first script above gives file ownership rights, namely `"www:www"`, while the second script provides file permissions, namely `777`.

So that DokuWiki can run on the apache24 web server, we must edit the `/usr/local/etc/apache24/httpd.conf` file. Add the script below to the `/usr/local/etc/apache24/httpd.conf` file.


```
Alias /dokuwiki "/usr/local/www/dokuwiki/"
<Directory "/usr/local/www/dokuwiki">
    AllowOverride None
    Options None
    Require all granted
</Directory>
```

After the `/usr/local/etc/apache24/httpd.conf` file editing process is complete, restart the apache24 program.


```
root@ns1:~ # service apache24 restart
Performing sanity check on apache24 configuration:
Syntax OK
Stopping apache24.
Waiting for PIDS: 38927.
Performing sanity check on apache24 configuration:
Syntax OK
Starting apache24.
```

We have everything configured, now it's time to run DokuWiki. Because DokuWiki runs on the apache24 web server, to open DokuWiki you have to use a web browser such as Yandex, Google Chrome, Firefox and others. For example, we will use Google Chrome, in the `Google Chrome` Web Browser, type the following command, continue by pressing the enter button on the keyboard.


```
http://192.168.5.2/dokuwiki/install.php

```

The command above is used to open DokuWiki in Google Chrome. If there is nothing wrong with the configuration, the DokuWiki installer menu will open as shown in the following image.


![oct-25-6](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-6.jpg)


After the image above appears, all you have to do is adjust it according to your needs.

MediaWiki is a powerful application that allows users to easily create collaborative knowledge platforms. Following the step-by-step guide in this article, you should have a working installation of MediaWiki on a FreeBSD 13.2 system. Enjoy the benefits of collaborative content creation, organized knowledge management, and efficient information sharing with MediaWiki.