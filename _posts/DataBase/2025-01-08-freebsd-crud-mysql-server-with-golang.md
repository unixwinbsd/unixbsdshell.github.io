---
title: FreeBSD14 Crud MysQL Server With Go Lang
date: "2025-01-09 14:14:10 +0100"
id: freebsd-crud-mysql-server-with-golang
lang: en
categories:
  - FreeBSD
tags: "DataBase"
excerpt: CRUD, which stands for Create, Read, Update, and Delete, is a common utility in software development
keywords: go, go lang, freebsd, mysql, crud, golang, app, web
---

Building a Restful application is one of the popular ways to build a cool blog by following a simple and scalable architecture. With CRUD, users can easily process MySQL databases. CRUD, which stands for Create, Read, Update, and Delete, is a common utility in software development. The ability to perform CRUD operations is fundamental to any application development.

Go Lang is a popular programming language known for its efficiency, simplicity, and stability, while MySQL is a relational database management system (RDBMS) developed by Oracle based on the structured query language (SQL). While MySQL is one of the most popular database technologies in the modern big data ecosystem, and is now widely and effectively used, regardless of industry, it is clear that anyone involved with enterprise data or IT should have at least a basic understanding of MySQL.

![cover freebsd golang go crud mysql server database](https://www.opencode.net/unixbsdshell/freebsd-golang-mysql-crud/-/raw/main/FreeBSD_Golang_CRUD.jpg)

With MySQL, we can learn the relational database system can immediately build a data storage system that is easy, fast, and secure. Data in MySQL is arranged according to the relational model. In this model, tables consist of rows and columns, and the relationships between data elements all follow a strict logical structure. Often people who are new to learning Golang do not know how to store data in MySQL because there are not many online resources. This article will help you understand the concept of Golang with MySQL.<br><br/>

## 1. System Specifications Used
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

Once you have finished creating the Go language directory, create a new file named "main.go".

```console
root@ns7:/var/FreeBSD-Golang-MySQL # touch main.go
root@ns7:/var/FreeBSD-Golang-MySQL # chmod +x main.go
```

In the file `"/root/var/FreeBSD-Golang-MySQL/main.go"`, you enter the script below.













Note the script `http://192.168.5.2:4000`, this is the IP and Port that Go Lang will use to access the Web browser. Use the git command to initialize your Go Lang project.

```js
root@ns7:/var/FreeBSD-Golang-MySQL # go mod init github.com/iwanse1977/FreeBSD-Golang-MySQL
root@ns7:/var/FreeBSD-Golang-MySQL # go mod tidy
root@ns7:/var/FreeBSD-Golang-MySQL # go get github.com/go-sql-driver/mysql
```
















