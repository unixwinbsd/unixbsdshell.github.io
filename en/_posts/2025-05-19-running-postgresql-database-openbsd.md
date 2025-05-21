---
title: Running a PostgreSQL Database on OpenBSD
date: "2025-05-19 19:02:10 +0100"
id: running-postgresql-database-openbsd
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "DataBase"
excerpt: OpenBSD is a very robust, very secure and original Unix operating system, while PostgreSQL is a very stable, powerful, enterprise-grade, modern and full-featured relational database.
keywords: postgresql, sql, database, openbsd, command, installation, running, mariadb
---

OpenBSD is a very robust, very secure and original Unix operating system, while PostgreSQL is a very stable, powerful, enterprise-grade, modern and full-featured relational database. Is it possible to combine the two to create a great database on the OpenBSD operating system? The answer is Yes, of course!. All of this can be done easily by OpenBSD.

OpenBSD has a packaging system that is somehow different from many other operating systems; in particular, packages are thoroughly checked before being installed, so that the installation process will only run if it is absolutely certain that the installation will succeed. Furthermore, the OpenBSD operating system provides a simple and flexible way to manage the PostgreSQL daemon service.

In this short article, I will show you how you can start working with PostgreSQL on OpenBSD.

## 1. System Specifications:
- OS: OpenBSD 7.6 amd64
- Host: Acer Aspire M1800
- Uptime: 17 mins
- Packages: 102 (pkg_info)
- Shell: ksh v5.2.14 99/07/13.2
- Terminal: /dev/ttyp0
- CPU: Intel Core 2 Duo E8400 (2) @ 3.000GHz
- Memory: 55MiB / 1775MiB
- Hostname: ns2
- IP Address: 192.168.5.3
- Domain: inchimediatama.org
- Versi PostgreSQL: postgresql-server-16.4p0
- Versi PHP: php-8.2.27p0

## 2. Install PostgreSQL Dependencies

Dependencies play an important role in PostgreSQL applications. With dependencies, PostgreSQL can run normally on OpenBSD. PHP dependencies are the most dependencies that you must install.

Before you install dependencies, make sure the PHP and PHP-FPM applications have been installed. For the PHP installation process, you can read the previous article.

Below are the commands that you can use to install PostgreSQL dependencies.

```
ns2# pkg_add php-curl-8.2.27 php-gd-8.2.27 php-intl-8.2.27 php-pdo_pgsql-8.2.27 php-zip-8.2.27 redis pecl82-redis
```

## 3. Install PostgreSQL Database

Once PHP, PHP-FPM and the PostgreSQL dependencies are perfectly installed, you can proceed with the PostgreSQL database installation process. OpenBSD uses the pkg package that handles all the packaging mechanisms for installing each application.

While it is true that you can install applications from ports, like other BSD systems, OpenBSD recommends installing via packages because the system can easily keep track of what you have installed so far, and as a result can easily perform updates.

Therefore, the first thing to do is to perform the OpenBSD pkg package update process.

```
ns2# pkg_add -uvi
ns2# pkg_add postgresql-server
```

## 4. Init PostgreSQL database

It is very important to understand the initdb command before setting up PostgreSQL manually. If PostgreSQL is not set up properly in the initial stage, it will not execute queries in the later stages. Users can set up the PostgreSQL server manually using different commands. In the worst case, the PostgreSQL server may not be able to detect the data directory path and fail to start.

The initdb command is used in the initialization process of a database cluster. After the initialization process using the initdb command, a database named postgres will be created inside the database cluster. Postgres serves as the default database used by users, utilities, and third-party applications. In addition to creating the postgres database inside the cluster, another database named template1 is also created inside each cluster.

The template1 database serves as a template for databases created later in the cluster. Remember, the database cluster is the data directory under the file system. To start the initdb process, you can follow the following command.

```
ns2# rm -rf /var/postgresql/data
ns2# su - _postgresql
$ initdb -D /var/postgresql/data/ -U postgres -k -E UTF-8 -A md5 -W
The files belonging to this database system will be owned by user "_postgresql".
This user must also own the server process.

The database cluster will be initialized with locale "C".
The default text search configuration will be set to "english".

Data page checksums are enabled.

Enter new superuser password:
Enter it again:

creating directory /var/postgresql/data ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 20
selecting default shared_buffers ... 128MB
selecting default time zone ... Asia/Jakarta
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    pg_ctl -D /var/postgresql/data/ -l logfile start

$
```

After that, you can start the postgresql service.

```
$ pg_ctl -D /var/postgresql/data/ -l logfile start
waiting for server to start.... done
server started
$ exit
```



