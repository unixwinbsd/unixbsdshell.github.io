---
title: Creating a Database Website with Apache24 PHP and PostgreSQL On FreeBSD
date: "2025-06-03 08:01:11 +0100"
updated: "2025-06-03 08:01:11 +0100"
id: database-website-apache-php-postgresql
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: PHP is a widely used server-side scripting language. Its extensive capabilities and ease of use make PHP ideal for front-end web development, and while it allows us to create advanced structures, its basic usage is also easy to learn, making it a good starting point for beginners.
keywords: apache, website, pgadmin, phpmyadmin, php, postgresql, database, freebsd, install, configuration, php
---

PHP is a widely used server-side scripting language. Its extensive capabilities and ease of use make PHP ideal for front-end web development, and while it allows us to create advanced structures, its basic usage is also easy to learn, making it a good starting point for beginners.

However, the data that is recorded, processed, sent, or displayed by the applications we create needs to be stored somewhere; our web pages have no state without this data. We can store our data in a variety of ways or even throw it away after use, but the most standard way is to store it in a database that is designed solely for storing data securely and serving it up when needed as quickly as possible.

PostgreSQL, also known as Postgres, is a free and open source relational database management system that emphasizes extensibility and SQL compliance. It was originally called POSTGRES, referring to its origins as the successor to the Ingres database developed at the University of California.

In this article, we will learn how to create a simple web page to record and display user data. We will use PostgreSQL DBMS as the backend and develop a PHP application that will run on the Apache web server.

Thus, we can access our web application from any common browser to view or add to our user database. The nature of web applications is that many users/operators can work on them simultaneously, all they need is a browser and network access to our application.

In order for the PostgreSQL database to be connected to PHP and modified through the website page, your computer must have the following specifications installed.

## 1. System specifications
- OS: FreeBSD 13.2
- Hostname/Domain: ns1@unixexplore.com
- IP Address: 192.168.5.2
- phpPgAdmin 7.14.4-mod
- Apache24
- PHP82
- PHP modules and extensions
- PHP-FPM
- PostgreSQL 15.3

Before we continue to part 2, it's a good idea to read the previous article: [How to Install and Configure PostgreSQL on FreeBSD 14](https://unixwinbsd.site/en/freebsd/2025/05/07/howto-install-and-configure-postgresql-freebsd/). Because if PostgresQL is not connected to PHP, don't expect your website application to run perfectly.


## 2. Create a New Table
The first step in creating this simple web application is to create a new table in the PostgresQL database. Here's how to create it.



```console
root@ns1:~ # su - postgres
$ psql postgres
psql (15.4, server 15.3)
Type "help" for help.

postgres=# CREATE TABLE public.user
(
   id serial, 
   name character varying(250), 
   email character varying(250), 
   password character varying(250), 
   mobno bigint, 
   CONSTRAINT id PRIMARY KEY (id)
) 
WITH (
OIDS=FALSE
);
CREATE TABLE
postgres=#
```
The description of the script above is to open a database named `postgres` and create a new table named `user`. The contents of the `user` table consist of name, email, password, and mobile number. The following is the contents of the `user` table.

```sql
postgres=# SELECT * FROM "public"."user";
 id | name | email | password | mobno 
----+------+-------+----------+-------
(0 rows)
postgres=#
```
In this case example, to input or enter data into the `user` table we will do it through Google Chrome, Yandex or other web browsers. So that the Google Chrome web browser can function to input data into the `user` table, we will create a php script named `register.php` and `login.php`. We will place these two files in the `/usr/local/www/apache24/data` folder.


Here are the scripts you should type in the files `/usr/local/www/apache24/data/register.php` and `/usr/local/www/apache24/data/login.php`.

```console
root@ns1:~ # ee /usr/local/www/apache24/data/register.php
<?php
$host = "192.168.5.2";
$port = "5432";
$dbname = "postgres";
$user = "postgres";
$password = "router"; 
$connection_string = "host={$host} port={$port} dbname={$dbname} user={$user} password={$password} ";
$dbconn = pg_connect($connection_string);
if(isset($_POST['submit'])&&!empty($_POST['submit'])){
    
      $sql = "insert into public.user(name,email,password,mobno)values('".$_POST['name']."','".$_POST['email']."','".md5($_POST['pwd'])."','".$_POST['mobno']."')";
    $ret = pg_query($dbconn, $sql);
    if($ret){
        
            echo "Data saved Successfully";
    }else{
        
            echo "Soething Went Wrong";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>PHP PostgreSQL Registration & Login Example </title>
  <meta name="keywords" content="PHP,PostgreSQL,Insert,Login">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
  <h2>Register Here </h2>
  <form method="post">
  
    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" class="form-control" id="name" placeholder="Enter name" name="name" requuired>
    </div>
    
    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" class="form-control" id="email" placeholder="Enter email" name="email">
    </div>
    
    <div class="form-group">
      <label for="pwd">Mobile No:</label>
      <input type="number" class="form-control" maxlength="10" id="mobileno" placeholder="Enter Mobile Number" name="mobno">
    </div>
    
    <div class="form-group">
      <label for="pwd">Password:</label>
      <input type="password" class="form-control" id="pwd" placeholder="Enter password" name="pwd">
    </div>
     
    <input type="submit" name="submit" class="btn btn-primary" value="Submit">
  </form>
</div>
</body>
</html>
```

<br/>

```php
root@ns1:~ # ee /usr/local/www/apache24/data/login.php
<?php
$host = "192.168.5.2";
$port = "5432";
$dbname = "postgres";
$user = "postgres";
$password = "router"; 
$connection_string = "host={$host} port={$port} dbname={$dbname} user={$user} password={$password} ";
$dbconn = pg_connect($connection_string);
if(isset($_POST['submit'])&&!empty($_POST['submit'])){
    
    $hashpassword = md5($_POST['pwd']);
    $sql ="select *from public.user where email = '".pg_escape_string($_POST['email'])."' and password ='".$hashpassword."'";
    $data = pg_query($dbconn,$sql); 
    $login_check = pg_num_rows($data);
    if($login_check > 0){ 
        
        echo "Login Successfully";    
    }else{
        
        echo "Invalid Details";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>PHP PostgreSQL Registration & Login Example </title>
  <meta name="keywords" content="PHP,PostgreSQL,Insert,Login">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
  <h2>Login Here </h2>
  <form method="post">
  
     
    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" class="form-control" id="email" placeholder="Enter email" name="email">
    </div>
    
     
    <div class="form-group">
      <label for="pwd">Password:</label>
      <input type="password" class="form-control" id="pwd" placeholder="Enter password" name="pwd">
    </div>
     
    <input type="submit" name="submit" class="btn btn-primary" value="Submit">
  </form>
</div>
</body>
</html>
```

Now we open the Google Chrome, Firefox or Yandex web browser to fill or input the `user` table. In the Firefox web browser address bar menu, type **http://192.168.5.2/register.php** and fill in the data on the web browser.

After completing the data entry as above, click the `Submit` button

Note on the left side of the Firefox web browser, there is a text `Data saved successful`, meaning the data has been successfully saved. Do the steps above for 3 or 5 names. You can see the results as follows.

```sql
postgres=# SELECT * FROM "public"."user";
 id |     name      |        email        |             password             |    mobno    
----+---------------+---------------------+----------------------------------+-------------
  1 | iwan setiawan | datainchi@gmail.com | f82d7f6c2ab22a228da7c99dde71869c | 81289065249
  2 | M. Jaka       | inchi@gmail.com     | f82d7f6c2ab22a228da7c99dde71869c | 81289065241
  3 | Kanaka Robih  | data@gmail.com      | f82d7f6c2ab22a228da7c99dde71869c | 81289056247
(3 rows)

postgres=#
```

The password displayed above is not the actual password. The original password is not displayed. Because for the 3 names, we created the passwords **"router1", "router2", and "router3"**. Now we try to log in to the 3 names. In Firefox or Google Chrome type **192.168.5.2/login.php**.

In this display, we try to log in with `datainchi@gmail.com` or the user name `iwan setiawan` with the password `router1`, if the login data matches the data entered in the input data file `register.php`, then the words **Login Successful** will appear

This article is just a few examples of using the PostgreSQL database with PHP. You can read other articles about creating web applications based on PostgreSQL and PHP, because PostgreSQL is the best database that is no less popular than the MySQL server.