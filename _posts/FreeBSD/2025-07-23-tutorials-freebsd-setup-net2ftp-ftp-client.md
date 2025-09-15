---
title: FreeBSD Tutorial  Set Up net2ftp Web Based FTP Client
date: "2025-07-23 19:32:21 +0100"
id: tutorials-freebsd-setup-net2ftp-ftp-client
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: SysAdmin
excerpt: File Transfer Protocol (FTP) is a protocol that functions to exchange files on a network that uses TCP connections instead of UDP. FTP was developed by Abhay Bhushan (an IIT and MIT alumnus) in the 1970s, while still working on the ARPAnet project
keywords: ftc, net2ftp, client, server, socat, command, install, use, freebsd, openbsd, transfer, data, networking, host
---

File Transfer Protocol (FTP) is a protocol that functions to exchange files on a network that uses TCP connections instead of UDP. FTP was developed by Abhay Bhushan (an IIT and MIT alumnus) in the 1970s, while still working on the ARPAnet project.

net2ftp is a web-based FTP client. The normal way to connect to your FTP server is to use an FTP client and communicate via the FTP protocol on port 21.

In addition to offering standard FTP functionality, net2ftp also offers a variety of features including archiving and extracting files and directories, as well as downloading a group of selected files or directories as an archive. Not only that, net2ftp can also set connection restrictions via access lists and can record user actions. Other plugins are also available and can be installed to add additional functionality as well.

Because net2ftp is written in PHP, it has many features, including:

- Upload and download files.
- Edit files (WYSIWYG and syntax highlighting).
- Calculate the size of directories and files.
- FTP server navigation.
- View code with syntax highlighting.
- Can rename files and directories and can also apply the "chmod" function.
- Can extract Zip files.
- Copy, move, delete (also to 2nd FTP server).
- Install software.
- Search for words or phrases.

Web FTP offers another way to connect to an FTP server. Even if you are behind a Firewall or blocked by a proxy that does not allow traffic to the FTP Server, Web FTP can solve this problem by creating an FTP connection from your web server to your FTP server and transferring files from this web server to your web client via the HTTP protocol standard.

Look at the image below.

![diagram klient ftp freebsd](https://raw.githubusercontent.com/unixwinbsd/unixwinbsd.github.io/refs/heads/master/Image/14klient%20ftp%20freebsd.jpg)

Another advantage of net2ftp is that it is integrated with many popular content management systems such as Drupal, Joomla, Mambo, and XOOPS. net2ftp and has been translated into more than 15 languages.


## 1. System requirements

The main requirement to run net2ftp on a computer, you must install the following application:
- OS: FreeBSD 13.2
- Apache version: Apache24
- PHP version: PHP82
- mod PHP82 dan PHP82 extension
- net2ftp version: net2ftp-1.4 
- PHP-FPM


## 2. Enable PHP on Apache

In this article we will use the apache24 web server. Make sure apache24 is installed on your FreeBSD server. After apache24 is active and can run normally, continue by installing PHP and the mod.

mod_PHP is a PHP module for the Apache24 web server that allows PHP applications to be run as part of the Apache base suite. This means that when you request a PHP page, Apache24 will include mod_PHP, which interprets and processes the PHP code. We suggest you read our previous articles:

[Configuring PHP FPM and Apache24 on FreeBSD](https://unixwinbsd.site/en/freebsd/2025/01/21/setup-php-fpm-apache-freebsd/)

[FreeBSD phpMyAdmin Starter With Apache24](https://unixwinbsd.site/en/openbsd/2025/05/21/phpmyadmin-openbsd-nginx-php-fpm/)

Type the following command to start installing PHP.
```
root@ns3:~ # pkg install php82 mod_php82 php82-mysqli
root@ns3:~ # pkg install php82-gd php82-phar php82-ctype php82-filter php82-iconv php82-curl php82-mysqli php82-pdo php82-tokenizer php82-mbstring php82-session php82-simplexml php82-xml php82-zlib php82-zip php82-dom php82-pdo_mysql php82-ctype
```
Add PHP script into apache24. Open the **"/usr/local/etc/Apache24/httpd.conf"** file and type the following script into the file.

```
LoadModule php_module         libexec/apache24/libphp.so

<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

<FilesMatch "\.php$">
    SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch "\.phps$">
    SetHandler application/x-httpd-php-source
</FilesMatch>
AddType application/x-compress .Z
AddType application/x-gzip .gz .tgz

AddType application/x-httpd-php .php
AddType application/x-httpd-php .php .phtml .php3
AddType application/x-httpd-php-source .phps
```

By adding the script above to the apache24 application, it means you have activated the PHP module with apache24.


## 3. Install net2ftp

At this stage, we just install net2ftp. In this example we will use the FreeBSD ports system for net2ftp installation. Type the following command in your Putty console.
```
root@ns3:~ # cd /usr/ports/ftp/net2ftp
root@ns3:/usr/ports/ftp/net2ftp # make install clean
```
When the installation process is complete, create the **"net2ftp.conf"** file in the apache24 root directory. Note the script below to create a **"/usr/local/etc/apache24/Includes/net2ftp.conf"** file.
```
root@ns3:/usr/ports/ftp/net2ftp # cd /usr/local/etc/apache24/Includes
root@ns3:/usr/local/etc/apache24/Includes # touch net2ftp.conf
root@ns3:/usr/local/etc/apache24/Includes # chmod +x net2ftp.conf
```
In the **"/usr/local/etc/apache24/Includes/net2ftp.conf"** file, enter the following script.

```
Alias /net2ftp "/usr/local/www/net2ftp/"

<Directory /usr/local/www/net2ftp/>
  Options +FollowSymlinks
  AllowOverride All
Require all granted


 <IfModule mod_dav.c>
  Dav off
 </IfModule>
 SetEnv HOME /usr/local/www/net2ftp
 SetEnv HTTP_HOME /usr/local/www/net2ftp
</Directory>
```

After that, you restart apache24.
```
root@ns3:~ # service apache24 restart
```
To conclude the configuration above, we will test whether net2ftp can run or not.

You open the web browser Google Chrome and type **"http://192.168.5.2/net2ftp"**. Look at the results in Google Chrome, if they appear like the image below, it means you have successfully run the net2ftp server on FreeBSD.

![Saving Cookies options](https://raw.githubusercontent.com/unixwinbsd/unixwinbsd.github.io/refs/heads/master/Image/15Saving%20Cookies%20options.jpg)


![net2ftp login](https://raw.githubusercontent.com/unixwinbsd/unixwinbsd.github.io/refs/heads/master/Image/16net2ftp%20login.jpg)

![input data login net2ftp](https://raw.githubusercontent.com/unixwinbsd/unixwinbsd.github.io/refs/heads/master/Image/15input%20data%20login%20net2ftp.jpg)


With the net2ftp application, it really helps us to change, delete, add or other things. Because its appearance is attractive, unlike FileZilla or WinsCP, it doesn't make us bored quickly from running this application.