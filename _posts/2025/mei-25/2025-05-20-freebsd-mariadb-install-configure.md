---
title: FreeBSD MariaDB - How to Install and Configure
date: "2025-05-20 07:19:19 +0100"
updated: "2025-05-20 07:19:19 +0100"
id: freebsd-mariadb-install-configure
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: MariaDB was first released in late 2009 to forever solidify the MySQL codebase as a free database management system.
keywords: freebsd, mariadb, mysql, database, schema, sql, install, configuration
---
Although MariaDB is a fork of Oracle's MySQL database, the two have diverged so much that they are now very different from each other. Database management systems like MySQL are paid software, while MariaDB is fully GPL licensed. MariaDB also offers significant performance improvements and supports a wide range of storage engines.

## 1. About MariaDB Database?
MariaDB was first released in late 2009 to forever cement the MySQL codebase as a free database management system. It is based on the highly successful MySQL and is developed as an open source resource. Microsoft and WordPress, as well as many other companies, rely on Maria DB and MySQL to run their businesses.

Maria DB has been designed to be interchangeable with MySQL, allowing customers to easily migrate from one platform to another. MariaDB is a great example of the speed of that interchangeability. Forked from MySQL in 2009, MariaDB has grown into one of the top open source databases in use today.

When Oracle acquired MySQL in October 2009, many on the team were concerned about the future of MySQL. MariaDB took off and forked its version of MySQL starting with 5.1. MariaDB is licensed under the GNU General Public License and is intended to remain free and open source. The developer named the project after his second daughter and is intended to be a simple replacement for MySQL and is often featured as a bundled DB for popular Linux distributions such as CentOS. The APIs and protocols used in MySQL are also found in MariaDB.

## 2. Differences between MariaDB and MySQL Server Database

- MariaDB includes 12 new storage engines, while MySQL has fewer. MySQL has a smaller connection pool than MariaDB. So MariaDB is faster than MySQL.
- MySQL replication is slower than MariaDB.
- MariaDB is open source, but MySQL is not and uses proprietary code.
- MySQL supports data hiding and dynamic columns, while MariaDB does not.

The power of MySQL is so great that it can process millions of requests every second at the same time. This fact shows that MySQL serves every user interaction without any problems. Netflix, YouTube, Booking.com, Airbnb, and many other large companies in the world use MySQL to support their very large databases.

MariaDB operates as open source software with a GPL, BSD, or LGPL license. This software supports standard query languages ​​and many high-performance storage engines that can be integrated with other RDMS. It is very important that MariaDB supports PHP. And finally, this software supports Galera cluster technology.

## 3. MariaDB Database Features
MariaDB is backward compatible and open source, making it a cost-effective choice for businesses looking to take advantage of its advanced database management capabilities. As a lightweight version of MySQL, MariaDB has many new features thanks to an active development team of volunteers around the world. MySQL is slower and does not support data hiding and dynamic columns. Access to new commands such as KILL and WITH and JSON compatibility are attractive options for new software developers.

MySQL Enterprise Edition's shortcomings are addressed with plug-ins in MariaDB, and server operating systems such as Linux, Solaris, and Windows are also supported. The code is easy to convert due to its similarity to MySQL's data structures and is written in C++, Bash, and Perl; MariaDB is available to most programmers.

MySQL’s scalability and flexibility, combined with its high performance and strong transaction support, make it the number one database tool. Web capabilities and storage advantages are important components of any development team’s choice, and MySQL is regularly updated and an effective player in many markets.

Multiple users can access large amounts of data and users simultaneously in a highly scalable environment. MySQL is written in C and C++, which have great support and availability for many programmers around the world.

## 4. How to Install MariaDB on FreeBSD
In this article we will use the FreeBSD 13.2 system to install MariaDB. Type the following command to install MariaDB.

```
root@ns1:~ # cd /usr/ports/databases/mariadb106-client
root@ns1:/usr/ports/databases/mariadb105-client # make config
root@ns1:/usr/ports/databases/mariadb105-client # make install clean
```

When using the "make config" command there will be several options that you can choose. In the "GSSAPI Security API" support option, disable the GSSAPI option.

After the MariaDB client installation process is complete, continue by installing the MariaDB server.

```
root@ns1:~ # cd /usr/ports/databases/mariadb106-server
root@ns1:/usr/ports/databases/mariadb106-server # make config
root@ns1:/usr/ports/databases/mariadb106-server # make install clean
```

Just like the client installation process, in the MariaDB server installation, the GSSAPI option must be turned off.

## 5. Create a rc.d script
Like most applications running on FreeBSD, MariaDB also requires the rc.d script to be automatically booted by the FreeBSD system. Creating this file is almost the same as the MySQL Server rc.d script. Type the following command in the /etc/rc.conf file.

```
root@ns1:~ # ee /etc/rc.conf
mysql_enable="YES"
mysql_user="mysql"
mysql_dbdir="/var/db/mysql"
mysql_optfile="/usr/local/etc/mysql/my.cnf"
mysql_rundir="/var/run/mysql"
```

Once the above script is created, run MariaDB. Type the following command to run the MariaDB application.

```
root@ns1:~ # service mysql-server start
Installing MariaDB/MySQL system tables in '/var/db/mysql' ...
OK

To start mariadbd at boot time you have to copy
support-files/mariadb.service to the right place for your system


Two all-privilege accounts were created.
One is root@localhost, it has no password, but you need to
be system 'root' user to connect. Use, for example, sudo mysql
The second is mysql@localhost, it has no password either, but
you need to be the system 'mysql' user to connect.
After connecting you can set the password, if you would need to be
able to connect as any of these users with a password and without sudo

See the MariaDB Knowledgebase at https://mariadb.com/kb

You can start the MariaDB daemon with:
cd '/usr/local' ; /usr/local/bin/mariadb-safe --datadir='/var/db/mysql'

You can test the MariaDB daemon with mysql-test-run.pl
cd '/usr/local/' ; perl mariadb-test-run.pl

Please report any problems at https://mariadb.org/jira

The latest information about MariaDB is available at https://mariadb.org/.

Consider joining MariaDB's strong and vibrant community:
https://mariadb.org/get-involved/

Starting mysql.
```

If it appears as written above, it means MariaDB is running on a FreeBSD system. Now let's try to test it by running MariaDB with the FreeBSD daemon.

```
root@ns1:~ # /usr/local/libexec/mysqld --skip-grant-tables --general-log &
```

After that, we create a root password, here's how to create a MariaDB root password.

```
root@ns1:~ # mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] n
 ... skipping.

You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n] y
New password: router
Re-enter new password: router
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

## 6. Running MariaDB
Once you haven't missed any of the steps above and have configured everything, it's time to run MariaDB. The method is almost the same as MySQL Server. Now let's test whether MariaDB can enter the SQL command line menu or not?

```
root@ns1:~ # /usr/local/bin/mariadb -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 12
Server version: 10.5.21-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]>
```

From the command results above, MariaDB has successfully entered the MySQL database menu. Let's see the contents of the database table.

```
root@localhost [mysql]> show tables;
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| column_stats              |
| columns_priv              |
| db                        |
| event                     |
| func                      |
| general_log               |
| global_priv               |
| gtid_slave_pos            |
| help_category             |
| help_keyword              |
| help_relation             |
| help_topic                |
| index_stats               |
| innodb_index_stats        |
| innodb_table_stats        |
| plugin                    |
| proc                      |
| procs_priv                |
| proxies_priv              |
| roles_mapping             |
| servers                   |
| slow_log                  |
| table_stats               |
| tables_priv               |
| time_zone                 |
| time_zone_leap_second     |
| time_zone_name            |
| time_zone_transition      |
| time_zone_transition_type |
| transaction_registry      |
| user                      |
+---------------------------+
31 rows in set (0.001 sec)
```

After successfully running MariaDB on FreeBSD, now you can use MariaDB to manage databases. The use of MaraDB is not much different from MySql Server, for those who are familiar with MySql Server it will be very easy to use MariaDB. In addition to being almost the same or you could say MariaDB is a sibling of MySQL Server, MariaDB has features that MySQL Server does not have. The following are the superior features of MariaDB.

- Can use InnoDB with instant columnar addition as the default storage engine for MariaDB.
- Parallel and multi-origin replication.
- Can use FOR loops with MariaDB.
- Transparent columns.
- Latest version comes with Galera Cluster.
- Can add sequences.
- Columnar compression is now independent of the storage engine.

## 7. Creating Mariadb Database Users
One of the most important tasks of a database server is to grant access and permissions. MariaDB is a fully compatible open source relational database management system (RDBMS). The MariaDB client makes it easy to add new users and give them different levels of privileges.

If your MariaDB database does not have a database yet, you should create one first. In MariaDB, we can do this easily by typing the following command in your MariaDB client shell.

```
root@ns1:~ # /usr/local/bin/mariadb -u root -p
root@localhost [(none)]> CREATE DATABASE everest;
Query OK, 1 row affected (0.133 sec)
```

Use the following command to view all databases in MariaDB.

```
root@localhost [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| everest            |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.023 sec)
```

If you want to use the Everest database use the following command.

```
root@localhost [(none)]> use everest;
Database changed
```

Once you have successfully created a database, we will continue by creating users who can access the Everest database.

```
root@localhost [everest]> CREATE USER 'jhondoe'@'localhost' IDENTIFIED BY 'router123';
Query OK, 0 rows affected (0.039 sec)
root@localhost [everest]> GRANT ALL PRIVILEGES ON everest.* TO 'jhondoe'@'localhost';
Query OK, 0 rows affected (0.062 sec)
root@localhost [everest]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.013 sec)
```

With the above command, only the jhondoe user can open the Everest database. Meanwhile, other users cannot open the Everest database.

If you want one user to be able to open all databases in MariaDB, use the following command.

```
root@localhost [everest]> CREATE USER 'mary'@'localhost' IDENTIFIED BY 'router123';
Query OK, 0 rows affected (0.039 sec)
root@localhost [everest]> GRANT ALL PRIVILEGES ON *.* TO 'mary'@'localhost';
Query OK, 0 rows affected (0.037 sec)
root@localhost [everest]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.017 sec)
```

"GRANT ALL PRIVILEGES ON *.*" means to provide access to all databases on the MariaDB server.

With the help of this article, you have successfully run a MariaDB server on FreeBSD. You also understand how to create users and grant access to each database. This article is only a part of the MariaDB material, there are still many that have not been discussed, you can read other articles about MariaDB.
