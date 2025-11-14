---
title: FreeBSD Magento Adobe Commerce Setup with PHP Composer and Apache
date: "2025-09-26 20:02:15 +0100"
updated: "2025-09-26 20:02:15 +0100"
id: freebsd-magento-adobe-commerce-php-composer-apache
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-75.jpg
toc: true
comments: true
published: true
excerpt: Adobe Magento has many PHP dependencies. You must install them when you first configure Magento. Without them, you can't expect Magento to run smoothly. All dependencies are written in PHP, which is essential for Magento to connect your website to databases and web servers like Apache.
keywords: freebsd, adobe, magento, e-commerce, commerce, php, composer, laravel, apache, web server, https
---

Magento is a CMS framework designed to launch large-scale and complex e-commerce projects. Its primary purpose is to assist online store owners with hundreds to thousands of products. Its ease of managing thousands of products is highly sought after by large businesses.

Magento, written in PHP and developed by Adobe, is an open-source e-commerce platform for managing online stores. Magento's features provide tools for creating and managing online stores and online shopping platforms. Magento delivers smoother navigation, improved conversions, and a better user experience.

Magento offers flexible customization, scalability, and extensibility for various types of online businesses. The Magento CMS platform also supports a variety of functions, including product management, ordering, payments, shipping, and marketing tools to enhance the customer experience. This enables companies to create and manage effective online stores with a variety of features and capabilities that can help store owners grow their businesses.

Magento, also known as Adobe Commerce, is an e-commerce solution for large online merchants, designed with developers in mind to design their own online stores. Magento provides easy product inventory and sales management for better management of your e-commerce store. This e-commerce platform also includes a page builder, allowing you to easily create and design web pages according to your preferences.

<br/>
{% lazyload data-src="/img/oct-25/oct-25-75.jpg" src="/img/oct-25/oct-25-75.jpg" alt="Adobe Magento configuration on FreeBSD" %}
<br/>

According to an official release from Adobe, by acquiring Magento, the company will be able to create a comprehensive system for developing digital advertising, online stores, and other technologies for online customers.

In this post, we'll walk through the process of installing and configuring Adobe Magento, so you can display the Magento Platform on your Google Chrome screen.

## A. System Specifications

- OS: FreeBSD 13.3
- Hostname: ns3
- IP FreeBSD: 192.168.5.2
- Database server: MySQL8
- Web server: Apache24
- PHP: PHP82, PHP Composer
- PHP FPM
- Elasticsearch: elasticsearch8
- Dependencies: php82-opcache php82-session php82-pecl-APCu php82-bcmath php82-bz2 php82-ctype php82-curl php82-dom php82-exif php82-fileinfo php82-filter php82-gd php82-gmp php82-iconv php82-intl php82-ldap php82-mbstring php82-pecl-msgpack php82-mysqli php82-pcntl php82-pdo php82-phar php82-posix php82-simplexml php82-sodium php82-sysvsem php82-tokenizer php82-xml php82-xmlwriter php82-zip php82-zlib php82-pecl-memcache php82-pecl-memcached php82-pdo_mysql php82-xmlreader php82-xsl php82-soap

## B. Install Dependencies

Adobe Magento has many PHP dependencies. You must install them when you first configure Magento. Without them, you can't expect Magento to run smoothly. All dependencies are written in PHP, which is essential for Magento to connect your website to databases and web servers like Apache.

To simplify the process, you can install Magento dependencies using the FreeBSD PKG package. Here's how to install Magento dependencies using PKG.


```
root@ns3:/usr/local/www # pkg install php82-opcache php82-session php82-pecl-APCu php82-bcmath php82-bz2 php82-ctype php82-curl php82-dom php82-exif php82-fileinfo php82-filter php82-gd php82-gmp php82-iconv php82-intl php82-ldap php82-mbstring php82-pecl-msgpack php82-mysqli php82-pcntl php82-pdo php82-phar php82-posix php82-simplexml php82-sodium php82-sysvsem php82-tokenizer php82-xml php82-xmlwriter php82-zip php82-zlib php82-pecl-memcache php82-pecl-memcached php82-pdo_mysql php82-xmlreader php82-xsl php82-soap
```

## C. Create Database for Adobe Magento

In this article, we assume that all of the above system specifications are installed on a FreeBSD server. Therefore, we will not discuss the applications mentioned above. Let's get straight to the main topic of this article.

Database creation is a crucial part of Magento configuration. All your data, such as product names and customer data, will be stored in the database. In this article, we will use a MySQL server to create a Magento database.

The commands below will guide you through creating a Magento database using a MySQL server.


```
root@ns3:~ # mysql -u root -p
root@localhost [(none)]> CREATE DATABASE magento CHARACTER SET utf8;
root@localhost [(none)]> CREATE USER 'usermagento'@'localhost' IDENTIFIED BY 'router12345';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON magento.* TO 'usermagento'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]> exit;
root@ns3:~ #
```

## D. Create Adobe Magento Public and Private Keys

Before starting the Magento installation process, you must generate a Magento public and private key. These keys are used to authenticate access to the repo.magento.com repository. Every time you access repo.magento.com, both the public and private keys are required.

**These keys are used to fill in:**

- Username = **public key**
- Password = **private key**

The way to get or generate a key is by accessing the Magento marketplace site.

1. First, log in to https://marketplace.magento.com/.
2. If you don't have a Magento account, create a new one at https://account.magento.com/applications/customer/login/.
3. If you already have a Magento account, 4. Log in with your Magento credentials.
5. After successfully logging in, go to the "My Profile" menu.
Click "Access Key."
6. Select the "Magento2" menu.
7. To create a new key, click the "Create A New Access Key" menu.

<br/>
{% lazyload data-src="/img/oct-25/magento-freebsd.jpg" src="/img/oct-25/magento-freebsd.jpg" alt="create new key to access adobe magento" %}
<br/>

## E. How to Install Adobe Magento

On FreeBSD systems, the Magento repository is not available in PKG or ports. When installing Magento and Magento modules, the Composer module is actively used. Therefore, before installing Magento, Composer must be installed first. Another important detail when using Composer is that the memory_limit (PHP) variable must be set to 4 GB. At a limit of 2 GB, Composer can cause PHP to crash with a fatal error during the installation process.

The first step is to create a working directory for Magento. We will place this directory in the Apache server block, namely `/usr/local/www`.


```
root@ns3:~ # mkdir -p /usr/local/www/magento
```

After that create a Magento project with Composer.


```
root@ns3:~ # cd /usr/local/www
root@ns3:/usr/local/www # composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition magento
```

When you run the command above, Composer will ask for a username and password. Use the password and user you created above. Then, install Magento with the command below.


```
root@ns3:/usr/local/www # cd magento
root@ns3:/usr/local/www/magento # composer install --ignore-platform-req=ext-sockets
```

Also install sockets for PHP.


```
root@ns3:/usr/local/www/magento # pkg install php82-sockets
```

Also run the command below to continue the Magento installation.


```
root@ns3:/usr/local/www/magento/bin # ./magento setup:install --base-url=http://192.168.5.2/magento --db-host=localhost --db-name=magento --db-user=usermagento --db-password=router12345 --admin-firstname=john --admin-lastname=doe --admin-email=datainchi@gmail.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/New_York --use-rewrites=1 --search-engine=elasticsearch8 --elasticsearch-host=http://192.168.5.2 --elasticsearch-port=9200
```

One important thing to note during the Magento installation process on FreeBSD is the Elasticsearch application. You must have this application installed before installing Magento. You can read our previous article about Elasticsearch.

[FreeBSD Elasticsearch - How to Enable App Store Full Text Search in NextCloud](https://unixwinbsd.site/freebsd/elasticsearch-freebsd-enable-text-search-netxcloud)

You open the elasticsearch.yml file and edit the script as in the example below.


```
root@ns3:~ # ee /usr/local/etc/elasticsearch/elasticsearch.yml
cluster.name: magento
node.name: node-1
path.data: /var/db/elasticsearch
path.logs: /var/run/elasticsearch
bootstrap.memory_lock: true
network.host: 192.168.5.2
http.port: 9200
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
discovery.type: single-node
xpack.ml.enabled: false
xpack.security.enabled: false
xpack.security.enrollment.enabled: false
```

Starting with Magento 2.2, a crontab file was added to manage log files. On FreeBSD, you can manage crontab files in `/etc/crontab`. Run the command below to install the crontab file.

```
root@ns3:~ # cd /usr/local/www/magento/bin
root@ns3:/usr/local/www/magento/bin # ./magento cron:install --force
Crontab has been generated and saved
```

Then in the `/etc/crontab` file, you add the script below.


```
root@ns3:/usr/local/www/magento/bin # ee /etc/crontab
* * * * * /usr/local/bin/php /usr/local/www/magento/bin/magento cron:run 2>&1 | grep -v "Ran jobs by schedule" >> /usr/local/www/magento/var/log/magento.cron.log
```

Next, you run the commands below to update the database, deploy the static view files, and disable two-factor authentication.


```
root@ns3:/usr/local/www/magento/bin # ./magento indexer:reindex && ./magento se:up && ./magento se:s:d -f && ./magento c:f && ./magento module:disable Magento_TwoFactorAuth
```

Then you add access rights and ownership to Magento files and folders.


```
root@ns3:~ # chown -R www:www /usr/local/www/magento/
root@ns3:~ # chmod -R 775 /usr/local/www/magento
```

## F. Create Apache Vhost

For the Magento frontend, we'll use Apache24 as the web server. With Apache, Magento can be displayed and configured through Google Chrome. To connect Magento to Apache, you need to enable the Apache virtual host file. In the httpd.conf file, enable the vhost file by removing the **"#"** symbol. See the example below.


```
root@ns3:~ # cd /usr/local/etc/apache24
root@ns3:/usr/local/etc/apache24 # ee httpd.conf
#Include etc/apache24/extra/httpd-vhosts.conf
Include etc/apache24/extra/httpd-vhosts.conf
```

After that you delete all the scripts `/usr/local/etc/apache24/extra/vhost.conf`, and replace them with the scripts below (adjust to your FreeBSD server system).


```
root@ns3:/usr/local/etc/apache24 # cd extra
root@ns3:/usr/local/etc/apache24/extra # ee httpd-vhosts.conf
<VirtualHost *:80>
    ServerAdmin datainchi@gmail.com
    DocumentRoot "/usr/local/www/magento/pub"
    ServerName datainchi.com
    ServerAlias www.datainchi.com
SetEnv MAGE_RUN_CODE "base"
    SetEnv MAGE_RUN_TYPE "website"

  <Directory /usr/local/www/magento/pub>
       Options Indexes FollowSymLinks MultiViews
       AllowOverride All
       Require all granted
  </Directory>

    ErrorLog "/var/log/dummy-host.example.com-error_log"
    CustomLog "/var/log/dummy-host.example.com-access_log" common
</VirtualHost>
```

The next step, you restart Apache24.


```
root@ns3:~ # service apache24 restart
```

The final step is to test by opening Google Chrome and typing `"http://192.168.5.2/magento/setup/"` or `"http://192.168.5.2/magento/pub/"`. View the results in Google Chrome. If your configuration is correct, the Magento configuration menu will appear.

When you want to use Magento to open an online store, a comprehensive and clear installation and configuration guide will simplify the process. This tutorial shows how to manually configure Magento on a FreeBSD server.

However, the existing script can be used on Linux servers like Ubuntu. We present the entire contents of this article in full and hope it helps those of you who want to create an online store with Magento.