---
title: FreeBSD step-by-step guide to installing Yii PHP Framework
date: "2025-10-15 09:13:46 +0100"
updated: "2025-10-15 09:13:46 +0100"
id: step-by-step-installing-yii-php-framework-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-76.jpg
toc: true
comments: true
published: true
excerpt: PKG packages and FreeBSD Ports are not available in Yii; you must install Yii with Composer. So, make sure your FreeBSD has PHP Composer installed. Follow the guide below to install Yii on FreeBSD.
keywords: freebsd, yii, yii2, php, laravel, composer, framework, web server, apache, nginx, installing
---

Yii, short for "yes," is a component-oriented PHP framework. Yii's high performance makes it ideal for scalable web applications. It comes with a variety of features, including MVC, DAO/ActiveRecord, and I18N/L10N. It also supports jQuery-based AJAX, role-based access control, scaffolding, input validation, widgets, events, themes, web services, and more. Written in pure OOP, Yii is easy to use, yet highly flexible and extensible.

Yii's advantages over other frameworks are its high speed and excellent OOP support. Yii also boasts a wealth of libraries. With Yii, you can easily create web applications that meet all modern standards. Built-in methods are one feature that can help you significantly reduce the amount of code.

<div align="center">
    <b>
"A framework is a type of framework for developing web applications. Frameworks can help simplify and speed up the development of web projects."
    </b>
</div>

<br/>

Yii is released under the BSD license, allowing it to be used commercially and embedded in proprietary products. Yii has excellent documentation and a large community. This large developer community provides an opportunity to quickly get help and discuss important topics.

<br/>

![How to install Yii PHP Framework on FreeBSD](/img/oct-25/oct-25-76.jpg)

<br/>


The Yii framework developers adhere to the philosophy of code simplicity and elegance, making the framework extensible and easy to use. You can replace or edit almost any major part of the code, and you're also free to share code provided by the community. Another important aspect is that Yii supports rapid project prototyping.

This article will explain how to install and run the Yii framework on a FreeBSD server.

## 1. Yii PHP Framework Installation Guide
PKG packages and FreeBSD Ports are not available in Yii; you must install Yii with Composer. So, make sure your FreeBSD has PHP Composer installed. Follow the guide below to install Yii on FreeBSD.

```
root@ns3:~ # cd /usr/local/www
root@ns3:/usr/local/www # git clone https://github.com/yiisoft/yii2.git
```

**After downloading Yii from the GitHub repository, you can install Yii in two ways:**
- Using Composer.
- Downloading the Yii archive directly.

For most people, installing Yii with Composer is preferable because it allows new extensions or Yii updates to be installed with a single command line. In Yii 2, unlike Yii 1, after the installation process is complete, you'll get the framework and application templates. Run the following command to install Yii2 with `Composer`.

```
root@ns3:/usr/local/www # cd yii2
root@ns3:/usr/local/www/yii2 # composer create-project --prefer-dist --stability=dev yiisoft/yii2-app-basic basic
```

## 2. Create a Database for Yii

Yii 2 uses a database as its backend, its function being to store all Yii user information. In this article, we will use a database server commonly used by developers, namely the MySQL server.

We will create a Yii2 database using MySQL. Using PHP, the MySQL database will connect to the Yii 2 server. The guide below will explain the process of creating a Yii2 database.


```
root@ns3:~ # mysql -u root -p
Enter password:
root@localhost [(none)]> CREATE DATABASE yii2basic CHARACTER SET utf8;
root@localhost [(none)]> CREATE USER 'useryii'@'localhost' IDENTIFIED BY 'freebsdyii';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON yii2basic.* TO 'useryii'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]> exit;
Bye
root@ns3:~ #
```

After that, you open the `/usr/local/www/yii2/basic/config` directory, look for the `db.php` file and change the script as in the example below.


```
root@ns3:~ # cd /usr/local/www/yii2/basic/config
root@ns3:/usr/local/www/yii2/basic/config # ee db.php
<?php

return [
    'class' => 'yii\db\Connection',
    'dsn' => 'mysql:host=localhost;dbname=yii2basic',
    'username' => 'root',
    'password' => 'freebsdyii',
    'charset' => 'utf8',

    // Schema cache options (for production environment)
    //'enableSchemaCache' => true,
    //'schemaCacheDuration' => 60,
    //'schemaCache' => 'cache',
];
```

Match the password with the database password you created above.

The final step is to start the Yii 2 server with the following command.


```
root@ns3:/usr/local/www/yii2/basic/config # cd /usr/local/www/yii2/basic
root@ns3:/usr/local/www/yii2/basic # php yii serve 192.168.5.2 --port=8888
```

Please open the Google Chrome web browser and type `"http://192.168.5.2:8888/"` and check the results. If there are no incorrect configurations, you should see an image like the one below.

![Yii PHP Framework Dashboard](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25-77.jpg)


After reading this article, we assume you've successfully installed Yii 2 on FreeBSD. Furthermore, you've learned about the Yii PHP Framework and its features. You can customize each feature to suit the needs of the website you're developing.
