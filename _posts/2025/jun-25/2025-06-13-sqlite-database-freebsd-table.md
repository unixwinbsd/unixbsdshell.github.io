---
title: Implementing SQLITE on FreeBSD - Creating a Database with SQLite3
date: "2025-06-13 07:21:23 +0100"
updated: "2025-06-13 07:21:23 +0100"
id: sqlite-database-freebsd-table
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Even though by default SQLite is embedded in FreeBSD, there's no harm in reinstalling it. Because with this reinstallation it is hoped that all SQLite features can be used optimally. Below is how to install SQLite on a FreeBSD system
keywords: sqlite, freebsd, database, table, create, sql, query, sqlite3
---

SQLite is a free, open source, cross-platform database management system. SQLite is very popular because of its efficiency and ability to interact with many different programming languages.

Some of the features of SQLite that make it so popular with many people:
- Transactional relational database engines are designed to be embedded into a variety of applications.
- Cross-platform database, such as Web sites, mobile phones, desktop applications and others.
- No configuration.
- Fast, Small and very reliable.
- Can be run on almost all operating systems, such as Linux, BSD, macOS and Windows.
- SQLite is serverless because it does not require a distinct server process or system to operate.
- SQLite facilitates you to work on multiple databases in the same session simultaneously, thus making it flexible.

Apart from being easy to use, SQLite also has many features compared to other relational databases. Many large MNCs such as Adobe, use SQLite as the application file format for their Photoshop Lightroom product. Airbus, a European multinational aerospace company, uses SQLite in its aviation software for the A350 XWB family of aircraft.

On almost all UNIX-based operating systems, by default SQLite is embedded in the operating system. This is because SQLite is an in-memory open source library with zero configuration and does not require any installation. Moreover, it is very convenient because its size is less than 500kb, which is much smaller than other database management systems.

Typically, RDBMS such as MySQL, PostgreSQL and others require a separate server process to operate. Applications that want to access a database server use the TCP/IP protocol to send and receive requests. This is called client/server architecture. SQLite does not work this way and SQLite does not require a server to run. In this article we will try to learn SQLite on the FreeBSD system.

Even though by default SQLite is embedded in FreeBSD, there's no harm in reinstalling it. Because with this reinstallation it is hoped that all SQLite features can be used optimally. Below is how to install SQLite on a FreeBSD system.


```console
root@ns1:~ # pkg install sqlite3
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking integrity... done (0 conflicting)
The following 1 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
	sqlite3: 3.42.0,1

Number of packages to be installed: 1

The process will require 6 MiB more space.

Proceed with this action? [y/N]: y
[1/1] Installing sqlite3-3.42.0,1...
[1/1] Extracting sqlite3-3.42.0,1: 100%
```


## 🏷️ 1. Creating a Database with SQLite

Before we create a database with SQLite3, first check the SQLite version.

```console
root@ns1:~ # sqlite3 --version
3.42.0 2023-05-16 12:36:15 831d0fb2836b71c9bc51067c49fee4b8f18047814f2ff22d817d25195cf3alt1
```

To create a database with SQLite3, type the following script in the sehll command menu.

```console
root@ns1:~ # sqlite3 freebsddatabase.db
SQLite version 3.42.0 2023-05-16 12:36:15
Enter ".help" for usage hints.
sqlite> .databases
main: /root/freebsddatabase.db r/w
```

With the script above the database file **"freebsddatabase.db"** will be placed in the `/root` folder. Why? because when creating the database file **"freebsddatabase.db"**, we were active in the `/root` folder. The script below will create a database with **"freebsddatabase.db"** and will be placed in the `/usr/local/etc` folder.

```console
root@ns1:~ # sqlite3 /usr/local/etc/freebsddatabase.db
SQLite version 3.42.0 2023-05-16 12:36:15
Enter ".help" for usage hints.
sqlite> .databases
main: /usr/local/etc/freebsddatabase.db r/w
```

The `.databases` script in creating the database above is used so that the database that has been created must be verified to be included in the SQLite database list.


## 🏷️ 2. Creating Tables with SQLite

Once you understand how to create a database, we continue by creating a table with SQLite. The way to create a table with SQLite is almost the same as similar programs that use the SQL language such as MySQL, MongoDB, RockDB and others. The following is a script to create a table that we will insert into the `freebsddatabase.db` database.

```console
root@ns1:~ # sqlite3 freebsddatabase.db
SQLite version 3.42.0 2023-05-16 12:36:15
Enter ".help" for usage hints.
sqlite> CREATE TABLE student(id integer NOT NULL, name text NOT NULL, persontype text NOT NULL, length integer NOT NULL);
sqlite> CREATE TABLE Jurusan(Id INTEGER  NOT NULL PRIMARY KEY, Name NVARCHAR(50)  NOT NULL);
sqlite>
```

The script above creates a database "freebsddatabase.db" which contains the "student" table and the "major" table. To see the table that we have created use the ".tables" command.

```sql
sqlite> .tables
student
sqlite>
```



## 🏷️ 3. Entering Data in Tables

To input or enter data in a table, type the following script.

```sql
sqlite> INSERT INTO student VALUES (1, 'Shikha', 'Patel', 100);
sqlite> INSERT INTO student VALUES (2, 'Richa', 'Maheta', 101);
sqlite> INSERT INTO student VALUES (3, 'Meena', 'Jethva', 102);
sqlite>
```

The script above is used to enter data in the "student" table. Meanwhile, to see the contents of the "student" table that we have entered above, type the following script.

```sql
sqlite> SELECT * FROM student;
1|Shikha|Patel|100
2|Richa|Maheta|101
3|Meena|Jethva|102
```

To view data by ID, use the following command:

```sql
sqlite> SELECT * FROM student WHERE id IS 2;
2|Richa|Maheta|101
```

In this tutorial we have learned how to create a database with SQLite3. Hopefully this article can help you understand how to use SQLite3, because SQLite is a great database application and if we learn to understand it, it will really help our work. Installing it is very easy and gives us a lot of convenience in operating it. Additionally, SQLite Browser makes workflows easier, simpler and faster.