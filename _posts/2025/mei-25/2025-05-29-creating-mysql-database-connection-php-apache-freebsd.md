---
title: Creating a MySQL Database Connection with PHP and Apache on FreeBSD
date: "2025-05-29 12:01:00 +0100"
updated: "2025-05-29 12:01:00 +0100"
id: creating-mysql-database-connection-php-apache-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/16Diagram%20connection%20mysql%20php%20apache.jpg&commit=41fa30768b6c67e161bf87bcdccc5e8ba3ec7338
toc: true
comments: true
published: true
excerpt: PHP has several functions to connect and interact with the database. MySql Server. The most common and frequently used by system administrators to make requests from PHP to the MySQL Server database are mysqli_connect mysqli_query mysqli_close
keywords: creating, mysql, database, connection, php, apache, freensd, phpmyadmin, pdo, mysqli
---

PHP has several functions to connect and interact with the database. MySql Server. The most common and frequently used by system administrators to make requests from PHP to the MySQL Server database are:
- `mysqli_connect:` Used to create a connection to a MySql database server.
- `mysqli_query:` Used to send SQL queries to a MySQL database.
- `mysqli_close:` Used to close a database connection.

In its function `mysqli_connect` must accept three parameters in order to connect to the MySQL database, namely:
- server address (host).
- username, and
- user password.

These three requirements come from the MySQL server, either on a private server or a hosting service. After `mysqli_connec`t receives these three conditions, it will return data describing the connection, which will then be forwarded to `mysqli_query`.

Furthermore, all database manipulation is done using various SQL queries through mysqli_query. Using SQL queries, you can create and delete tables, make data selections based on certain types of filters, and add and delete rows. In its function `mysqli_query` accepts two parameters:
- The first is the data describing the connection (the result of mysqli_connect), and
- The second is the SQL query in the form of a simple string.

<br/>
<img alt="diagram connection mysql php and apache" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/16Diagram%20connection%20mysql%20php%20apache.jpg&commit=41fa30768b6c67e161bf87bcdccc5e8ba3ec7338' | relative_url }}">
<br/>

In this article we will learn how to connect PHP files to a MySql Server database. Before we go any further, you should read the article related to the material we will be studying now.

## 1. System Specifications
- OS: FreeBSD 13.2
- IP Address: 192.168.5.2
- Hostname: ns1
- Apache24
- PHP mods and extensions
- MySQL: mysql80-server
- php: php82
- phpMyAdmin: phpMyAdmin5-php82

## 2. Creating a MySQL Database
To start this lesson, make sure the Mysql server program is installed on the FreeBSD server, in this article we use the mysql80-server version. As a first step to make it easier to practice database connections with PHP, we will start by creating a MySQL Server database.

Before starting, make sure the `bind-address` script in the `/usr/local/etc/mysql/my.cnf` file has been changed to the FreeBSD server's private IP, which is `192.168.5.2`, as in the example below.


```console
root@ns1:~ # ee /usr/local/etc/mysql/my.cnf

[client]
port                            = 3306
socket                          = /tmp/mysql.sock

[mysql]
prompt                          = \u@\h [\d]>\_
no_auto_rehash

[mysqld]
user                            = mysql
port                            = 3306
socket                          = /tmp/mysql.sock
bind-address                    = 192.168.5.2
basedir                         = /usr/local
datadir                         = /var/db/mysql
```

### a. Creating a MySQL user
In order for the MySQL database to be connected to PHP, a database user is needed to bridge MySQL and PHP. This user stores password information and various MySQL database information. The following is an example of creating a user with MySQL.

```console
root@ns1:~ # mysql -u root -p
Enter password: router
root@localhost [(none)]> 
```

In the above script, `router` is the root password of the MySQL server installed on the FreeBSD computer. Once we are at the MySQL command line, we log into the MySQL database.

```console
root@localhost [(none)]> use mysql;
Database changed
root@localhost [mysql]> select user,host from user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
| root             | localhost |
+------------------+-----------+
4 rows in set (0.00 sec)

root@localhost [mysql]>
```

The first script activates the MySQL database, while the second script checks the active users in the MySQL database.

After that, we continue by creating a new user. Type the command below to create a new user on the MySQL server.

```console
root@localhost [mysql]> CREATE USER 'semeru'@'192.168.5.2' IDENTIFIED BY 'gunungsemeru';
Query OK, 0 rows affected (0.05 sec)

root@localhost [mysql]> GRANT SELECT ON *.* TO 'semeru'@'192.168.5.2';
Query OK, 0 rows affected (0.02 sec)

root@localhost [mysql]>
```

The script description above is to create a user `semeru` with a password of `gunungsemeru` and a host of `192.168.5.2`. For the host name, we can replace it with the host name in the `/etc/rc.conf` file.

In this article, our FreeBSD server has a hostname of `ns1`. Here's how to create a user with the hostname of `ns1`.

```console
root@localhost [mysql]> CREATE USER 'rinjani'@'ns1' IDENTIFIED BY 'gunungrinjani';
Query OK, 0 rows affected (0.05 sec)

root@localhost [mysql]> GRANT SELECT ON *.* TO 'rinjani'@'ns1';
Query OK, 0 rows affected (0.03 sec)

root@localhost [mysql]>
```

### b. Creating a database and table in MySQL
Now that we know how to create a user in MySQL, let's continue by creating a database and table. Here is the script used to create a database in MySQL.

```console
root@localhost [mysql]> CREATE DATABASE bromo;
Query OK, 1 row affected (0.05 sec)

root@localhost [mysql]> CREATE DATABASE anjani;
Query OK, 1 row affected (0.04 sec)

root@localhost [mysql]>
```

The above script creates a new database named `bromo` and `anjani`. To see the results of database creation, use the command below.

```console
root@localhost [mysql]> show databases;
+--------------------+
| Database           |
+--------------------+
| anjani             |
| bromo              |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
6 rows in set (0.01 sec)
```

After successfully creating a database, we will continue by creating a table. The following are the commands used to create a table on the MySQL server.

```console
root@localhost [mysql]> CREATE TABLE gunung ( namagunung VARCHAR(128), daerah VARCHAR(90), ketinggian VARCHAR(30));
Query OK, 0 rows affected (0.18 sec)
```

The script above will create a new table named `gunung` with the table contents `nama gunung`, `luas` and `ketinggian`.

After that, we will enter data or insert data into the table. The command below is used to insert data into the table.

```console
root@localhost [mysql]> INSERT INTO gunung VALUES('gunung semeru', 'Jawa Timur', '3676 m');
Query OK, 1 row affected (0.04 sec)

root@localhost [mysql]> INSERT INTO gunung VALUES('gunung rinjani', 'NTB', '3726 m');
Query OK, 1 row affected (0.02 sec)

root@localhost [mysql]> INSERT INTO gunung VALUES('gunung merbabu', 'Jawa Tengah', '3145 m');
Query OK, 1 row affected (0.02 sec)
```

To see the results, use the command below.

```console
root@localhost [mysql]> SHOW TABLES;
+------------------------------------------------------+
| Tables_in_mysql                                      |
+------------------------------------------------------+
| columns_priv                                         |
| component                                            |
| db                                                   |
| gunung                                               |
| servers                                              |
| user                                                 |
+------------------------------------------------------+
38 rows in set (0.00 sec)

root@localhost [mysql]> SELECT * FROM gunung;
+----------------+-------------+------------+
| namagunung     | daerah      | ketinggian |
+----------------+-------------+------------+
| gunung semeru  | Jawa Timur  | 3676 m     |
| gunung rinjani | NTB         | 3726 m     |
| gunung merbabu | Jawa Tengah | 3145 m     |
+----------------+-------------+------------+
3 rows in set (0.00 sec)
```

To test or try the results of the material we have learned above, you can use `phpmyadmin`. Try logging in with the user `semeru` and `rinjani`.

After successfully logging in, in phpmyadmin open the mysql database, and see the results.

## 3. Creating a MySQL Database Connection with PHP
### a. Connection with mysqli
Before you learn part 3 further, make sure the system specifications above have been installed on the FreeBSD server and you have also read the article we recommended above. Okay, let's start with part 3 of this material.

As a first step, we will install the `php82-mysqli` and `php82-pdo` applications. Both of these applications will connect PHP to the MySQL server.

```console
root@ns1:~ # cd /usr/ports/databases/php82-mysqli/ && make install clean
root@ns1:/usr/ports/databases/php82-mysqli # cd /usr/ports/databases/php82-pdo/ && make install clean
```

Let's continue the material, now it's time to connect PHP to the MySQL server. To test this connection, we will create a new file named `testkoneksi.php` which we will place in the `/usr/local/www/apache24/data` folder. In the `/usr/local/www/apache24/data/testkoneksi.php` file, type the script below.

```console
root@ns1:~ # ee /usr/local/www/apache24/data/testkoneksi.php

<?php
$servername = "192.168.5.2";
$username = "semeru";
$password = "gunungsemeru";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
echo "Happy! You have successfully connected PHP to the MySQL Server Database";
?>
```

The next step is to restart the apache24 web server.

```console
root@ns1:~ # service apache24 restart
```

After the apache24 server has been successfully restarted, open the Google Chrome, Yandex or Firefox web browser. In the address bar menu, type `http://192.168.5.2/testkoneksi.php`, and see the results on your monitor screen.

### b. Connection with pdo
After we have successfully created a connection with mysqli, now we continue with the pdo connection. Follow these steps to create a PHP MySQL Server connection with PDO.

The first step is to create a file named `/usr/local/www/apache24/data/koneksipdo.php`. In the `koneksipdo.php` file, enter the following script.

```console
root@ns1:~ # ee /usr/local/www/apache24/data/koneksipdo.php

<?php
$servername = "192.168.5.2";
$username = "semeru";
$password = "gunungsemeru";

try {
  $conn = new PDO("mysql:host=$servername;dbname=bromo", $username, $password);
  // set the PDO error mode to exception
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  echo "Selamat! Anda telah berhasil menghubungkan PHP PDO dengan Database MySQL Server";
} catch(PDOException $e) {
  echo "Connection failed: " . $e->getMessage();
}
?>
```

Try, pay attention to the script `dbname=bromo` above. In creating a MySql database connection with PHP PDO, a database is required (this is what distinguishes it from a MySQL connection). Because in this article material we have created a database with the name `bromo` and `anjani`, so we can choose one of the two. In this case to create a connection with PDO, we take the `bromo` database.

How?, up to here do you understand about creating a PHP connection with MySQL Server. If not, restart the apache24 server.

```console
root@ns1:~ # service apache24 restart
```

Then open the Google Chrome web browser, and type `http://192.168.5.2/koneksipdo.php`, see the results, is your database connection with PHP PDO successful?.

MySQLI and PDO have their own advantages. Keep in mind that MySQLI is only for MySQL databases. Meanwhile, PDO can be used together with other databases such as MariaDB, MongoDB, PostgreSQL and others. PDO can simplify the transition process, so it is very good for use by databases other than MySQL servers.