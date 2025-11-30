---
title: FreeBSD Tutorial - How to Install Drupal to Create a Blog
date: "2025-11-30 13:11:29 +0000"
updated: "2025-11-30 13:11:29 +0000"
id: tutorials-how-to-install-drupal-create-blog
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-038.jpg
toc: true
comments: true
published: true
excerpt: In this article, we'll explain how to install and configure Drupal with Apache24, PHP82, and a MySQL server. The entire article was written and executed on a FreeBSD 13.2 server.
keywords: freebsd, tutorials, drupal, cms, framework, drush, cli, command, blog, blogsite, blogger, php
---

Drupal may be a foreign word, rarely heard by the general public, as it's a term rarely heard. However, the situation is different for those involved in website development. Drupal has become a familiar term to web developers. Its open-source nature makes it easy for website owners to create, develop, and manage websites.

Drupal is an open-source database application developed using the PHP programming language. This database application is licensed under the GPL (Global Public License).

Drupal is a Content Management System (CMS) developed in 2000 by Belgian students. This CMS also competes with other popular CMSs like WordPress and Joomla. If you're a website developer looking for a CMS with multiple functions, Drupal could be a good choice. Like other CMSs, Drupal has many features that can be used to make things easier for users.

Compared to other CMSs like WordPress, Drupal is arguably more feature-rich and easier to develop. Due to its wide range of available features, people sometimes mistake Drupal for a confusing CMS. However, Drupal's features are far more comprehensive and easier to develop.

<figure class="figure">
 <img src="https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-038.jpg" class="figure-img img-fluid rounded" alt="FreeBSD Tutorial - How to Install Drupal to Create a Blog" title="Welcome To Drupal (localhost)"/>
 <figcaption class="figure-caption text-center mt-2">
Welcome To Drupal (localhost)
 </figcaption>
 </figure>

Therefore, if you're considering using this CMS, it's a good idea to first learn all of its features. Some of the most frequently asked questions from website administrators are themes and plugins. Like WordPress, Drupal offers a variety of themes and plugins, both free and paid. In the Drupal world, plugins are called modules. So, what makes Drupal special compared to other popular CMSs?

In this article, we'll explain how to install and configure Drupal with `Apache24, PHP82, and a MySQL server`. The entire content of this article was developed and run on a FreeBSD 13.2 server.

## A. System Specifications

<blockquote class="blockquote">
<p>
OS: FreeBSD 13.2
Hostname: ns3
Domain: datainchi@gmail.com
IP Address: 192.168.5.2
php82-opcache
Database: mysql80-server
PHP version: PHP82
Apache version: apache24
PHP-FPM
mod PHP82 dan PHP82 extension
</p>
</blockquote>

## B. Install php82-opcache

Before we begin the Drupal installation process, let's assume that all of the above applications are already installed and running on your FreeBSD server. If not, you must install them first.

For guidance, you can read our previous article on the installation process for all of the above applications. On our blog, there's a guide on how to install the above applications. In the search bar, type the title of the article you want to search for. The process is quite simple.

One PHP extension that Drupal really needs is php82-opcache. This PHP extension optimizes web applications by caching PHP script tasks.

Use the following command to install `php82-opcache`.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">Install php82-opcache</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">root@ns3:~ # <span style="color: red;">pkg install php82-opcache</span></span></span></pre>

The php82-opcache configuration file is named `"php.ini"`. Open the file `"/usr/local/etc/php.ini"` and run the script below.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">/usr/local/etc/php.ini</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=2
opcache.enable_cli=1</span></span></pre>

  <script type="text/javascript">
	atOptions = {
		'key' : '88e2ead0fd62d24dc3871c471a86374c',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
</script>
<script type="text/javascript" src="//www.highperformanceformat.com/88e2ead0fd62d24dc3871c471a86374c/invoke.js"></script>


## C. Create a database for Drupal

Almost all CMS frameworks use a database to store data. Drupal is no exception; you must install a database for it to run properly. One of Drupal's advantages is its ability to use a wide variety of databases. In this article, we will use the MySQL server as the Drupal database.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">Create a Drupal database</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">root@ns3:~ # <span style="color: red;">mysql -u root -p</span>
<span style="color: #ffa400;"><i>Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.35 Source distribution</i></span>

root@localhost [(none)]&gt;</span></span></pre>

Once you're connected to the MySQL server, we'll create:
- Database name: **drupal**
- User Name: **userdrupal**
- User Password: **router123**

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">Create a username and password</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">root@localhost [(none)]&gt; <span style="color: red;">CREATE DATABASE drupal CHARACTER SET utf8;</span>
<span style="color: #ffa400;">Query OK, 1 row affected, 1 warning (0.05 sec)</span>

root@localhost [(none)]&gt; <span style="color: red;">CREATE USER 'userdrupal'@'localhost' IDENTIFIED BY 'router123';</span>
<span style="color: #ffa400;">Query OK, 0 rows affected (0.05 sec)</span>

root@localhost [(none)]&gt; <span style="color: red;">GRANT ALL PRIVILEGES ON drupal.* TO 'userdrupal'@'localhost';</span>
<span style="color: #ffa400;">Query OK, 0 rows affected (0.03 sec)</span>

root@localhost [(none)]&gt; <span style="color: red;">FLUSH PRIVILEGES;</span>
<span style="color: #ffa400;">Query OK, 0 rows affected (0.01 sec)</span>

root@localhost [(none)]&gt;</span></span></pre>

When creating a database with a MySQL server, it's important to remember the database name, username, and password. Save these and always remember them, as we'll use them to connect to the Drupal server.

## D. Install Drupal

To ensure all Drupal libraries are installed correctly, we use the ports system to install Drupal. The following commands are typed into the PuTTY shell.

In the dialog box that appears, check the `"MySQL"` option and uncheck the others. Once you've checked the "MySQL" option, simply type the command `"make install clean"`.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">Create a username and password</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">root@ns3:/usr/ports/www/drupal10 # <span style="color: red;">make install clean</span></span></span></pre>

In order for Drupal to connect to apache24, you must include a Drupal script in the `"httpd.conf"` file. Place the following script in the `"/usr/local/etc/apache24/httpd.conf"` file.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">/usr/local/etc/apache24/httpd.conf</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">Alias ​​/drupal "/usr/local/www/drupal10/"
&lt;Directory "/usr/local/www/drupal10"&gt; 
Options Indexes FollowSymlinks MultiViews 
AllowOverride All 
Require all granted
&lt;/Directory&gt;</span></span></pre>

To enable CNC support when setting up Drupal with `apache24`, you need to uncomment the line in the `/usr/local/www/drupal10/.htaccess` file.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">/usr/local/www/drupal10/.htaccess</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">RewriteBase /drupal</span></span></pre>

`RewriteBase /drupal`, where drupal is an alias in `"/usr/local/etc/apache24/httpd.conf"`.

Next, you create a Drupal configuration file with permissions that match Drupal's default settings.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">Copy the default.settings.php file to settings.php</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">root@ns3:~ # <span style="color: red;">cd /usr/local/www/drupal10/sites/default</span>
root@ns3:/usr/local/www/drupal10/sites/default # <span style="color: red;">cp default.settings.php settings.php</span></span></span></pre>

Next, you restart apache24, and run Drupal.

<div class="fw-bold fw-light fs-6" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; margin: 0px; padding: 0px 10px;">Restart apache</div>
<pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px;"><span style="font-family: Times New Roman;"><span style="font-size: 14.4px;">root@ns3:/usr/local/www/drupal10/sites/default # <span style="color: red;">service apache24 restart</span></span></span></pre>

Open the Google Chrome web browser and type `"http://192.168.5.2/drupal/core/install.php"` or `"http://192.168.5.2/drupal"`.

Once you've successfully installed Drupal, enjoy the ease and power of creating a website or blog on your FreeBSD server. For more advanced settings and complex configurations, see the [official manual](https://www.drupal.org/documentation?ref=vegastack.com).
