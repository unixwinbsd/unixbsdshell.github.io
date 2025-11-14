---
title: How to Create Database Tables and Columns in MySql and MariaDB
date: "2025-10-12 13:31:09 +0100"
updated: "2025-10-12 13:31:09 +0100"
id: create-database-table-and-columns-mysql-mariadb
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DataBase
background: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIJI6AEf1gX4ILtEXLymS1rfj6t4MaJPXkfw&s
toc: true
comments: true
published: true
excerpt: In part 1 we have gone through various data retrieval techniques, let's see how data can be represented in a more organized way. When we run a SELECT statement, the data is retrieved in the order in which they exist in the database. This is the order in which the data is stored; therefore, it is not a good idea to rely on MariaDB's default sorting
keywords: database, create, table, columns, mysql, server, mariadb, sql, command
---


## 1. Sorting Data With order by

In part 1 we have gone through various data retrieval techniques, let's see how data can be represented in a more organized way. When we run a SELECT statement, the data is retrieved in the order in which they exist in the database.

This is the order in which the data is stored therefore, it is not a good idea to rely on MariaDB's default sorting. MariaDB provides an explicit mechanism for sorting data; we can use the ORDER BY clause with the SELECT statement and order the data as required. To understand how sorting can help, let's start displaying the "students" table and take only the first_name column.


```
root@localhost [kursusMariaDB]> select first_name from students;
+------------+
| first_name |
+------------+
| Asep       |
| Asep       |
| Asep       |
+------------+
3 rows in set (0.000 sec)
```

In the first example, we are using MariaDB's default sorting, and this will give us the data returned based on insertion order.


```
root@localhost [kursusMariaDB]> select first_name from students order by first_name;
+------------+
| first_name |
+------------+
| Asep       |
| Asep       |
| Asep       |
+------------+
3 rows in set (0.000 sec)
```

In the example above, we sort the data based on the first_name column. The ORDER BY clause by default sorts data in ascending order, so the data will be sorted in ascending alphabetical order and if the first character of one or more strings is the same, then the data is sorted based on the second character. To explicitly mention the sort order in ascending order, we can use the asc keyword after the column name.


```
root@localhost [kursusMariaDB]> select first_name from students
    -> order by first_name desc;
+------------+
| first_name |
+------------+
| Asep       |
| Asep       |
| Asep       |
+------------+
3 rows in set (0.000 sec)
```

In the example above, we again sort the data based on the first_name column and the ORDER BY clause has been completed with desc. We set the sorting direction to descending which indicates that the data has been sorted in descending order. Below are other commands for sorting data.


```
root@localhost [kursusMariaDB]> select student_id, first_name from students
    -> order by student_id, first_name;
+------------+------------+
| student_id | first_name |
+------------+------------+
|          1 | Asep       |
|          2 | Asep       |
|          3 | Asep       |
+------------+------------+
3 rows in set (0.000 sec)
```


## 2. Filtering Data with where

Until this discussion, we have learned how to retrieve data where all the data in the "students" table is retrieved, but we rarely need all of that data. We have used LIMIT and OFFSET clauses which allow us to limit the amount of data retrieved. Now let's use MariaDB filtering mechanism to retrieve data by providing search criteria. To perform a search in a SQL statement, we will use the WHERE clause. The WHERE clause can be used with SELECT statements, or can even be used with UPDATE and DELETE statements, which will be discussed in the next section.


```
root@localhost [kursusMariaDB]> select student_id, first_name, last_name from students where last_name="Sarkim";
+------------+------------+-----------+
| student_id | first_name | last_name |
+------------+------------+-----------+
|          3 | Asep       | Sarkim    |
+------------+------------+-----------+
1 row in set (0.000 sec)
```

The example above explains, selecting the "students" table whose last name is Sarkim.


```
root@localhost [kursusMariaDB]> select student_id, first_name, last_name
    -> from students
    -> where student_id=1;
+------------+------------+-----------+
| student_id | first_name | last_name |
+------------+------------+-----------+
|          1 | Asep       | Munarman  |
+------------+------------+-----------+
1 row in set (0.000 sec)
```

In the example above, we select the "students" table whose student_id is 1 or equal to 1.


```
root@localhost [kursusMariaDB]> select student_id, first_name, last_name from students where student_id>1;
+------------+------------+-----------+
| student_id | first_name | last_name |
+------------+------------+-----------+
|          2 | Asep       | Subekti   |
|          3 | Asep       | Sarkim    |
+------------+------------+-----------+
2 rows in set (0.000 sec)
```

The command above will display the contents of the "students" table with student_id, first_name, last_name where student_id is greater than 1.

```
root@localhost [kursusMariaDB]> select student_id, first_name, last_name
    -> from students
    -> where student_id<4;
+------------+------------+-----------+
| student_id | first_name | last_name |
+------------+------------+-----------+
|          1 | Asep       | Munarman  |
|          2 | Asep       | Subekti   |
|          3 | Asep       | Sarkim    |
+------------+------------+-----------+
3 rows in set (0.000 sec)
```

The command above will display the contents of the "students" table with student_id, first_name, last_name where student_id is less than 4.

```
root@localhost [kursusMariaDB]> select student_id, first_name, last_name
    -> from students
    -> where student_id between 1 and 4;
+------------+------------+-----------+
| student_id | first_name | last_name |
+------------+------------+-----------+
|          1 | Asep       | Munarman  |
|          2 | Asep       | Subekti   |
|          3 | Asep       | Sarkim    |
+------------+------------+-----------+
3 rows in set (0.000 sec)
```

The example above will display the contents of the "students" table with student_id, first_name, last_name where the student_id is between 1 and 4.


## 3. Updating Data

In this section we will learn how to update data or add data, after data is added to the table, there will be several cases where the data must be updated, such as typos when adding student names, or if the student's address changes and so on. We will use the UPDATE statement to change the data. The UPDATE statement requires a minimum of three details, the first is the name of the table where this operation will be performed, the second is the name of the column, and the third is the value that must be assigned to that column.

We can also use the UPDATE statement to change more than one column at a time. There are two cases where the UPDATE statement can be used. The first case is that all records in the table will be updated, and this must be done very carefully as it may lead to loss of existing data. The second scenario when using an UPDATE statement combined with a WHERE clause. By using the WHERE clause, we target a very specific dataset based on the filter criteria.

Before we update the data, we first look at the contents of the "students" table.


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
```

Pay close attention to the contents of the "Students" table, then we will update Citi Subang with Cirebon.

```
root@localhost [kursusMariaDB]> update students  set city="Cirebon" where student_id=3;
Query OK, 1 row affected (0.043 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

The command above will change the city of Subang to Cirebon, let's see the results.

```
root@localhost [kursusMariaDB]> select * from students;
+------------+------------+-----------+-------------+----------+-------+----------+
| student_id | first_name | last_name | address     | city     | state | zip_code |
+------------+------------+-----------+-------------+----------+-------+----------+
|          1 | Asep       | Munarman  | Gang Delima | Bekasi   | BK    | 17841    |
|          2 | Asep       | Subekti   | Gang Mawar  | Karawang | KW    | 17842    |
|          3 | Asep       | Sarkim    | NULL        | Cirebon  | SB    | 17843    |
+------------+------------+-----------+-------------+----------+-------+----------+
3 rows in set (0.000 sec)
```


## 4. Combining Data

The SQL JOIN command is a virtual entity and is executed at run time, during the execution of the SQL statement. Similar to other SQL statements, the data will only be available during query execution and is not implicitly saved to disk. SQL JOIN can be combined with a SELECT statement to retrieve data from multiple tables. Let's look at the most common JOIN: INNER JOIN, a join that is based on equality comparisons in join predicates.

Let's practice some examples that perform SQL INNER JOIN between two or more tables.

```
root@localhost [kursusMariaDB]> select students.first_name,  students.last_name,  students_courses.course_id  from students  inner join  students_courses on  students.student_id
= students_courses.student_id;
+------------+-----------+-----------+
| first_name | last_name | course_id |
+------------+-----------+-----------+
| Asep       | Munarman  |         1 |
| Asep       | Munarman  |         2 |
| Asep       | Subekti   |         2 |
| Asep       | Sarkim    |         1 |
+------------+-----------+-----------+
4 rows in set (0.000 sec)
```


## 5. How to Delete Data

We can use the DELETE statement to delete data. The DELETE statement at a minimum expects a table name. Similar to the UPDATE statement, it is recommended that the DELETE statement always be used with filter criteria to avoid data loss.

Before we carry out the delete command, we first look at the entire contents of the "students" table


```
root@localhost [kursusMariaDB]> select * from students;
+------------+------------+-----------+-------------+----------+-------+----------+
| student_id | first_name | last_name | address     | city     | state | zip_code |
+------------+------------+-----------+-------------+----------+-------+----------+
|          1 | Asep       | Munarman  | Gang Delima | Bekasi   | BK    | 17841    |
|          2 | Asep       | Subekti   | Gang Mawar  | Karawang | KW    | 17842    |
|          3 | Asep       | Sarkim    | NULL        | Cirebon  | SB    | 17843    |
+------------+------------+-----------+-------------+----------+-------+----------+
3 rows in set (0.000 sec)
```

Now we will delete the third row of students with the name Asep Sarkim, here are the commands.

```
root@localhost [kursusMariaDB]> delete from students where student_id=3;
Query OK, 1 row affected (0.017 sec)
```

Let's see the results of the delete command above.

```
root@localhost [kursusMariaDB]> select * from students;
+------------+------------+-----------+-------------+----------+-------+----------+
| student_id | first_name | last_name | address     | city     | state | zip_code |
+------------+------------+-----------+-------------+----------+-------+----------+
|          1 | Asep       | Munarman  | Gang Delima | Bekasi   | BK    | 17841    |
|          2 | Asep       | Subekti   | Gang Mawar  | Karawang | KW    | 17842    |
+------------+------------+-----------+-------------+----------+-------+----------+
2 rows in set (0.000 sec)
```

In this article, we have discussed the basics of a relational database management system with MariaDB. We have learned how to create a data base, table, enter data, update data and delete data/tables. SQL commands with MariaDB will be very useful for those of us who want to build a blogspot or web site that uses a database with SQL commands.