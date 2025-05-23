---
title: FreeBSD Memcached - Installing and Configuring Memcached With PHP
date: "2025-05-22 08:15:35 +0100"
id: memcached-php-freebsd-installation-nginx-php-fpm
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
excerpt: To overcome this, an in-memory database was developed that makes cached items available to website users in a very short time.
keywords: freebsd, php, php-fpm, nginx, website, database, mariadb, sql, mysql, installation
---

Memcached is often used in cases where you want to improve the performance of dynamic applications connected to a database. This in-memory database ensures, among other things, that data is retrieved from RAM without having to access the hard drive. Memcached is useful for lightening the load on the backend system and can also significantly reduce latency.

If you need to create large data samples such as the Comments/Best Articles column for daily or weekly, Directory Navigation menus, user profile data, etc.) or calculate in PHP some data that is not needed in real time, then the data needs to be cached. Memcached allows you to cache database queries from MySQL, MariaDB or other servers via PHP to reduce the load on the database.

Popular websites like YouTube, Facebook, Twitter, and Wikipedia have long used Memcached to reduce latency and database load. But how exactly does Memcached work and what are the first steps to implementing it?

The diagram below illustrates what your memcached infrastructure will look like when you implement memcached in your environment. You’ll notice that the memcached servers don’t communicate directly with your database servers. Instead, they live in their own pool and your application does all the work.

![memcached infrastructure](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/memcached_infrastructure.jpg)

In this article we will learn the installation procedure, configuration and how to use memcached on a FreeBSD 14.3 server.

## 1. System Specifications
FreeBSD System: FreeBSD 14.3-PRERELEASE
IP Address: 192.168.5.71
Hostname: ns4
PHP Version: PHP83
Memcached Version: memcached 1.6.26
NGINX Version: nginx/1.24.0
Dependencies: php83-ctype, php83-mbstring, php83-extensions dan php83-mysqli, php-fpm, pecl-memcached

## 2. Why Memcached is Important
What is Memcached? The simplest answer to that question is that it is a high-performance caching system developed almost twenty years ago by Danga Interactive for the LiveJournal Internet portal. This cache server was created to prevent the slowdown caused by database access when using sophisticated web applications.

To overcome this, an in-memory database was developed that makes cached items available to website users in a very short time. Since Memcached is able to store data in RAM, all the information the user needs can be accessed much faster. Memcached software is very easy to use, install, and configure. Furthermore, since it runs under the BSD license, it can also be freely used, modified, and copied.

The main purpose of Memcached is to optimize application performance by reducing the load on the database server. Especially in applications that require a lot of reading, caching this data provides a significant advantage over accessing the same data repeatedly. In this way, the database server operates with less load and can concentrate on other important operations.

Some of the advantages and benefits of Memcached can be seen in the following table.

| Method       | Explanation          | Benefit        | 
| ----------- | -----------   | ----------- |
| Caching          | Temporary storage for frequently accessed data  | Reduce the load on the database and speed up response times   |
| Database Optimization          | Query and schema optimization.      | Faster query execution, lower resource consumption          |
| Load balancer          | Distribution of traffic between multiple servers.     | Maintains performance even in heavy traffic situations          |
| Data partitioning          | Splitting a large database into smaller parts  | Faster query processing, better scalability          |

In addition to having many advantages, Memcached also has many disadvantages. The following table explains some of the advantages and disadvantages of using Memcached.



| Advantages       | Disadvantages          | 
| ----------- | -----------   | 
| Multiprocess architecture enables vertical scalability of computing power.          | Data is not visible, making it difficult to debug.          | 
| Very short response time thanks to storing values ​​in memory          | It only stores data temporarily and loses data if the Memcached instance fails.      | 
| Supports open data formats and most common clients and programming languages.          | Non-redundant, meaning it does not duplicate or back up data to protect against failure.     | 
| Offers ease of use and flexibility for application development          | Lack of security mechanisms requires the use of additional firewalls  | 
| A mature open source solution with open data storage          | The value key length is limited to 250 characters (1 MB)  | 

## 3. Installation Process
In this process there are many dependencies that you have to install, because Memcached is used with PHP with NGINX, PHP or others. So there will be many PHP dependencies that you have to install.
### 3.1. Install PHP and PHP-FPM
In the section we will not discuss, to do this process you can read the previous article that explains the installation process. We assume you have activated PHP and PHP-FPM.
### 3.2. Install Memcached
In this process we will use the ports system to install Memcached. On FreeBSD Memcached ports are located in the /usr/ports/databases/memcached directory. Run the command below to start the Memcached installation process.

```
root@ns4:~ # cd /usr/ports/databases/memcached
root@ns4:/usr/ports/databases/memcached # make install clean
```


### 3.3. Enable Memcached to start automatically at boot.
To enable memcached to start automatically at boot, you must type the script in the /etc/rc.conf file. In addition to typing it directly, there is another alternative by running the sysrc command. This command is a command line utility that manages system services on a FreeBSD server. With the sysrc command you can directly enable memcached.

```
root@ns4:~ # sysrc memcached_enable="YES"
memcached_enable:  -> YES
root@ns4:~ # sysrc memcached_flags="-l 192.168.5.71 -p 11211 -m 128 -c 1024"
memcached_flags:  -> -l 192.168.5.71 -p 11211 -m 128 -c 1024
```

The above command is used to enable the memcached Server to Operation over TCP/IP Mode. If you want to enable memcached to # Memcached Server. UNIX socket mode, use the below command.

```
root@ns4:~ # sysrc memcached_enable="YES"
memcached_enable:  -> YES
root@ns4:~ # sysrc memcached_flags="-s /var/run/memcached/memcached.sock -a 700"
memcached_flags:  -> -s /var/run/memcached/memcached.sock -a 700
```

You can choose from the two methods above. In this article, we will activate memcached to TCP/IP mode, with IP 192.168.5.71 as the IP address of the FreeBSD server being used.

Below is a table of basic memcached startup parameters that you can use as a reference to activate memcached.

| Description       | Parameters and default values          | 
| ----------- | -----------   | 
| -s          | Path to socket. Runs in socket mode (TCP/IP doesn't work)          | 
| -a          | Socket access rights. The default value is 700.      | 
| -l          | The IP addresses that Memcached listens on. By default, all addresses     | 
| -p          | The port that Memcached listens on. The default is 11211 TCP.  | 
| -m          | Maximum object size, in megabytes. The default size is 64Mb.          | 
| -d          | Run as daemon          | 
| -c          | Maximum simultaneous connections, default is 1024.          | 










