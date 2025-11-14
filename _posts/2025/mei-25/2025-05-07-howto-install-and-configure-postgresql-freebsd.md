---
title: How to Install and Configure PostgreSQL on FreeBSD 14
date: "2025-05-07 07:55:13 +0100"
updated: "2025-05-07 07:55:13 +0100"
id: static-dynamic-ip-address-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/PostgreSQL%20database%20architecture.jpg&commit=94a571767af1f38023fbbfb259e4b9b8c0b87c31
toc: true
comments: true
published: true
excerpt: Understanding IP addresses is basic material if you want to deepen OpenBSD. Understanding IP addresses in OpenBSD includes the process of configuring static and dynamic IPs.
keywords: ip, static, dynamic, address, ip address, openbsd, netstat, hostname, resolv, hosts
---


Postgresql is an open source object relational database system application with active development for over 30 years and has earned a good reputation for reliability, feature robustness, and performance. Postgres is one of the applications that emphasizes extensibility and SQL compliance.

PostgreSQL works based on the Postgres DBMS developed at the University of California, Berkeley. PostgreSQL ORDBMS supports most of the standard SQL features and the most modern technologies such as:
- Complex Queries.
- Foreign keys.
- Triggers.
- Representation.
- Transactions.
- Concurrency control with multiversioning.

PostgreSQL also allows users to add their own data:
- Data types
- Functions
- Operators
- Aggregate functions
- Indexing Methods
- Programming languages

PostgreSQL was originally named POSTGRES, referring to its origins as the successor to the Ingres database. The PostgreSQL program can also be used as a primary data store or data warehouse for many web, mobile, geospatial, and analytical applications. PostgreSQL can store both structured and unstructured data in one product.

In this article we try to install PostgreSQL on a FreeBSD 13.2 server. The version of PostgreSQL used is postgresql15.


![PostgreSQL database architecture](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/PostgreSQL%20database%20architecture.jpg&commit=94a571767af1f38023fbbfb259e4b9b8c0b87c31)

## 1. PostgreSQL Installation Process
On the FreeBSD system, installing PostgreSQL is very easy, the process is almost the same as installing other programs that run on the FreeBSD system. Here is how to install the PostgreSQL client and server.


```console
root@ns1:~ # cd /usr/ports/databases/postgresql15-client
root@ns1:/usr/ports/databases/postgresql15-client # make install clean
root@ns1:~ # cd /usr/ports/databases/postgresql15-server
root@ns1:/usr/ports/databases/postgresql15-server # make install clean
```


## 2. PostgreSQL Configuration Process
After the installation process is complete, to activate PostgreSQL we must edit the `/etc/rc.conf` file. Type the script below in the `/etc/rc.conf` file.


```console
root@ns1:~ # ee /etc/rc.conf
postgresql_enable="YES"
postgresql_class="postgres"
postgresql_data="/var/db/postgres/data15"
postgresql_flags="-w -s -m fast"
postgresql_initdb_flags="--encoding=utf-8 --lc-collate=C"
postgresql_login_class="default"
postgresql_profiles=""
```

After that we continue by editing the `/etc/login.conf` file, and enter the script below.

```console
root@ns1:~ # ee /etc/login.conf
postgres:\
        :lang=en_US.UTF-8:\
        :setenv=LC_COLLATE=C:\
        :tc=default:
```

Then initialize the PostgresQL database. Type the following command to initialize the PostgresQL database.

```console
root@ns1:~ # /usr/local/etc/rc.d/postgresql initdb
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with this locale configuration:
  provider:    libc
  LC_COLLATE:  C
  LC_CTYPE:    C.UTF-8
  LC_MESSAGES: C.UTF-8
  LC_MONETARY: C.UTF-8
  LC_NUMERIC:  C.UTF-8
  LC_TIME:     C.UTF-8
The default text search configuration will be set to "english".

Data page checksums are disabled.

creating directory /var/db/postgres/data15 ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... Asia/Jakarta
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

initdb: warning: enabling "trust" authentication for local connections
initdb: hint: You can change this by editing pg_hba.conf or using the option -A, or --auth-local and --auth-host, the next time you run initdb.

Success. You can now start the database server using:

    /usr/local/bin/pg_ctl -D /var/db/postgres/data15 -l logfile start
```

Once the PostgresQL database is initialized, proceed with the following command, but this command can only be run on the Postgres user, so you must be active on the Postgres user. Follow the steps below.

```console
root@ns1:~ # su postgres
$ cd /var/db/postgres
$ /usr/local/bin/pg_ctl -D /var/db/postgres/data15 -l logfile restart
waiting for server to shut down.... done
server stopped
waiting for server to start.... done
server started
$ exit
root@ns1:~ #
```

The explanation of the script above is, in the first script you log in as a Postgres user, the second script goes to the `/var/db/postgres` folder and the second script restarts the logfile while the last script logs out as a Postgres user.

After logging out of the Postgres user, edit the `/var/db/postgres/data13/postgresql.conf` file, and enter the script below.

```console
root@ns1:~ # ee /var/db/postgres/data15/postgresql.conf
listen_addresses = '192.168.5.2'		# what IP address(es) to listen on;
port = 5432
```

The IP for listen_addresses is adjusted to the FreeBSD server's Private IP, because in writing this article the Private IP used is 192.168.5.2, so listen_addresses = '192.168.5.2' and the PostgreSQL default port is port 5432.

Then we also edit the `/var/db/postgres/data13/pg_hba.conf` file, and replace the host script with the IP address that matches the FreeBSD server, here is an example of the script.

```console
root@ns1:~ # ee /var/db/postgres/data15/pg_hba.conf
host    all             all             192.168.5.2/24            trust
```

Match the IP address with the script above. Then we restart the PostgresQL database program.

```console
root@ns1:~ # service postgresql restart
2023-08-21 13:43:37.306 WIB [1439] LOG:  ending log output to stderr
2023-08-21 13:43:37.306 WIB [1439] HINT:  Future log output will go to log destination "syslog".

root@ns1:~ # service postgresql status
pg_ctl: server is running (PID: 1439)
/usr/local/bin/postgres "-D" "/var/db/postgres/data15"
```

If there is nothing wrong with the script settings above and the PostgresQL database program should be able to run on FreeBSD.

## 3. Creating a Postgres Password
By default, when the postgresql database installation process is complete, postgresql will automatically create a database named "postgres", and the user for the "postgres" database is named `postgres`. The user and database `postgres` have not been given a password. Here's how to give a password to the Postgres user.



```console
root@ns1:~ # passwd postgres
Changing local password for postgres
New Password: router
Retype New Password: router
```

Or you can also create a Postgres password in another way, as in the example below.

```console
root@ns1:~ # su - postgres
$ psql -c "alter user postgres with password 'router'"
ALTER ROLE
$
```

In the above script example we have created a Postgres password with the name "router".

## 4. How to Use the PostgreSQL15 Database
After the Postgres user is given a password, now we try to create a table in the `postgres` database. The following is an example of creating a table in the `postgres` database.

```console
root@ns1:~ # su - postgres
$ psql postgres
psql (15.3)
Type "help" for help.

postgres=# CREATE TABLE person (
    person_id BIGINT,
    name VARCHAR(255),
    age INT,
    city VARCHAR(255)
);
CREATE TABLE
postgres=# INSERT INTO person VALUES (1001, 'M. Jaka Setiawan', 9, 'Tegal');
INSERT 0 1
postgres=# INSERT INTO person VALUES (1002, 'Iwan Setiawan', 42, 'Bekasi');
INSERT 0 1
postgres=# INSERT INTO person VALUES (1003, 'Siti Umaroh', 41, 'Tegal');
INSERT 0 1
postgres=# INSERT INTO person VALUES (1004, 'Kanaka Robih Setiawan', 11, 'Bekasi');
INSERT 0 1
postgres=# select * from person;
 person_id |         name          | age |  city  
-----------+-----------------------+-----+--------
      1001 | M. Jaka Setiawan      |   9 | Tegal
      1002 | Iwan Setiawan         |  42 | Bekasi
      1003 | Siti Umaroh           |  41 | Tegal
      1004 | Kanaka Robih Setiawan |  11 | Bekasi
(4 rows)

postgres=#
```
Now let's try again by creating a database, user, table and password. Let's give an example by creating a database user `puncakanjani` with the name `gunungrinjani`. Follow these steps.

```console
root@ns1:~ # su - postgres
$ createuser gunungrinjani
$ createdb puncakanjani -O gunungrinjani
$ psql puncakanjani
psql (15.3)
Type "help" for help.

puncakanjani=#
```

The explanation of the command above is.

1. The first script "su - postgres" enters the user "postgres"
2. 2nd script, create a user with the name Gunungrinjani
3. 3rd script, creates a Puncakanjani database for the Gunungrinjani user
4. 4th script, psql is entered into the user Gunungrinjani
5. The Puncakanjani script=# means it is active in the Puncakanjani database

The next step is to create a password for the Gunungrinjani user.

```console
puncakanjani=# alter user gunungrinjani with password 'sembalun';
ALTER ROLE
```

The command above is to create a password for the Gunungrinjani user with the password `sembalun`. After the password is successfully created, now we practice how to create a table. Here is an example.

```console
puncakanjani=# create table tabelgunung ( id int,first_name text, last_name text );
CREATE TABLE
puncakanjani=# insert into tabelgunung (id,first_name,last_name) values (1,'gunung','argopuro');
INSERT 0 1
puncakanjani=# insert into tabelgunung (id,first_name,last_name) values (1,'gunung','rinjani');
INSERT 0 1
puncakanjani=# insert into tabelgunung (id,first_name,last_name) values (1,'gunung','raung');
INSERT 0 1
```

Look at the table we have created above.

```console
puncakanjani=# select * from tabelgunung;
 id | first_name | last_name 
----+------------+-----------
  1 | gunung     | argopuro
  1 | gunung     | rinjani
  1 | gunung     | raung
(3 rows)

puncakanjani=#
```

Delete the `tabelgunung`

```console
puncakanjani=# DROP TABLE tabelgunung;
DROP TABLE
```

Delete the `puncakanjani` database.

```console
puncakanjani=# exit
$ dropdb puncakanjani
```

Delete user `gunungrinjani`

```console
$ dropuser gunungrinjani
```

PostgreSQL is a powerful, feature-rich, and widely used relational database management system in a variety of applications. PostgreSQL is an attractive choice for many companies, including giants such as Apple, Netflix, Instagram, IMDB, and others.

According to statistical data, in 2023 PostgreSQL ranked fourth in the world among DBMS in terms of popularity, behind Oracle, MySQL, and Microsoft SQL Server. In addition, PostgreSQL is the most popular open source DBMS.