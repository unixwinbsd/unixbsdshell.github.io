---
title: Getting Started Joomla On FreeBSD With PostgreSQL
date: "2025-05-21 20:25:35 +0100"
updated: "2025-05-21 20:25:35 +0100"
id: getting-started-joomla-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: With the Joomla application we can create almost any website-based project, with the support of the standard features that Joomla has, it allows us to do many things in designing a website.
keywords: joomla, freebsd, apache, nginx, php, php-fpm, mod php, ekstensi php, module
---

Apart from WordPress, Joomla is considered one of the most popular CMS. The name "Joomla" comes from the Swahili word "Jumla" (originating from the African region). This word is translated as “together". The developers did the choice of name correctly, because this system has become very popular, and is currently used all over the world. With the help of a large community, Joomla is constantly updated and receives new features and changes interface that makes the system more attractive to potential users.

With the Joomla application we can create almost any website-based project, with the support of the standard features that Joomla has, it allows us to do many things in designing a website. However, if the function of this feature is felt to be less helpful. we can easily install the Joomla plugin. By using Joomla we don't need to involve third party developers and learn programming languages. Everything is done simply and clearly.

Joomla is a software product that allows us to create and design websites without knowledge of programming languages. Therefore, Joomla is often chosen by those who create their own websites. In terms of popularity, this engine ranks second in the world, second only to WordPress.

In this article we will discuss how to install and configure Joomla on a FreeBSD system. This article will explain the steps to install Joomla and PHP dependencies so that Joomla can run on a FreeBSD system.


## 1. Understanding Joomla

As we have explained above, Joomla is an open source CMS or content management system. Code in Joomla allows us to develop various solutions to improve functionality. Moreover, each developer decides for himself whether to sell the plugin or distribute it for free. Like WordPress, this system is great for people who want to create their own project from scratch for the first time. Joomla also has a simple interface. There are more business opportunities here. The CMS itself is completely free, although you still have to pay to use some extensions. However, this is not always necessary.

No matter what type of website we are going to design, Joomla can easily design a powerful website, Blog, simple page or online store with many categories and products. Joomla allows us to create projects of very high complexity.

There are rarely any difficulties when installing Joomla CMS. And some hosting sites even offer automatic installation, which makes the process faster and easier. All you need to do is choose a hosting package and register a domain name. Immediately after installation, continue working directly with the site. By the way, Joomla is completely Russified, so knowledge of foreign languages is not required.

It is worth noting that the working interface can be displayed in any language, which is available thanks to the built-in administration functions. Even if we have no programming knowledge, with Joomla, we are in full control of website management without requiring additional investment in the system.


## 2. System Specifications
- OS: FreeBSD 13.2
- Hostname/Domain: ns1@unixexplore.com
- IP Address: 192.168.5.2
- Joomla4
- Apache24
- PHP82
- modul dan extension PHP
- PostgreSQL 15.3

## 3. Joomla installation

Every Joomla application that is installed on a server definitely requires a database to store Joomla data. In this article we will use the PostgreSQL 15.3 database as the backend of Joomla. You can read our article which discusses the PostgreSQL database installation process.

For the Joomla frontend, we will use Apache24, so that Joomla can connect to ports 80 and 443. What you need to pay attention to if you use Apache24 as a Joomla frontend, is that all PHP modules and extensions must be installed on the Apache24 system, if PHP, its modules and extensions are not yet installed. install don't expect Joomla to run on a FreeBSD system. For the PHP installation process and its modules and extensions, you can search on the Blogspot search menu. We have written the complete PHP installation process along with its modules and extensions.

OK, let's just assume that Apache24 and PHP have been installed perfectly on our FreeBSD system, so now we just continue with the Joomla installation process on FreeBSD. In almost all Opensource operating systems, the Joomla installation process is very easy, with just a few commands Joomla can be successfully installed.

```
root@ns1:~ # cd /usr/ports/www/joomla4
root@ns1:/usr/ports/www/joomla4 # make config
root@ns1:/usr/ports/www/joomla4 # make install clean
```

When you run the "make config" command, usually several options will appear that must be activated, because in this article we are using the PostgreSQL database, so you must activate the PostgreSQL option.

Just follow and complete the installation process, and usually after the installation process is complete, the Joomla developer will notify you of the Joomla configuration process, as shown below.

```

===>  Installing for joomla4-4.3.2
===>  Checking if joomla4 is already installed
===>   Registering installation for joomla4-4.3.2
Installing joomla4-4.3.2...
 1) Add the following to your Apache configuration, and restart the server:

  Alias /joomla /usr/local/www/joomla/
  AcceptPathInfo On

  <Directory /usr/local/www/joomla>
      AllowOverride None
      Order Allow,Deny
      Require all granted
  </Directory>

 2) Visit your Joomla site with a browser (i.e. http://your.server.com/joomla/),
    and you should be taken to the install.php script, which will lead you
    through creating a config.php file and then setting up Joomla, creating
    an admin account, etc.

===>  Cleaning for joomla4-4.3.2
root@ns1:/usr/ports/www/joomla4 #
```

## 4. Joomla configuration

For the installation process, we just follow the Joomla developer's instructions above, open the file **/usr/local/etc/apache24/httpd.conf** and move the cursor to the bottom position of the script, then you copy the script above into that file.

```

root@ns1:/usr/ports/www/joomla4 # ee /usr/local/etc/apache24/httpd.conf

 Alias /joomla /usr/local/www/joomla/
  <Directory /usr/local/www/joomla>
      AllowOverride None
      Order Allow,Deny
      Require all granted
  </Directory>
```

From the script above we can read that the root folder of the Joomla application is in the **/usr/local/www/joomla** folder. To make sure, check the folder to see if there are Joomla files. By default the file will be directly in that folder.


## 5. Running Joomla

After the configuration and installation process above has been completed, now is the time for us to run Joomla. The first step to run Joomla is to restart Apache24.

```

root@ns1:~ # service apache24 restart
```

After restarting Apache, open any web browser according to your taste, it can be Google Chrome. Yandex, Opera and others. In the address bar box, type the following command **"http://192.168.5.2/joomla/installation/index.php"**, if there is nothing wrong with the configuration above, you should be able to open Joomla in a web browser.


## 6. Apache24 Default DocumentRoot

If using the above method Joomla cannot be opened in the Chrome or Yandex web browser, use Apache24's default Document root. By default the Apache24 Document Root is located in the **"/usr/local/www/apache24/data"** folder. Now we will run Joomla from that folder, if Joomla cannot be opened using the method in sub-chapter 5.

Type the following command to copy all Joomla4 files to the **"/usr/local/www/apache24/data"** folder.

```

root@ns1:~ # cp -rf /usr/local/www/joomla4/ /usr/local/www/apache24/data/
```

After that restart Apache24.

```

root@ns1:~ # service apache24 restart
```

Reopen the Google Chrome, Yandex, Firefox, Opera or other web browser and type **"http://192.168.5.2/joomla/installation/index.php"**.

Joomla4 is an update that comes with a set of new features and improvements. This version offers improved performance and security, a better user experience, and a suite of modern technologies that make it easier to integrate with other web technologies.

If you believe that migrating your website to Joomla4 is the right choice, don't hesitate to take action now. Migrating to Joomla4 is a simple process that can be done with the help of an experienced web developer. So, don't wait any longer. Take the first step to migrate your website to Joomla4 today, and enjoy all the benefits that come with it.
