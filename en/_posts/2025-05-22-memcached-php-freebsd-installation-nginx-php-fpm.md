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











