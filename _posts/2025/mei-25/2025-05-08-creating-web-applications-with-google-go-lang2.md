---
title: Creating Web Applications with Google Go Lang Part 2
date: "2025-05-08 10:55:21 +0100"
updated: "2025-05-08 10:55:21 +0100"
id: creating-web-applications-with-google-go-lang2
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/12FreeBSD%20Crud%20MysQL.jpg&commit=02479a77f4b2e77d0d98e6dc1b4cde4ce4ad5b27
toc: true
comments: true
published: true
excerpt: Go or Go lang is a popular programming language widely used in industry to create various applications, including web servers, blogs, networking tools and system utilities. Go is known for its simplicity, efficiency, and concurrency support
keywords: go, golang, google, web application, app, web app, script, freebsd, creating
---

Building a Restful application is one of the popular ways to build a web blog because it follows a simple and scalable architecture. With CRUD, users can easily process MySQL databases. CRUD, which stands for Create, Read, Update, and Delete, is a common utility in software development. The ability to perform CRUD operations is fundamental to any application development. In this article, we will learn how to build a simple CRUD application using Go Lang and MySQL server as its database.

Go Lang is a popular programming language known for its efficiency, simplicity, and stability, while MySQL is a relational database management system (RDBMS) developed by Oracle based on the structured query language (SQL).

MySQL is one of the most popular database technologies in the modern big data ecosystem, and is now widely and effectively used, regardless of industry, it is clear that anyone involved with enterprise data or IT should have at least a basic understanding of MySQL.

With MySQL, even those who are new to relational database systems can immediately build easy, fast, and secure data storage systems. Data in MySQL is organized according to the relational model. In this model, tables consist of rows and columns, and the relationships between data elements all follow a strict logical structure. Often people who are new to Golang do not know how to store data in MySQL because there are not many online resources. This article will help you understand the concept of Golang with MySQL.


## 1. Specifications of the System Used
- OS: FreeBSD 14.
- IP Address: 192.168.5.2.
- Go version: go-1.19.
- MySql Server.
- Hostname: ns7.

## 2. Create a Golang project
The first step is to create a working directory to set up the development environment and start a Golang project. Follow the steps below to set up a new Golang project.

```console
root@ns7:~ # cd /var
root@ns7:/var # mkdir -p FreeBSD-Golang-MySQL
root@ns7:/var # cd FreeBSD-Golang-MySQL
root@ns7:/var/FreeBSD-Golang-MySQL #
```
Once you have finished creating the Go language directory, create a new file named `"main.go"`.

```console
root@ns7:/var/FreeBSD-Golang-MySQL # touch main.go
root@ns7:/var/FreeBSD-Golang-MySQL # chmod +x main.go
```
In the file `"/root/var/FreeBSD-Golang-MySQL/main.go"`, you enter the script below.

```php
package main

import (
	"database/sql"
	"html/template"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

// Employee Struct
type Employee struct {
	ID   int
	Name string
	City string
}

// Open Connection with MySQL Driver
func dbConnect() (db *sql.DB) {
	dbDriver := "mysql"
	dbUser := "jhondoe"
	dbPass := "router"
	dbName := "goblog"
	db, err := sql.Open(dbDriver, dbUser+":"+dbPass+"@/"+dbName)
	if err != nil {
		panic(err.Error())
	}
	return db
}

// Read All Templates on folder template
var tmpl = template.Must(template.ParseGlob("template/*"))

// Index Page
func Index(w http.ResponseWriter, r *http.Request) {
	db := dbConnect()
	rows, err := db.Query("SELECT * FROM Employee ORDER BY id DESC")
	if err != nil {
		panic(err.Error())
	}
	emp := Employee{}
	res := []Employee{}
	for rows.Next() {
		var id int
		var name, city string
		err = rows.Scan(&id, &name, &city)
		if err != nil {
			panic(err.Error())
		}
		emp.ID = id
		emp.Name = name
		emp.City = city
		res = append(res, emp)
	}
	tmpl.ExecuteTemplate(w, "Index", res)
	defer db.Close()
}

// Show Single Item
func Show(w http.ResponseWriter, r *http.Request) {
	db := dbConnect()
	nID := r.URL.Query().Get("id")
	rows, err := db.Query("SELECT * FROM Employee WHERE id = ?", nID)
	if err != nil {
		panic(err.Error())
	}
	emp := Employee{}
	for rows.Next() {
		var id int
		var name, city string
		err = rows.Scan(&id, &name, &city)
		if err != nil {
			panic(err.Error())
		}
		emp.ID = id
		emp.Name = name
		emp.City = city
	}
	tmpl.ExecuteTemplate(w, "Show", emp)
	defer db.Close()
}

// Show New Page
func New(w http.ResponseWriter, r *http.Request) {
	tmpl.ExecuteTemplate(w, "New", nil)
}

// Edit Item
func Edit(w http.ResponseWriter, r *http.Request) {
	db := dbConnect()
	nID := r.URL.Query().Get("id")
	rows, err := db.Query("SELECT * FROM Employee WHERE id = ?", nID)
	if err != nil {
		panic(err.Error())
	}
	emp := Employee{}
	for rows.Next() {
		var id int
		var name, city string
		err = rows.Scan(&id, &name, &city)
		if err != nil {
			panic(err.Error())
		}
		emp.ID = id
		emp.Name = name
		emp.City = city
	}
	tmpl.ExecuteTemplate(w, "Edit", emp)
	defer db.Close()
}

// Insert Item
func Insert(w http.ResponseWriter, r *http.Request) {
	db := dbConnect()
	if r.Method == "POST" {
		name := r.FormValue("name")
		city := r.FormValue("city")
		insert, err := db.Prepare("INSERT INTO Employee (name, city) VALUES(?, ?)")
		if err != nil {
			panic(err.Error())
		}
		insert.Exec(name, city)
		log.Println("INSERT: Name: " + name + " | City: " + city)
	}
	defer db.Close()
	http.Redirect(w, r, "/", 301)
}

// Update Item
func Update(w http.ResponseWriter, r *http.Request) {
	db := dbConnect()
	if r.Method == "POST" {
		name := r.FormValue("name")
		city := r.FormValue("city")
		id := r.FormValue("uid")
		insert, err := db.Prepare("UPDATE Employee SET name = ?, city = ? WHERE id = ?")
		if err != nil {
			panic(err.Error())
		}
		insert.Exec(name, city, id)
		log.Println("UPDATE: Name: " + name + " | City: " + city)
	}
	defer db.Close()
	http.Redirect(w, r, "/", 301)
}

// Delete Item
func Delete(w http.ResponseWriter, r *http.Request) {
	db := dbConnect()
	emp := r.URL.Query().Get("id")
	delete, err := db.Prepare("DELETE FROM Employee WHERE id = ?")
	if err != nil {
		panic(err.Error())
	}
	delete.Exec(emp)
	log.Println("DELETE")
	defer db.Close()
	http.Redirect(w, r, "/", 301)
}

func main() {
	log.Println("Server started on: http://192.168.5.2:4000")
	// Routes
	http.HandleFunc("/", Index)
	http.HandleFunc("/show", Show)
	http.HandleFunc("/new", New)
	http.HandleFunc("/edit", Edit)
	http.HandleFunc("/insert", Insert)
	http.HandleFunc("/update", Update)
	http.HandleFunc("/delete", Delete)
	// Start server on port 4000
	http.ListenAndServe("192.168.5.2:4000", nil)
}
```
Note the script `http://192.168.5.2:4000`, it is the IP and Port that Go Lang will use to access the Web browser. Use the git command to initialize your Go Lang project.

```console
root@ns7:/var/FreeBSD-Golang-MySQL # go mod init github.com/iwanse1977/FreeBSD-Golang-MySQL
root@ns7:/var/FreeBSD-Golang-MySQL # go mod tidy
root@ns7:/var/FreeBSD-Golang-MySQL # go get github.com/go-sql-driver/mysql
```
In your working project, create a folder `"template"`, and create the files Edit.tmpl, Footer.tmpl, Header.tmpl, Index.tmpl, Menu.tmpl, New.tmpl, Show.tmpl.

```console
root@ns7:/var/FreeBSD-Golang-MySQL # mkdir template
root@ns7:/var/FreeBSD-Golang-MySQL # cd template
root@ns7:/var/FreeBSD-Golang-MySQL/template # touch Edit.tmpl Footer.tmpl Header.tmpl Index.tmpl Menu.tmpl New.tmpl Show.tmpl
```
<br/>
### [**Download the script code of the "*.tmpl" file**](https://www.opencode.net/unixbsdshell/freebsd-golang-mysql-crud.git)


## 3. Create MySQL Database
Your Go lang project is almost done, just one more step. Now you create a MySQL database as the backend of Go lang. Please login to the MySQL database server, with the root password.

```console
root@ns7:/var/FreeBSD-Golang-MySQL # mysql -u root -p
Enter password: "Enter your MySQL password"
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 83
Server version: 8.0.35 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]>
```
Create a database `"goblog"` and a table `"Employee"`.

```console
root@localhost [(none)]> create database goblog;
root@localhost [(none)]> use goblog;
Database changed
root@localhost [goblog]> CREATE TABLE IF NOT EXISTS `Employee` (
    ->   `id` int unsigned NOT NULL AUTO_INCREMENT,
    ->   `Name` text,
    ->   `city` text,
    ->   PRIMARY KEY (`id`)
    -> ) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
Query OK, 0 rows affected, 1 warning (0.02 sec)

root@localhost [goblog]>
```
Create a MySQL user, so that the MySQL database can be connected to Go lang.

```console
root@localhost [(none)]> CREATE USER 'jhondoe'@'localhost' IDENTIFIED BY 'router';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON * . * TO 'jhondoe'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
```

## 4. Run the application
Now that we have implemented all the MySQL and Go lang operations, it's time to test our application. Whether it works or not.

Open the Google Chrome web browser, and run the command `"http://192.168.5.2:4000"`. If all the above configurations are correct, Google Chrome will display the following image.

```console
root@ns7:~ # cd /var/FreeBSD-Golang-MySQL
root@ns7:/var/FreeBSD-Golang-MySQL # go run main.go
```

![FreeBSD Crud MysQL](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/12FreeBSD%20Crud%20MysQL.jpg&commit=02479a77f4b2e77d0d98e6dc1b4cde4ce4ad5b27)


In this article, we can learn how to create a simple CRUD application using GoLang and MySQL on a FreeBSD server. You can develop the following application with an attractive menu display. Stay tuned for our latest articles on Go Lang.