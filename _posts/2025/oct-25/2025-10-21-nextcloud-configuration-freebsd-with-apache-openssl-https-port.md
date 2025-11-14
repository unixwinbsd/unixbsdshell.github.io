---
title: Nextcloud configuration on FreeBSD with Apache and OpenSSL HTTPS port
date: "2025-10-21 17:25:12 +0100"
updated: "2025-10-21 17:25:12 +0100"
id: nextcloud-configuration-freebsd-with-apache-openssl-https-port
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/oct-25/oct-25-126.jpg
toc: true
comments: true
published: true
excerpt: In this article, we'll set up a NextCloud server from scratch by adding an SSL certificate. There are many tutorials covering this topic, but very few tutorials for configuring Nextcloud on a FreeBSD server that provide SSL certificates
keywords: freebsd, mysql, nextcloud, php, fpm, openssl, mod, https, apache, apache24
---

In this article, we'll set up a NextCloud server from scratch by adding an SSL certificate. There are many tutorials covering this topic, but very few tutorials for configuring Nextcloud on a FreeBSD server that provide SSL certificates. In this article, the SSL certificate will be provided by OpenSSL, and the web server we'll use is Apache24. Before following this guide, ensure Apache, MySQL, PHP, PHP mod, and PHP-PFM are installed on your FreeBSD server.


This guide assumes Nextcloud will be accessed via a private IP, `https://192.168.5.2/nextcloud`. We'll place the SSL certificate in the Apache VHOST, which points to the `/usr/local/www/nextcloud` directory, where all Nextcloud files are stored.

<br/>

![nextcloud openssl port 443](/img/oct-25/oct-25-126.jpg)

<br/>


Panduan instalasi Nextcloud ini menjelaskan instalasi, konfigurasi, dan penguatan serta beberapa opsi perluasan Nextcloud pada server FreeBSD. Instalasi Nextcloud didasarkan pada komponen Apache24 dan OpenSSL untuk menyediakan sertifikat SSL. Anda dapat mengubah konten skrip dalam panduan ini sesuai dengan spesifikasi server FreeBSD Anda seperti alamat IP pribadi dan domain. 

<div align="center">
    <b>
"Before we start, make sure the Apache24 web server, MySQL server, PHP, PHP mod and PHP-PFM are installed and running normally on your FreeBSD server."
    </b>

</div>

## 1. Create a Nextcloud Database

Databases are crucial in Nextcloud. A database in Nextcloud stores all the configurations and data you enter into Nextcloud. Nextcloud supports many databases, but in this article, we'll be using a MySQL server database.

To create a Nextcloud database, you'll need to log in to the MySQL server. Once you're logged in, proceed to create a Nextcloud database. Here's a guide you can follow.

- User: **usernextcloud**
- Host: **Localhost**
- Database name: **nextcloud**
- Password: **router123**

```sh
root@ns3:~ # mysql -u root -p
Enter password:
root@localhost [(none)]> CREATE DATABASE nextcloud;
root@localhost [(none)]> CREATE USER 'usernextcloud'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'usernextcloud'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]> exit;
root@ns3:~ #
```

## 2. Nextcloud Installation Process

The first step is to install the Nextcloud dependencies. These dependencies consist of a PHP application that will create a library file.

```sh
root@ns3:~ # pkg install php82-ctype pkgconf php82-filter php82-iconv php82-xmlwriter php82-bz2 php82-mbstring php82-pdo_mysql php82-opcache php82-xmlreader
root@ns3:~ # pkg install php82-xsl php82-dom php82-gmp php82-pcntl php82-pdo php82-posix php82-simplexml php82-intl php82-ldap php82-sysvsem php82-bcmath
```

FreeBSD makes it easy for you, as the Nextcloud repository is available as a PKG package or a system port. You can choose either, but we recommend using the system port to install Nextcloud. Here's how.

```sh
root@ns3:~ # cd /usr/ports/www/nextcloud
root@ns3:/usr/ports/www/nextcloud # make install clean
```

Change file permissions and ownership.

```sh
root@ns3:/usr/ports/www/nextcloud # chown -R www:www /usr/local/www/nextcloud
root@ns3:/usr/ports/www/nextcloud # chmod -R 775 /usr/local/www/nextcloud
```

## 3. Configure config.php Crontab php.ini

config.php is Nextcloud's main configuration file. You'll need to modify the scripts in this file to ensure Nextcloud runs properly. There are several configurations you'll need to make, including:

### a. Enable caching

Caching is used to improve Nextcloud's speed. The difference in speed between using Nextcloud without a cache and with a cache is significant. Especially as the number of files and folders increases and more multimedia files are added to the server, caching becomes increasingly important for maintaining speed and performance.

Nextcloud uses several caches, including APCU, Redis, and Memcached. In this article, we will use Memcached. Run the following command to install Memcached.

```sh
root@ns3:~ # cd /usr/ports/databases/memcached
root@ns3:/usr/ports/databases/memcached # make install clean
```

In this section, we will not explain the complete memcached configuration process, you can read our previous article.

[Playing around with FreeBSD Memcached How to implement an in-memory data caching service](https://unixwinbsd.site/freebsd/freebsd-memcached-implement-memory-caching-service)

Open the config.php file, and add the memcached script below.

```sh
root@ns3:~ # ee /usr/local/www/nextcloud/config/config.php
  'memcache.local' => '\\OC\\Memcache\\Memcached',
  'memcache.distributed' => '\\OC\\Memcache\\Memcached',
  'memcache.locking' => '\\OC\\Memcache\\Memcached',
  'memcached_servers' => 
  array (
    0 => 
    array (
      0 => '192.168.5.2',
      1 => 11211,
    ),
  ),
```

### b. Activate Pretty links

Just like creating a theme in Joomla or WordPress, pretty links aren't mandatory, but they add to the overall aesthetic of your server. You'll need to enable `"Pretty Links"` in your `config.php` file.

```sh
root@ns3:~ # ee /usr/local/www/nextcloud/config/config.php
'overwrite.cli.url' => 'https://192.168.5.2/nextcloud',
'htaccess.RewriteBase' => '/nextcloud',
```

### c. Activate Phone Region

Enable the default phone region. This is crucial for validating phone numbers in your Nextcloud profile settings. You can add `"default_phone_region"` with each region's ISO 3166-1 code to the `config.php` configuration file. Adjust the code to suit your country.


```sh
root@ns3:~ # ee /usr/local/www/nextcloud/config/config.php
'default_phone_region' => 'US',
```

### d. Activate Maintenance Window

The maintenance process is very important, so you can start by configuring the Nextcloud maintenance window. This process will perform intensive daily background tasks during Nextcloud's prime usage times. Since you're using a FreeBSD server, we recommend setting it to low usage times to minimize the impact on users from the heavy workload.


```sh
root@ns3:~ # ee /usr/local/www/nextcloud/config/config.php
'maintenance_window_start' => 1,
```

### e. Enable Crontab

After installing Nextcloud, background tasks are executed using AJAX when users visit the Nextcloud page. This prevents you from running scheduler tasks when there's no activity. To resolve this issue, open your `crontab` file and add the following script.


```sh
root@ns3:~ # ee /etc/crontab
*/15 * * * * /usr/local/bin/php -f /usr/local/www/apache24/data/nextcloud/cron.php
*/5 * * * * php -f /usr/local/www/nextcloud/occ dav:send-event-reminders
```

<br/>

![create nextcloud cron](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25/oct-25-125.jpg)

<br/>

### f. PHP Opcache configuration

On FreeBSD servers, PHP Opcache settings are essential for caching pre-compiled bytecode. Proper PHP Opcache settings will improve Nextcloud performance. Enable the script below in the `php.ini` file.

```sh
root@ns3:~ # ee /usr/local/etc/php.ini
opcache.enable=1
opcache.enable_cli=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=1
memory_limit = 512M
cgi.fix_pathinfo=0
post_max_size = 32M
upload_max_filesize = 32M
```

### g. Enable Nextcloud Providers

Enabling the `Nextcloud Providers` option speeds up preview creation using external microservices. To implement this option, you need to deploy the service and ensure it's not accessible from outside your server. You can then configure Nextcloud to use Imaginary by editing the `config.php` file.

```sh
root@ns3:~ # ee /usr/local/www/nextcloud/config/config.php
'enable_previews' => true,
  'enabledPreviewProviders' => 
  array (
    0 => 'OCPreviewPNG',
    1 => 'OCPreviewJPEG',
    2 => 'OCPreviewGIF',
    3 => 'OCPreviewBMP',
    4 => 'OCPreviewXBitmap',
    5 => 'OCPreviewMarkDown',
    6 => 'OCPreviewMP3',
    7 => 'OCPreviewTXT',
    8 => 'OCPreviewIllustrator',
    9 => 'OCPreviewMovie',
    10 => 'OCPreviewMSOffice2017',
    12 => 'OCPreviewMSOfficeDoc',
    13 => 'OCPreviewOpenDocument',
    14 => 'OCPreviewPDF',
    15 => 'OCPreviewPhotoshop',
    16 => 'OCPreviewPostscript',
    17 => 'OCPreviewStarOffice',
    18 => 'OCPreviewSVG',
    19 => 'OCPreviewTIFF',
    20 => 'OCPreviewFont',
  ),
```

You can see the complete script of the `config.php` file below.

```sh
<?php
$CONFIG = array (
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/usr/local/www/nextcloud/apps',
      'url' => '/apps',
      'writable' => true,
    ),
    1 => 
    array (
      'path' => '/usr/local/www/nextcloud/apps-pkg',
      'url' => '/apps-pkg',
      'writable' => false,
    ),
  ),
  'logfile' => '/var/log/nextcloud/nextcloud.log',
  'memcache.local' => '\\OC\\Memcache\\Memcached',
  'instanceid' => 'oc4umminut1v',
  'passwordsalt' => 'B+tTSN3tC1SdPMaRxkZVZPXe+Bg0Lp',
  'secret' => 'unz4KEhJPBuXC+lrRZx8brzvlFlHJimMC6zv+XmlzS7gNc4L',
  'trusted_domains' => 
  array (
    0 => '192.168.5.2',
  ),
  'datadirectory' => '/usr/local/www/nextcloud/data',
  'dbtype' => 'mysql',
  'version' => '28.0.3.2',
  'overwrite.cli.url' => 'https://192.168.5.2/nextcloud',
  'dbname' => 'nextcloud',
  'dbhost' => 'localhost',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'mary',
  'dbpassword' => 'mary123',
  'installed' => true,
  'memcache.distributed' => '\\OC\\Memcache\\Memcached',
  'memcache.locking' => '\\OC\\Memcache\\Memcached',
  'memcached_servers' => 
  array (
    0 => 
    array (
      0 => '192.168.5.2',
      1 => 11211,
    ),
  ),
  'htaccess.RewriteBase' => '/nextcloud',
  'default_phone_region' => 'US',
  'maintenance_window_start' => 1,

'enable_previews' => true,
  'enabledPreviewProviders' => 
  array (
    0 => 'OCPreviewPNG',
    1 => 'OCPreviewJPEG',
    2 => 'OCPreviewGIF',
    3 => 'OCPreviewBMP',
    4 => 'OCPreviewXBitmap',
    5 => 'OCPreviewMarkDown',
    6 => 'OCPreviewMP3',
    7 => 'OCPreviewTXT',
    8 => 'OCPreviewIllustrator',
    9 => 'OCPreviewMovie',
    10 => 'OCPreviewMSOffice2017',
    12 => 'OCPreviewMSOfficeDoc',
    13 => 'OCPreviewOpenDocument',
    14 => 'OCPreviewPDF',
    15 => 'OCPreviewPhotoshop',
    16 => 'OCPreviewPostscript',
    17 => 'OCPreviewStarOffice',
    18 => 'OCPreviewSVG',
    19 => 'OCPreviewTIFF',
    20 => 'OCPreviewFont',
  ),
  
);
```

## 4. Configure SSL using OpenSSL

As mentioned in the title above, Nextcloud is configured with https, so you'll need to create an SSL certificate. If CA signing isn't required, a self-signed certificate can be created. To do this, let's first generate an RSA private key, which we'll use to generate a CSR or CRT certificate. However, before we create an SSL certificate, we'll first create an SSL directory.


```sh
root@ns3:~ # cd /usr/local/etc/apache24
root@ns3:/usr/local/etc/apache24 # mkdir -p ssl
root@ns3:/usr/local/etc/apache24 # cd ssl
root@ns3:/usr/local/etc/apache24/ssl #
```

After that, you continue by creating an SSL certificate.

```sh
root@ns3:/usr/local/etc/apache24/ssl # openssl genrsa -out server.key 2048
root@ns3:/usr/local/etc/apache24/ssl # openssl req -new -key server.key -out server.csr
root@ns3:/usr/local/etc/apache24/ssl # openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
root@ns3:/usr/local/etc/apache24/ssl # cat server.crt server.key > server.bundle.pem
```

Change file ownership permissions.

```
root@ns3:/usr/local/etc/apache24/ssl # chmod -R 640 /usr/local/etc/apache24/ssl
```

## 5. Create an SSL Vhost in Apache

Since the Apache24 web server is running normally, we can immediately enable Vhost. Open the `httpd.conf` file and activate the script below.

```sh
root@ns3:~ # ee /usr/local/etc/apache24/httpd.conf
Listen 80
ServerAdmin datainchi@gmail.com
ServerName datainchi.com
LoadModule ssl_module libexec/apache24/mod_ssl.so
LoadModule rewrite_module libexec/apache24/mod_rewrite.so
Include etc/apache24/extra/httpd-ssl.conf
```

Now we'll set up Apache with a self-signed certificate as part of the Nextcloud installation, so we'll use that for this guide. Open the httpd-ssl.conf file and delete all the scripts and replace them with the one below.

```sh
root@ns3:~ # ee /usr/local/etc/apache24/extra/httpd-ssl.conf
Listen 443
SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
SSLHonorCipherOrder on 
SSLProtocol all -SSLv3
SSLProxyProtocol all -SSLv3
SSLPassPhraseDialog  builtin
SSLSessionCache        "shmcb:/var/run/ssl_scache(512000)"
SSLSessionCacheTimeout  300

SSLUseStapling On
SSLStaplingCache "shmcb:/var/run/ssl_stapling(32768)"
SSLStaplingStandardCacheTimeout 3600
SSLStaplingErrorCacheTimeout 600
SSLCompression          off

<VirtualHost _default_:443>
DocumentRoot "/usr/local/www/apache24/data"
ServerName www.example.com:443
ServerAdmin you@example.com
ErrorLog "/var/log/httpd-error.log"
TransferLog "/var/log/httpd-access.log"

SSLEngine on

SSLCertificateFile "/usr/local/etc/apache24/mycert/server.crt"
SSLCertificateKeyFile "/usr/local/etc/apache24/mycert/server.key"

 <IfModule mod_headers.c>
 Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"
    </IfModule>

   Alias /nextcloud /usr/local/www/nextcloud
        AcceptPathInfo On
        <Directory /usr/local/www/nextcloud>
Options Indexes ExecCGI FollowSymLinks
            AllowOverride All
            Require all granted

<IfModule mod_dav.c>
Dav off
</IfModule>
        Header unset Content-Security-Policy
        Header always unset Content-Security-Policy
SetEnv HOME /usr/local/www/nextcloud
SetEnv HTTP_HOME /usr/local/www/nextcloud
Satisfy Any
        </Directory>

<Directory /usr/local/www/nextcloud/apps/sip_trip_phone/phone/>
             DirectoryIndex index.html
        </Directory>


<FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
</FilesMatch>
<Directory "/usr/local/www/apache24/cgi-bin">
    SSLOptions +StdEnvVars
</Directory>


BrowserMatch "MSIE [2-5]" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0
CustomLog "/var/log/httpd-ssl_request.log" "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

</VirtualHost>
```

Once you've configured everything, it's time to launch Nextcloud. Open Google Chrome and type `https://192.168.5.2/nextcloud/`. Check the results on your screen. If everything is fine with the configuration, the Nextcloud server should appear on your screen.

In this comprehensive tutorial, we've explained the process of enabling an SSL certificate on Apache with OpenSSL. By following all the instructions in this article, you can ensure that your web server is using the latest and most secure version of the TLS protocol, improving the security and performance of your Nextcloud server.
