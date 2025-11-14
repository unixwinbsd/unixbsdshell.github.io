---
title: FreeBSD 14 to Install and Configure mysql90-server and mysql90-client
date: "2025-07-03 10:25:23 +0100"
updated: "2025-07-03 10:25:23 +0100"
id: install-configure-mysql-server-client-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://linuxiac.com/wp-content/uploads/2024/07/mysql90.jpg
toc: true
comments: true
published: true
excerpt: MySQL is an open-source relational database management system (RDBMS) that uses SQL (Structured Query Language) syntax to create, manage, and manipulate databases on a server
keywords: mysql, server, client, freebsd, database, sql, query, shell, terminal, mariadb, db
---

In relation to MySQL database applications, a database is a collection of structured data that is organized and stored in the form of tables. A database can serve as a central repository where information is managed efficiently, allowing users to store, retrieve, update, and delete data. MySQL provides a software framework for creating, maintaining, and interacting with these databases, so that data storage and retrieval run smoothly and reliably.

MySQL is an open-source relational database management system (RDBMS) that uses SQL (Structured Query Language) syntax to create, manage, and manipulate databases on a server. MySQL serves as a reliable database server for small, medium, and large scale applications to offer continuous data interaction, reliability, and high performance.

At the time of writing this article, the latest version of MySQL is version 9. MySQL server version 9 is one of the SQL (Structured Query Language) database servers that is very fast, multi-threaded, multi-user, and robust. MySQL server is intended for mission-critical production systems with heavy workloads. In addition, mysql90-server can also be embedded in mass-use software.

In this article we will explain how to install MySQL version 9 server and client on FreeBSD 14.0, secure the database server, and enable authenticated access to the database console.



## 📓 1. Install Dependencies

MySQL server requires many dependencies. This is because MySQL can be integrated with various applications such as PHP and others. Therefore, dependencies are the main requirement to start installing the MySQL server.


If we refer to [Freshports FreeBSD](https://www.freshports.org/databases/mysql90-server), there are many dependencies used by MySQL:

**Build dependencies:**
1. liblz4>0 : archivers/liblz4
2. libunwind>0 : devel/libunwind
3. bison : devel/bison
4. cmake : devel/cmake-core
5. pkgconf>=1.3.0_1 : devel/pkgconf

**Runtime dependencies:**
1. groff : textproc/groff
2. perl5>=5.36<5.37 : lang/perl5.36

**Library dependencies:**
1. libcurl.so : ftp/curl
2. libicutu.so : devel/icu
3. liblz4.so : archivers/liblz4
4. libhidapi.so : comms/hidapi
5. libfido2.so : security/libfido2
6. libunwind.so : devel/libunwind
7. libedit.so.0 : devel/libedit
8. libmysqlclient.so.24 : databases/mysql90-client


## 📓 2. Install MySQL

MySQL server and client are available in the default FreeBSD 14 repositories with several versions and additional packages. MySQL can be installed on FreeBSD using the binary distribution provided by Oracle. The most preferred and easiest way to install MySQL is by using the ‘mysql-server’ and ‘mysql-client’ port system available in the FreeBSD 14 repositories.

Follow the steps below to install the latest MySQL database server packages using the pkg package manager and the port system.


### 🧪 a. Install MySQL with FreeBSD ports system
Before you start, make sure your FreeBSD ports system is up to date.

```console
root@hostname1:~ # portmaster -af
root@hostname1:~ # portupgrade -ai
```
Or if you just want to update MySQL, run the following command.

```console
root@hostname1:~ # portmaster databases/mysql90-server
root@hostname1:~ # portupgrade -PP mysql90-server
```
Now we continue by installing MySQL server and client.

```console
root@hostname1:~ # cd /usr/ports/databases/mysql90-client/ && make install clean 
root@hostname1:~ # cd /usr/ports/databases/mysql90-server/ && make install clean
```
### 🧪 b. Install MySQL with package PKG
Before you begin, make sure your FreeBSD PKG package is up to date.

```console
root@hostname1:~ # pkg update -f
root@hostname1:~ # pkg upgrade -f
root@hostname1:~ # pkg bootstrap -f
```
Now we proceed with installing the MySQL server and client.

```console
root@hostname1:~ # pkg install databases/mysql90-client
root@hostname1:~ # pkg install databases/mysql90-server
```
View the version of MySQL installed on your FreeBSD server.

```console
root@hostname1:~ # mysql --version
mysql  Ver 9.0.1 for FreeBSD14.0 on amd64 (Source distribution)
```
### 🧪 c. Enable MySQL in rc.conf
To make MySQL run automatically when the computer is turned off or restarted, add the script below to the `/etc/rc.conf` file.

```console
root@hostname1:~ # ee /etc/rc.conf
mysql_enable="YES"
mysql_dbdir="/var/db/mysql"
mysql_confdir="/usr/local/etc/mysql"
mysql_optfile="/usr/local/etc/mysql/my.cnf"
#mysql_pidfile="/var/db/mysql/hostname1.pid
```

## 📓 3. Running MySQL Server on FreeBSD
MySQL uses the mysql-server system service to control the database server process and runtime on your FreeBSD server. Before running MySQL, you should run the following command to make sure MySQL is running normally or not.

```console
root@hostname1:~ # service mysql-server start
mysql already running?  (pid=1081).
```
```console
root@hostname1:~ # service mysql-server status
mysql is running as pid 857.
```
```console
root@hostname1:~ # service mysql-server stop
Stopping mysql.
Waiting for PIDS: 857.
```
<br/>

```console
root@hostname1:~ # service mysql-server restart
Stopping mysql.
Waiting for PIDS: 1091.
Starting mysql.
```

## 📓 4. Securing MySQL Server
In MySQL application, mysql_secure_installation script is used to remove insecure default settings such as database and authentication for all database users on your database server. Follow the steps below to run the script, set a new root database user password, remove anonymous users, and disable the test database on your server.

```console
root@hostname1:~ # mysql_secure_installation

Securing the MySQL server deployment.

Connecting to MySQL using a blank password.

VALIDATE PASSWORD COMPONENT can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD component?

Press y|Y for Yes, any other key for No: y

There are three levels of password validation policy:

LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary                  file

Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 0
Please set the password for root here.

New password: router1234

Re-enter new password: router1234

Estimated strength of the password: 50
Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
Success.


Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
Success.

By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.


Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
 - Dropping test database...
Success.

 - Removing privileges on test database...
Success.

Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
Success.

All done!
root@hostname1:~ #
```
Once you have created a password for the MySQL user, Restart the MySQL database server to apply your configuration changes.

```console
root@hostname1:~ # service mysql-server restart
```

## 📓 5. How to Access MySQL
You can use the MySQL CLI utility to access the MySQL database server console or other application modules such as php-mysqli that can integrate MySQL with PHP applications. Follow the steps below to access the MySQL console or log in to the MySQL database server.

```console
root@hostname1:~ # mysql -u root -p
Enter password: router1234
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 9.0.1 Source distribution

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

After successfully logging into the MySQL database server, you can run SQL commands or other commands. Here is an example of using MySQL on a FreeBSD system.

### 🧪 a. root user authentication method is [auth_socket]

```console
mysql> select user,host,plugin from mysql.user;
+------------------+-----------+-----------------------+
| user             | host      | plugin                |
+------------------+-----------+-----------------------+
| mysql.infoschema | localhost | caching_sha2_password |
| mysql.session    | localhost | caching_sha2_password |
| mysql.sys        | localhost | caching_sha2_password |
| root             | localhost | caching_sha2_password |
+------------------+-----------+-----------------------+
4 rows in set (0.00 sec)
```
### 🧪 b. View default charset
```console
mysql> show variables like "chara%";
+--------------------------+----------------------------------+
| Variable_name            | Value                            |
+--------------------------+----------------------------------+
| character_set_client     | utf8mb4                          |
| character_set_connection | utf8mb4                          |
| character_set_database   | utf8mb4                          |
| character_set_filesystem | binary                           |
| character_set_results    | utf8mb4                          |
| character_set_server     | utf8mb4                          |
| character_set_system     | utf8mb3                          |
| character_sets_dir       | /usr/local/share/mysql/charsets/ |
+--------------------------+----------------------------------+
8 rows in set (0.02 sec)
```
### 🧪 c. Viewing the database
```console
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)
```
### 🧪 d. create database (test_database)
```console
mysql> create database test_database;
Query OK, 1 row affected (0.05 sec)
```
### 🧪 e. create a table in the database “test_database”
```console
mysql> create table test_database.test_table (id int, name varchar(50), address varchar(50), primary key (id));
Query OK, 0 rows affected (0.20 sec)
```
### 🧪 f. Enter data into the table “test_table”
```console
mysql> insert into test_database.test_table(id, name, address) values("001", "FreeBSD", "Hiroshima");
Query OK, 1 row affected (0.02 sec)
```
### 🧪 g. show table "test_table"
```console
mysql> select * from test_database.test_table;
+----+---------+-----------+
| id | name    | address   |
+----+---------+-----------+
|  1 | FreeBSD | Hiroshima |
+----+---------+-----------+
1 row in set (0.01 sec)
```
### 🧪 h. Delete database "test_database"
```console
mysql> drop database test_database;
Query OK, 1 row affected (0.15 sec)
```
You have installed MySQL 9 on a FreeBSD 14 server and secured the database server to require authentication for all database users. You can use the MySQL database server as a custom backend by modifying the main configuration to listen for connections from specific addresses such as the Drupal network, Ghost Blog, and others.

Additionally, you can install add-on modules to use MySQL with other applications such as PHP on your server.