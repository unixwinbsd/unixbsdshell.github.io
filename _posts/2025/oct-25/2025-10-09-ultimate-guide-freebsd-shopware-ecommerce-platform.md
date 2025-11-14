---
title: The Ultimate Guide FreeBSD To Shopware Ecommerce Platform - Installation and configuration of Shopware 6
date: "2025-10-09 08:17:41 +0100"
updated: "2025-10-09 08:17:41 +0100"
id: ultimate-guide-freebsd-shopware-ecommerce-platform
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-60.jpg
toc: true
comments: true
published: true
excerpt: In this article we will learn how to install and configure Shopware on a FreeBSD server. So that Shopware can run normally we need to add several dependencies which will form library files such as PHP and the MySQL server database.
keywords: freebsd, tutorials, ultimate, guide, freebsd, shopware-ecommerce, platform
---

If you have a physical shop or business and want to switch or expand to the online world. You must first understand which platform suits your abilities and type of business. There are lots of online shop platforms, but there is one thing we can all agree on. Choosing the right solution has a major impact on expanding your customer reach and the profitability of your business.

Nowadays there are tons of e-commerce platforms like Magento, Wix and Shopify are well-known names when it comes to e-commerce platforms. However, without you realizing it, a new product has emerged that is starting to make a breakthrough in the e-commerce industry, namely Shopware. Even though it is relatively new to us, it has actually been around since 2000. In several European countries, Shopware is one of the leading solutions for online shop businesses. And now, its presence is also increasing globally.

Shopware is an ecommerce platform that aims to ease and simplify the process of building an online store. With Shopware, shop owners are not required to have a server or other infrastructure to start selling online. Traders can start their business with a cloud-based virtual machine, namely SaaS or PaaS. On-Prem (Self-Hosted), PaaS, and SaaS cloud-based ecommerce platforms were purposely created to help merchants build and grow their online stores.

With Shopware, traders can easily create online stores professionally like a skilled programmer. Merchants easily sell their products, promote and attract new customers. Sellers can use the platform's custom-built design tools or design their store from scratch so that it is visible to everyone.

In this article we will learn how to install and configure Shopware on a FreeBSD server. So that Shopware can run normally we need to add several dependencies which will form library files such as PHP and the MySQL server database.

In this article we assume, MySQL, Composer, apache24, PHP-FPM have been installed on the FreeBSD server. So we will not discuss it in this article. You can read it in our previous article about how to install the application.


## 1. System Requirements

1. OS: FreeBSD 13.2
2. IP address: 192.168.5.2
3. Hostname: ns3
4. Java version: openjdk17
5. Web server: apache24
6. Shopware version: Release v6.5.8.6
7. PHP version: PHP82
8. **PHP-FPM:**
- Composer: Recommended version: 2.0 or higher
- Dependencies: php82-curl php82-dom php82-fileinfo php82-gd php82-iconv php82-intl php82-pecl-json_post php82-xmlwriter php82-mbstring php82-pdo php82-pdo_mysql php82-phar php82-simplexml php82-xml php82-zip php82-zlib pcre2 libxml2


## 2. Create a Database for Shopware

Similar to other web browser-based applications, Shopware requires a database to store all user information. All data entered by the user will be stored in the Shopware database. All product showcases that you see on the Shopware online site come from the backend database.

The databases supported by Shopware are MariaDB and MySQL. In this article we use a database that is commonly used by users, namely the MySQL server database. We will create a new MySQL user and a new MySQL Database. With the mysql command we start a new mysql session. In this MySQL session we create a new database called shopware using the following query.

```
root@localhost [(none)]> CREATE DATABASE shopware;
root@localhost [(none)]> CREATE USER 'usershopware'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON shopware.* TO 'usershopware'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
```

In the script above, we create a database:

database name: **shopware**

user: **usershopware**

Password: **router123**

Host: **localhost**


Then you create another new database called `"shopwaredata"`.

```
root@localhost [(none)]> create database shopwaredata;
root@localhost [(none)]> GRANT ALL PRIVILEGES ON shopwaredata.* TO 'usershopware'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
```


## 3. Install JAVA openjdk17

There are many features available in Shopware, these features require many connected applications, one of which is Java. With the Java application, Shopware becomes a modern, sophisticated application. So that Shopware can run perfectly on FReeBSD, we must install Java on the FreeBSD server. Run the following command to install Java on FreeBSD.

```
root@ns3:~ # cd /usr/ports/java/openjdk17
root@ns3:/usr/ports/java/openjdk17 # make install clean
```

After you have finished installing `openjdk17`, run the command below.

```
root@ns3:~ # mount -t fdescfs fdesc /dev/fd
root@ns3:~ # mount -t procfs proc /proc
```

Then in the `/etc/fstab` file, type the following script.


```
fdesc   /dev/fd         fdescfs         rw      0       0
proc    /proc           procfs          rw      0       0
```


Create a `"JAVA_HOME Variable"` this variable will point to the location where the JDK or JRE is installed on the FreeBSD system. You need to set JAVA_HOME environment in `/etc/csh.cshrc` file. Open the `csh.cshrc` file and type the following script.

```
setenv JAVA_VERSION "17.0+"
setenv JAVA_HOME /usr/local/openjdk17
```

The next step is, you open the .cshrc file, and type the script as in the example below. We use the `"ee"` editor.

```
root@ns3:~ # ee .cshrc
set path = ($JAVA_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```


## 4. Apache24 configuration


The Apache web server is used by Shopware to display all information via the Google Chrome browser or cellphone. With the help of Apache buyers and shop owners can communicate via a web browser. To attract visitors, you can also create an artistic and charming online shop appearance.

We will not discuss how to install apache24. What will be explained in this article is the httpd.conf configuration file. The configuration in this file is very important, because it will connect Shopware to the Apache web server.

Please open the `"/usr/local/etc/apache24/httpd.conf"` file, and type the script below in the file.

```
Alias /shopware "/usr/local/www/shopware/"
<Directory "/usr/local/www/shopware">
Options Indexes FollowSymlinks MultiViews
    AllowOverride All
    Require all granted
</Directory>
```

In the `"/usr/local/etc/apache24/httpd.conf"` file, you also need to enable some apache modules. Activate the following module in the httpd.conf file.

```
LoadModule negotiation_module libexec/apache24/mod_negotiation.so
LoadModule rewrite_module libexec/apache24/mod_rewrite.so
LoadModule headers_module libexec/apache24/mod_headers.so
LoadModule deflate_module libexec/apache24/mod_deflate.so
```

Then you open the `/usr/local/etc/php.ini` file, and you change the memory value, like the script below.

```
memory_limit = 512M
post_max_size = 32M
upload_max_filesize = 32M
display_errors = On
display_startup_errors = On
```


## 5. Install Shopware Dependencies

As we discussed above, Shopware has a lot of dependencies. All of these dependencies will produce the binary files needed to run Shopware. If you don't install dependencies, don't expect to be able to run Shopware. Among the dependencies required by Shopware, PHP is the most dependency that you must install. Run the following command to generate a PHP library file.

```
root@ns3:~ # pkg install php82-curl php82-dom php82-fileinfo php82-gd php82-iconv php82-intl php82-pecl-json_post php82-xmlwriter php82-mbstring php82-pdo php82-pdo_mysql php82-phar php82-simplexml php82-xml php82-zip php82-mysqli php82-zlib pcre2 libxml2
```

After that you continue by installing `"ioncube"`.

```
root@ns3:~ # cd /usr/ports/devel/ioncube
root@ns3:/usr/ports/devel/ioncube # make install clean
```

The next step is to install OpenSearch. OpenSearch is a fork of Elasticsearch which aims to be a Distributed, RESTful, Search Engine built on top of Apache Lucene.

```
root@ns3:/usr/ports/devel/ioncube # cd /usr/ports/textproc/opensearch
root@ns3:/usr/ports/textproc/opensearch # make install clean
```


## 6. Install Shopware 6


After you have finished configuring all the applications described above, now we start the Shopware installation. We will install it to `/usr/local/www`, which is apache's default directory. Because Shopware was created in PHP, we will install it using composer.

As a first step in installation, create a new Shopware project, run the command below.

```
root@ns3:~ # cd /usr/local/www
root@ns3:/usr/local/www # composer create-project shopware/production shopware
```

After you create a Shopware project via Composer, create an .env.local file to connect Shopware to the MySQL server database. You can simply run the copy command by running the following command.

```
root@ns3:/usr/local/www # cd shopware
root@ns3:/usr/local/www/shopware # cp -R .env .env.local
```

Open the `/usr/local/www/shopware/.env.local` file, look for the script below.


```
DATABASE_URL=mysql://root:root@localhost/shopware
```

Then you replace it with the script below.

```
DATABASE_URL=mysql://usershopware:router123@localhost:3306/shopware
```

Pay attention to the replacement script, you took the contents of the script from the MySQL database that was created above. Don't write the user or database password incorrectly. After that, Run the following command to install Shopware.

```
root@ns3:/usr/local/www/shopware # bin/console system:install --basic-setup
```

So that you can run Shopware optimally, you need to add several other applications such as templets and others. You can run the command below.

```
root@ns3:/usr/local/www/shopware # composer require --dev shopware/dev-tools
root@ns3:/usr/local/www/shopware # composer require --dev symfony/profiler-pack
root@ns3:/usr/local/www/shopware # composer require paas
root@ns3:/usr/local/www/shopware # composer require fastly
```

In addition, you can install `"Symfony Flex"`, you need to run the following command and allow both new Composer plugins.


```
root@ns3:/usr/local/www/shopware # composer require symfony/flex:~2 symfony/runtime:~6.2
root@ns3:/usr/local/www/shopware # composer recipe:install --force --reset
```

The final step, you update Shopware.

```
root@ns3:/usr/local/www/shopware # bin/console system:update:prepare
root@ns3:/usr/local/www/shopware # composer update --no-scripts
root@ns3:/usr/local/www/shopware # composer recipes:update
```


## 7. Run Shopware

Before you run Shopware, run the following command to give ownership and permissions to the `/usr/local/www/shopware` directory.

```
root@ns3:/usr/local/www/shopware # chown -R www:www /usr/local/www/shopware
root@ns3:/usr/local/www/shopware # chmod -R 775 /usr/local/www/shopware
```

Shopware can only be run in a web browser. Before you open the web browser, restart the apache24 web server.

```
root@ns3:~ # service apache24 restart
```

Please open the Google Chrome web browser or another, type `"http://192.168.5.2/shopware/public/installer"` in the Google Chrome address bar menu. The result will look like the image below.


![oct-25-60](/img/oct-25/oct-25-60.jpg)



Apart from being an open source e-commerce platform, Shopware is known to be very flexible as it is cloud-based, and self-hosted which includes everything needed to create an online store to carry out product promotions, sell products and analyze profit and loss. Shopware is an ecommerce solution that converts visitors into customers and is designed to help merchants start and run online stores.