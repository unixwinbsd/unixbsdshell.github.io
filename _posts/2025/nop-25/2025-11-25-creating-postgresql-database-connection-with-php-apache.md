---
title: Creating a PostgreSQL Database Connection on FreeBSD with PHP and Apache
date: "2025-11-25 08:09:38 +0000"
updated: "2025-11-25 08:09:38 +0000"
id: creating-postgresql-database-connection-with-php-apache
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-032.jpg
toc: true
comments: true
published: true
excerpt: In this tutorial, we'll explain how to connect to a PostgreSQL database server using PHP with the Apache24 Web Server as the frontend. In this case, PHP connects to the PostgreSQL database, and the data stored in PostgreSQL is then displayed in Chrome, Yandex, or Firefox web browsers via Apache24.
keywords: creating, freebsd, postgresql, sql, query, database, php, fpm, apachw, web browser
---

For those interested in web programming, particularly PHP programming, it's no secret that the most common language and DBMS combination is PHP and MySQL. However, sometimes it's necessary to interact with other databases, such as PostgreSQL or MariaDB. PHP supports not only MySQL and PostgreSQL but also many other SQL-based DBMSs.

Once we've learned how to install and configure a PostgreSQL database for various scenarios, having a database and populating it with data becomes useless until we can retrieve and use it in a specific way. Currently, using a mobile-friendly web application is the most common and popular method.

In this tutorial, we'll explain how to connect to a PostgreSQL database server using PHP with the Apache24 Web Server as the frontend. In this case, PHP connects to the PostgreSQL database, and the data stored in PostgreSQL is then displayed in Chrome, Yandex, or Firefox web browsers via Apache24.

## A. System Specifications

- OS: FreeBSD 13.2
- IP Address: 192.168.5.2
- Web Server: Apache24
- phpPgAdmin 7.14.4-mod
- PHP82
- PHP mods and extensions
- PHP-FPM
- PostgreSQL 15.3

<img alt="nextCreating a PostgreSQL Database Connection on FreeBSD with PHP and Apachecloud" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-032.jpg' | absolute_url }}">


## B. Install PHP Dependencies

To connect PostgreSQL via PHP, several PHP modules and extensions are required for the PostgreSQL database to run properly. These dependencies are PHP library files that PostgreSQL uses to communicate with PHP. This article will not cover PHP installation; you can read how to install PHP in the previous article.

The following PHP modules and extensions must be installed on a FreeBSD system to connect a PostgreSQL database to PHP.

```yml
root@ns1:~ # cd /usr/ports/databases/php82-pgsql
root@ns1:/usr/ports/databases/php82-pgsql # make install clean
root@ns1:/usr/ports/databases/php82-pgsql # cd /usr/ports/lang/php82-extensions
root@ns1:/usr/ports/lang/php82-extensions # make install clean
root@ns1:/usr/ports/lang/php82-extensions # cd /usr/ports/www/mod_php82
root@ns1:/usr/ports/www/mod_php82 # make install clean
root@ns1:/usr/ports/www/mod_php82 # cd /usr/ports/www/php82-session
root@ns1:/usr/ports/www/php82-session # make install clean
root@ns1:/usr/ports/www/php82-session # cd /usr/ports/textproc/php82-simplexml
root@ns1:/usr/ports/textproc/php82-simplexml # make install clean
root@ns1:/usr/ports/textproc/php82-simplexml # cd /usr/ports/databases/php82-pdo
root@ns1:/usr/ports/databases/php82-pdo # make install clean
root@ns1:/usr/ports/databases/php82-pdo # cd /usr/ports/databases/php82-mysqli
root@ns1:/usr/ports/databases/php82-mysqli # make install clean
root@ns1:/usr/ports/databases/php82-mysqli # cd /usr/ports/databases/pear-DB
root@ns1:/usr/ports/databases/pear-DB # make install clean
root@ns1:/usr/ports/databases/pear-DB # cd /usr/ports/devel/pear
root@ns1:/usr/ports/devel/pear # make install clean
root@ns1:/usr/ports/devel/pear # cd /usr/ports/databases/php82-pdo_mysql
root@ns1:/usr/ports/databases/php82-pdo_mysql # make install clean
```

After that we continue by installing the pear application.

```console
root@ns1:~ # pear install DB
WARNING: "pear/DB" is deprecated in favor of "pear/MDB2"
downloading DB-1.11.0.tgz ...
Starting to download DB-1.11.0.tgz (132,549 bytes)
.............................done: 132,549 bytes
install ok: channel://pear.php.net/DB-1.11.0
root@ns1:~ # pear install MDB2
downloading MDB2-2.4.1.tgz ...
Starting to download MDB2-2.4.1.tgz (121,557 bytes)
..........................done: 121,557 bytes
install ok: channel://pear.php.net/MDB2-2.4.1
MDB2: Optional feature fbsql available (Frontbase SQL driver for MDB2)
MDB2: Optional feature ibase available (Interbase/Firebird driver for MDB2)
MDB2: Optional feature mysql available (MySQL driver for MDB2)
MDB2: Optional feature mysqli available (MySQLi driver for MDB2)
MDB2: Optional feature mssql available (MS SQL Server driver for MDB2)
MDB2: Optional feature oci8 available (Oracle driver for MDB2)
MDB2: Optional feature pgsql available (PostgreSQL driver for MDB2)
MDB2: Optional feature querysim available (Querysim driver for MDB2)
MDB2: Optional feature sqlite available (SQLite2 driver for MDB2)
MDB2: To install optional features use "pear install pear/MDB2#featurename"
```

If all the above dependencies are installed, we can test by opening the Google Chrome web browser and typing `192.168.5.2/info.php`. Ensure that the PHP info and specifications appear. This is to verify that PHP and the Apache24 web browser are connected.

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

## C. PHP and PostgreSQL Configuration

PHP supports the PostgreSQL database. The pg_connect function is used to connect to the PostgreSQL database server. Once the connection is established, SQL commands can be executed using the pg_query function. pg_connect has two main functions for operating with the PostgreSQL database server.

### c.1. Opening a PostgreSQL Connection
- pg_connect("host={hostname} 
- port={PostgreSQL port} 
- dbname={PostgreSQL databasename} 
- user={PostgreSQL username} 
- password={PostgreSQL password}");

### c.2. Closing a PostgreSQL Connection

**pg_close(connection_name);**

Here are the basic PHP functions for working with PostgreSQL:

- **pg_connect:** Opens a connection to the database, returns a connection pointer.
- **pg_query:** Executes a query to the database, returns the query results.
- **pg_fetch_assoc:** Converts the query results to an associative array.
- **pg_close:** Closes the connection to the database.

Now that we understand the pg_connect function, we'll try connecting to a PostgreSQL database. Create a con.php file located in the `/usr/local/www/apache24/data` folder. In the con.php file, insert the script below. We recommend that you also read the previous article.

```console
root@ns1:~ # ee /usr/local/www/apache24/data/con.php
<?php
$dbconn = pg_connect("host=192.168.5.2 port=5432 dbname=postgres user=postgres password=router");
//connect to a database named "postgres" on the host "host" with a username and password
if (!$dbconn){
echo "<center><h1>Doesn't work =(</h1></center>";
}else
 echo "<center><h1>OK, Koneksi adalah Good connection</h1></center>";
pg_close($dbconn);
?>
```

To test, open the Yandex or Chrome web browser and type `"192.168.5.2/con.php"` in the browser's address bar.

Another example is taken from the article ["Using phpPgAdmin on FreeBSD with Apache24 Web Server"](https://unixwinbsd.site/freebsd/using-phppgadmin-on-freebsd-with-apache24-web-server/).

```console
root@ns1:~ # ee /usr/local/www/apache24/data/gunungrinjani.php
<?php
$dbconn = pg_connect("host=192.168.5.2 port=5432 dbname=puncakanjani user=gunungrinjani password=sembalun");
//connect to a database named "postgres" on the host "host" with a username and password
if (!$dbconn){
echo "<center><h1>Doesn't work =(</h1></center>";
}else
 echo "<center><h1>OK, Koneksi adalah Good connection</h1></center>";
pg_close($dbconn);
?>
```

After that, reopen your Google Chrome browser and view the results.

Continuing the example from the article ["Using phpPgAdmin on FreeBSD with the Apache24 Web Server"](https://unixwinbsd.site/freebsd/using-phppgadmin-on-freebsd-with-apache24-web-server/), we'll now create a file named `"/usr/local/www/apache24/data/person.php"`, then insert the script below into it.

```console
root@ns1:~ # ee /usr/local/www/apache24/data/person.php
<?php
$conn = pg_connect("host=192.168.5.2 port=5432 dbname=postgres user=postgres password=router");
if (!$conn) {
 echo "An error occurred.\n";
 exit;
}
$result = pg_query($conn, "SELECT * FROM person");
if (!$result) {
 echo "An error occurred.\n";
 exit;
}
while ($row = pg_fetch_row($result)) {
 echo "value1: $row[0]  value2: $row[1] value3: $row[2] value4: $row[3]";
 echo "<br />\n";
}
?>
```

Let's see the results by opening Yandex Browser or Google Chrome, and in the address bar, type `"http://192.168.5.2/person.php"`.

## D. Establishing a PHP and PostgreSQL Connection with PDO

In part 3, we learned how to connect a PostgreSQL database with PHP via `pg_connect`. There's another PostgreSQL database connection technique besides pg_connect, namely using PHP PDO. The main requirement for connecting with PDO is that you have properly installed all the dependencies mentioned above, especially the php82-pdo dependency.

Below, we'll provide an example of how to connect to a PostgreSQL database using PHP PDO. The first step is to create a file `/usr/local/www/apache24/data/config.php` and insert the script below. For reference, we'll still use the article "Using phpPgAdmin on FreeBSD with Apache24 Web Server".

```console
root@ns1:~ # ee /usr/local/www/apache24/data/config.php
<?php
$host= '192.168.5.2';
$db = 'postgres';
$user = 'postgres';
$password = 'router'; // change to your password
?>
```

After that, we create another file `/usr/local/www/apache24/data/pdocon.php`, and enter the script below.

```console
root@ns1:~ # ee /usr/local/www/apache24/data/pdoperson.php
<?php
require_once 'config.php';

try {
	$dsn = "pgsql:host=$host;port=5432;dbname=$db;";
	// make a database connection
	$pdo = new PDO($dsn, $user, $password, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

	if ($pdo) {
		echo "Selamat! Koneksi Ke Database $db Sukses.";
	}
} catch (PDOException $e) {
	die($e->getMessage());
} finally {
	if ($pdo) {
		$pdo = null;
	}
}
?>
```

To see the results, type `"http://192.168.5.2/pdoperson.php`" in the Yandex web browser or Google Chrome.

This tutorial covers how to connect PHP to PostgreSQL using pg_connect and the PDO driver. In the previous tutorial, we learned how to connect to a PostgreSQL database via PHP, allowing Apache24 to display PostgreSQL data in a web browser.
