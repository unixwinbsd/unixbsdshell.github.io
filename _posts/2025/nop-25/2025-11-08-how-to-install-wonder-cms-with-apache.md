---
title: How to Install WonderCMS with Apache on FreeBSD
date: "2025-11-08 11:38:11 +0000"
updated: "2025-11-08 11:38:11 +0000"
id: how-to-install-wonder-cms-with-apache
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://installatron.com/images/remote/ss5_wondercms.png
toc: true
comments: true
published: true
excerpt: WonderCMS is a database-less, flat-file content management system. Its file size is very small, making it easy to use. Furthermore, its structure facilitates the functionality needed in a flat-file CMS solution.
keywords: framework, wonder, cms, wonder cms, php, flat, file, freebsd, bsd, apache, web server, https, mod, module, blog
---

WonderCMS is an open-source CMS written in PHP. It's very small, using flat files, is fast, responsive, and requires no configuration. It's an easy way to create and edit websites. You can get the WonderCMS open-source code on GitHub.

Unlike other CMSs that have large file sizes, WonderCMS is a content management system (CMS) that claims to be the smallest CMS in the world. This size doesn't include other supporting files, such as ReadME.htaccess, style sheets, and even images for creating gradient backgrounds.

WonderCMS is created by Robert Isoski. This CMS has its own official website, https://www.wondercms.com. From this site, you can download the latest version of WonderCMS for free. You can also download WonderCMS from the official GitHub repository.

When you start WonderCMS, you'll immediately experience the ease of editing your website. All of its features are purposefully designed for simplicity, including one-step installation, one-click updates, one-click backups, theme/plugin installers, and more.

WonderCMS also supports most server types (Apache, NGINX, IIS). WonderCMS doesn't track users or store personal cookies. There's only a single session state cookie. Your WonderCMS installation is completely separate from the WonderCMS server. One-click updates are delivered through GitHub.

This guide will show you how to install WonderCMS on a fresh FreeBSD 13.2 with Apache24 as your web server.

## A. System Specifications

OS: FreeBSD 13.2
- Hostname: ns3
- IP address: 192.168.5.2
- WEb server: apache24
- PHP version: PHP82
- Dependencies: php82-mbstring, php82-zip, mod_php82
- PHP-FPM

## B. How to Install WonderCMS

Because WonderCMS is a content management system (CMS), it requires a web server to run. In this article, we will use the Apache24 web server.

### b.1. Install Apache24

We will use Apache24 to connect WonderCMS to the web server. To run `WonderCMS`, you must first install Apache. The Apache24 repository is available on FreeBSD; use the PKG package to install Apache24.

```yml
root@ns3:~ # pkg install apache24
```

Open the `/usr/local/etc/apache24` folder and find the httpd.conf file. In the httpd.conf file, modify the following scripts.

```console
Listen 80
ServerAdmin datainchi@gmail.com
ServerName datainchi.com:80
```

To immediately enable apache24, open the `/etc/rc.conf` file and add the script below to the file.

```console
apache24_enable="YES"
```

Run the apache24 web server.

```yml
root@ns3:~ # service apache24 restart
```

### b.2 Install Dependencies

WonderCMS is built in PHP, so you must install PHP dependencies to enable it to work with the Apache web server. Run the command below to enable some of the dependencies WonderCMS requires.

```yml
root@ns3:~ # pkg install php82-8.2.14
root@ns3:~ # pkg install php82-mbstring-8.2.14 php82-curl-8.2.14
root@ns3:~ # pkg install php82-zip-8.2.14
root@ns3:~ # pkg install mod_php82-8.2.14
```

Untuk mengaktifkan modul PHP, buka file `"/usr/local/etc/apache24/httpd.conf"`, dan ketik tambahkan skrip di bawah ini ke dalam file.

```console
LoadModule rewrite_module libexec/apache24/mod_rewrite.so
LoadModule php_module         libexec/apache24/libphp.so
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

AddType application/x-httpd-php .php
AddType application/x-httpd-php .php .phtml .php3
AddType application/x-httpd-php-source .phps
Alias /wondercms "/usr/local/www/wondercms"
    <Directory "/usr/local/www/wondercms">
        Options Indexes FollowSymlinks MultiViews
        AllowOverride all
        Require all granted
    </Directory>
```

### b.3. Install PHP-FPM
PHP-FPM is a processor for PHP, one of the most common scripting languages. WonderCMS uses PHP-FPM to handle larger volumes of web traffic without relying on server resources. You must enable PHP-FPM to run WonderCMS.

Open the file `/usr/local/etc/php-fpm.d/www.conf`, and include the following script in the file.

```console
user = www
group = www
listen = 127.0.0.1:9000
listen.owner = www
listen.group = www
listen.mode = 0660
```

After that you create a file `/usr/local/etc/apache24/Includes/php-fpm.conf`, and type the script below in the php-fpm.conf file.

```console
<IfModule proxy_fcgi_module>
   <IfModule dir_module>
       DirectoryIndex index.php
   </IfModule>
   <FilesMatch "\.(php|phtml|inc)$">
       SetHandler "proxy:fcgi://127.0.0.1:9000"
   </FilesMatch>
</IfModule>
```

Enable the script under file `"/usr/local/etc/apache24/httpd.conf"`.

```console
LoadModule mpm_prefork_module libexec/apache24/mod_mpm_prefork.so
#LoadModule mpm_worker_module libexec/apache24/mod_mpm_worker.so
LoadModule authnz_fcgi_module libexec/apache24/mod_authnz_fcgi.so
LoadModule proxy_module libexec/apache24/mod_proxy.so
LoadModule proxy_http_module libexec/apache24/mod_proxy_http.so
LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so
LoadModule proxy_scgi_module libexec/apache24/mod_proxy_scgi.so
```

Enable PHP-FPM in the `/etc/rc.conf` file by adding the script below.

```yml
php_fpm_enable="YES"
```

Run PHP-FPM.

```yml
root@ns3:~ # service php-fpm restart
root@ns3:~ # service apache24 restart
```

### b.4. Download WonderCMS

On FreeBSD, the WonderCMS repository is not available; you'll need to download it from the official website or GitHub. For simplicity, we'll download it from the GitHub repository. Run this command to clone WonderCMS.

```yml
root@ns3:~ # cd /usr/local/www
root@ns3:/usr/local/www # git clone https://github.com/WonderCMS/wondercms.git
```

Execute ownership and permissions.

```yml
root@ns3:/usr/local/www # chown -R www:www /usr/local/www/wondercms
root@ns3:/usr/local/www # chmod 775 /usr/local/www/wondercms
```

Before you run WonderCMS, restart apache and PHP-FPM.

```yml
root@ns3:~ # service php-fpm restart
root@ns3:~ # service apache24 restart
```

Now let's run WonderCMS. Open your Google Chrome or other web browser and type `"http://192.168.5.2/wondercms"` on your monitor. The WonderCMS homepage will appear.

Click `"CLICK HERE TO LOGIN"` You'll see a menu displaying a password box. Enter your WonderCMS password.

WonderCMS is a database-less, flat-file content management system. Its file size is very small, making it easy to use. Furthermore, its structure facilitates the functionality needed for a flat-file CMS solution. With Apache, you can set up a simple server without a database.
