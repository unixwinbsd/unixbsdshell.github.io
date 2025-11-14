---
title: How to Create Column Tables and Databases in MySql Server and MariaDB
date: "2025-07-21 09:55:21 +0100"
updated: "2025-08-22 10:12:25 +0100"
id: create-coloumn-table-database-mysql-server-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/oct-25/oct-25-119.jpg
toc: true
comments: true
published: true
excerpt: This guide will walk you through the process of creating, modifying, and deleting columns, as well as customizing their settings to suit your needs. We will operate the MariaDB application on a FreeBSD 13.2 server computer. If you haven't installed MariaDB or MySQL, read our previous article about the MariaDB and MySQL installation process.
keywords: database, mariadb, mysql, table, coloumn, freebsd, sql, insert, delete, drop, add, openbsd
---

As we know MariaDB = MySQL Server, or you could say MariaDB is the sibling of MySQL Server. If we run or operate MariaDB it means we are using MySQL. There are only a few differences between MariaDB and MySQL, all the SQL script commands are almost the same.

As you delve deeper into the intricacies of table structures, understanding columns and their functionalities becomes crucial. In DBeaver, columns are fundamental components of tables, which in turn are housed within databases. Before you can create columns, you must first establish a database and a table.

Columns in DBeaver are versatile and customizable. You can create new columns, modify their settings, and even delete them when necessary. Each column in a table has a specific data type, dictating the kind of data it can store. You can also enforce rules on columns such as nullability, unique constraints, check constraints, and default values. These rules are essential to maintain data integrity, accuracy, and reliability in your database.

Beyond these basic operations, you can perform more advanced tasks with columns. You can rename columns, change their data types, adjust permissions, and add comments. All databases may not support some of these operations, so it's essential to be aware of the specific capabilities of your database system.

This guide will walk you through the process of creating, modifying, and deleting columns, as well as customizing their settings to suit your needs. We will operate the MariaDB application on a FreeBSD 13.2 server computer. If you haven't installed MariaDB or MySQL, read our previous article about the MariaDB and MySQL installation process.

<br/>

![skema mariadb database](/img/oct-25/oct-25-119.jpg)

<br/>


### Read Also:
[FreeBSD MariaDB Databases Installation and Configuration](https://unixwinbsd.site/openbsd/create-database-table-and-columns-mysql-mariadb)

[Learn to Install MySQL Server on a FreeBSD Machine](https://unixwinbsd.site/freebsd/learn-install-mysql-server-freebsd)
<br/>

In this article, our FreeBSD system has MariaDB installed and has access to the MariaDB root user. OK, now we will log in to the root user to see the contents of the existing MariaDB database.

```sh
root@ns1:~ # /usr/local/bin/mariadb -u root -p
Enter password: router
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 12
Server version: 10.5.21-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]>
```

View the MariaDB database.

```
root@localhost [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.000 sec)
```

Now we will create a database with the name `"courseMariaDB"`, this database contains all records of students who took the course.

```sh
root@localhost [(none)]> create database kursusMariaDB;
Query OK, 1 row affected (0.000 sec)
```

The above command will create a database `"courseMariaDB"`, now we check whether the database was created successfully, run the show databases command once again.

```
root@localhost [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kursusMariaDB      |
| mysql              |
| performance_schema |
+--------------------+
4 rows in set (0.000 sec)
```

We have successfully created a new database `"courseMariaDB"`, we continue by accessing the database and creating a table in the database `"courseMariaDB"`. To access the database, we will use the USE command. The USE command must be followed by the name of the existing database to avoid errors, once this command is executed.

```
root@localhost [(none)]> use kursusMariaDB;
Database changed
root@localhost [kursusMariaDB]>
```

Now that the database has been successfully modified, notice that the database name is listed between the brackets next to `root@localhost`, indicating the current database.


## 1. Creating Tables

### a. Create a table students

The next step is to create a table with the name `"students"`. The following is a description or contents of the `"students"` table.

| Column Name       | Data Type          | Information        | 
| ----------- | -----------   | ----------- |
| student_id          | int          | No induk siswa          |
| first_name          | Varchar (60)      | nama depan ssiwa          |
| last_name          | Varchar (60)     | nama belakang          |
| address          | Varchar (255)          | alamat          |
| city          | Varchar (45)          | kota          |
| state          | char (2)          | negara          |
| zip_code          | char (5)          | Kode Pos          |

Now let's convert this table structure into executable SQL, to create our table we will use the CREATE command, followed by TABLE and then append it with the table structure. In SQL, column description is done by stating the column name first and then adding the column data type. The students table has multiple columns, and column information must be separated by commas (,).

```
root@localhost [kursusMariaDB]> create table students(student_id int,first_name Varchar(60),last_name Varchar(60),address Varchar(255),city Varchar(40),state char(2),zip_code char(5));
Query OK, 0 rows affected (0.057 sec)

root@localhost [kursusMariaDB]>
```

Now that the query has been executed, the `"students"` table has been created. To verify whether the student table has been successfully created, and to see the list of tables that exist in the current database, we can use the SHOW utility command and append it with TABLES.


```
root@localhost [kursusMariaDB]> show tables;
+-------------------------+
| Tables_in_kursusMariaDB |
+-------------------------+
| students                |
+-------------------------+
1 row in set (0.000 sec)

root@localhost [kursusMariaDB]>
```

We have successfully created the `"students"` table, now let's verify whether our students table has the same table structure as we wanted before. We use the DESCRIBE command followed by the table name to see the table structure:

```
root@localhost [kursusMariaDB]> describe students;
+------------+--------------+------+-----+---------+-------+
| Field      | Type         | Null | Key | Default | Extra |
+------------+--------------+------+-----+---------+-------+
| student_id | int(11)      | YES  |     | NULL    |       |
| first_name | varchar(60)  | YES  |     | NULL    |       |
| last_name  | varchar(60)  | YES  |     | NULL    |       |
| address    | varchar(255) | YES  |     | NULL    |       |
| city       | varchar(40)  | YES  |     | NULL    |       |
| state      | char(2)      | YES  |     | NULL    |       |
| zip_code   | char(5)      | YES  |     | NULL    |       |
+------------+--------------+------+-----+---------+-------+
7 rows in set (0.002 sec)

root@localhost [kursusMariaDB]>
```


### b. Create a course Table

The following is the contents of the `"course"` table structure.


| Column Name       | Data Type          | Information        | 
| ----------- | -----------   | ----------- |
| course_id          | Int          | No induk siswa          |
| name          | Varchar (60)      | nama ssiwa          |
| description          | Varchar (255)     | Deskripsi kursus          |


Now let's convert this table structure into executable SQL to create a course table:

```
root@localhost [kursusMariaDB]> create table kursus(course_id int,name varchar(60),description varchar(255));
Query OK, 0 rows affected (0.064 sec)

root@localhost [kursusMariaDB]>
```

Let's now see if the structure of the `"course"` table is in accordance with the structure we have determined above.

```
root@localhost [kursusMariaDB]> show tables;
+-------------------------+
| Tables_in_kursusMariaDB |
+-------------------------+
| kursus                  |
| students                |
+-------------------------+
2 rows in set (0.000 sec)

root@localhost [kursusMariaDB]> describe kursus;
+-------------+--------------+------+-----+---------+-------+
| Field       | Type         | Null | Key | Default | Extra |
+-------------+--------------+------+-----+---------+-------+
| course_id   | int(11)      | YES  |     | NULL    |       |
| name        | varchar(60)  | YES  |     | NULL    |       |
| description | varchar(255) | YES  |     | NULL    |       |
+-------------+--------------+------+-----+---------+-------+
3 rows in set (0.001 sec)

root@localhost [kursusMariaDB]>
```


### c. Create a students courses table

The next step is to create a `"student course"` table with the following table structure:

| Column Name       | Data Type          | Information        | 
| ----------- | -----------   | ----------- |
| course_id          | int          | No Pendaftaran kursus          |
| student_id           | int      | ID Pelajar/Nomor Induk Siswa          |


```
root@localhost [kursusMariaDB]> create table students_courses(course_id int,student_id int);
Query OK, 0 rows affected (0.066 sec)

root@localhost [kursusMariaDB]>
```

The above command will query has been executed, let's run the SHOW TABLES command to verify whether the table `"student_course"` has been created.

```
root@localhost [kursusMariaDB]> show tables;
+-------------------------+
| Tables_in_kursusMariaDB |
+-------------------------+
| kursus                  |
| students                |
| students_courses        |
+-------------------------+
3 rows in set (0.000 sec)

root@localhost [kursusMariaDB]>
```


## 2. Entering Data into Tables

We have completed the steps for creating the table, now it's time to enter data into the table. Let's look at some different methods for inserting a single row of data and inserting multiple rows of data. To insert data into a table, we will use the INSERT command, and provide the table name and values for the available columns. Let's start by entering student data into the "students" table.

```
root@localhost [kursusMariaDB]> insert into students values( 1,"Asep","Munarman","Gang Delima","Bekasi","BK","17841");
Query OK, 1 row affected (0.016 sec)

root@localhost [kursusMariaDB]>
```

In the example above we insert student data into the "students" table. In the method above, filling in the table uses the VALUES clause. This syntax, although it looks very simple, is not a secure method for entering data. This INSERT statement relies on the column order specified in the table structure, so the data in the VALUES clause will be mapped by position, 1 will go to the first column in the table.

Even though it is intended to be included in the student_id column. If the student table is recreated locally or on a different machine, there is no guarantee that the column order will remain the same. Another approach that is considered safer when compared to this approach is the INSERT statement, where the column names are mentioned explicitly in SQL.


```
root@localhost [kursusMariaDB]> insert into students(student_id,first_name,last_name,address,city,state,zip_code) values( 2,"Asep","Subekti","Gang Mawar","Karawang","KW","17842");
Query OK, 1 row affected (0.016 sec)

root@localhost [kursusMariaDB]>
```



Even though the method above is a little longer, it will guarantee that the data passed through the VALUES clause will go into the right column. By using this INSERT syntax, the order in which the columns are mentioned is no longer important. When this query is executed, MariaDB matches each item in the column list with its respective value in the VALUES list by position.

This syntax can also be used when data is available for only a few columns. Let's create an INSERT statement that has data for some columns and uses NULL for columns that don't have any data.

```
root@localhost [kursusMariaDB]> insert into students(student_id,first_name,last_name,address,city,state,zip_code) values( 3,"Asep","Sarkim","NULL","Subang","SB","17843");
Query OK, 1 row affected (0.021 sec)

root@localhost [kursusMariaDB]>
```

In this example, we are inserting student data whose addresses are unknown, so we use NULL to fill in the column.

Now that we have looked at the different insert syntaxes for inserting a single row of records, let's move forward and see how multiple records can be inserted. There are two ways to insert multiple records into a table, the first method is where an INSERT statement is created for each row, and separated by a statement terminator (;).

```
insert into kursus(
	course_id, name, description
)
values(1, "CS-101",
	"Introduction to Computer Science");
	
insert into kursus(
	course_id, name, description
)
values(2, "CE-101",
	"Introduction to Computer Engineering");
```


Another way to insert multiple records is to use a single VALUES clause while passing multiple records, separating each record with a comma (,), and adding a statement terminator at the end of the last record.

```
insert into students_courses(
	student_id, course_id)
values
	(1,1), -- Student id 1 & Course id 1
	(1,2), -- Student id 1 & Course id 2
	(2,2), -- Student id 2 & Course id 2
	(3,1); -- Student id 3 & Course id 1
```

In the example above, we inserted several records into the `"Students_courses"` table. In executing this SQL query, the first statement inserts an associative record into the student_courses table and the value for the student_id column is 1, which maps back to Asep Munarman's student data, and the value for course_id is 1 which corresponds to the CS-101 course record. Inline comments at the end of each statement are used to describe the data entered through this statement.

Although these comments are added to INSERT statements, they are only intended to explain the purpose of the statements and will not be processed by MariaDB.


## 3. Viewing Table Data Contents

In part 2 above, we learned how to insert or insert data into a table. Now we will learn how to view the contents of table data. There are various mechanisms for viewing the contents of table data, we will use the SELECT command to view the contents of table data.

The SELECT statement will expect a minimum of two things, the first is what to retrieve and the second is where to retrieve it. The following is an example of using the SELECT command to view the contents of table data.

```
root@localhost [kursusMariaDB]> select * from students;
+------------+------------+-----------+-------------+----------+-------+----------+
| student_id | first_name | last_name | address     | city     | state | zip_code |
+------------+------------+-----------+-------------+----------+-------+----------+
|          1 | Asep       | Munarman  | Gang Delima | Bekasi   | BK    | 17841    |
|          2 | Asep       | Subekti   | Gang Mawar  | Karawang | KW    | 17842    |
|          3 | Asep       | Sarkim    | NULL        | Subang   | SB    | 17843    |
+------------+------------+-----------+-------------+----------+-------+----------+
3 rows in set (0.000 sec)

root@localhost [kursusMariaDB]>
```

In this query, we use * to retrieve data for all columns from the `"students"`     table, this is not the preferred data retrieval method. The preferred data retrieval method is to specify each column separated by a comma (,) after the SELECT clause.

```
root@localhost [kursusMariaDB]> select student_id, first_name, last_name from students where last_name="Sarkim";
+------------+------------+-----------+
| student_id | first_name | last_name |
+------------+------------+-----------+
|          3 | Asep       | Sarkim    |
+------------+------------+-----------+
1 row in set (0.000 sec)

root@localhost [kursusMariaDB]>
```

The command above will display student_id, first_name, last_name data from the `"students"` table with the last_name record keyword named "Sarkim". The results of the command above only display data for the student named Asep Sarkim, while the names of other students are not displayed.

Below are some examples that you can practice using commands SELECT.

```
select student_id, first_name, last_name
from students
where last_name="Subekti";

select student_id, first_name, last_name
from students
where student_id>1;

select student_id, first_name, last_name
from students
where student_id<4

select student_id, first_name, last_name
from students
where student_id between 1 and 4;
```

This article is specifically written for those of you who want to learn about the MariaDB database. We hope this article is helpful and beneficial to readers.