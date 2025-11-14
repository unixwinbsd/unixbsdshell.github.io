---
title: How to Install and Use MongoDB on a FreeBSD System
date: "2025-10-03 20:10:33 +0100"
updated: "2025-10-03 20:10:33 +0100"
id: how-to-install-mongodb-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/oct-25/oct-25-32.jpg
toc: true
comments: true
published: true
excerpt: In this installation process we will use the FreeBSD ports system. It is recommended that every time we install a database application, be it MySQL, MariaDB or MongoDB, use the ports system, because when using the pkg package, the supporting dependencies are often not loaded. Below is how to install MongoDB on FreeBSD
keywords: installation, mongodb, database, freebsd, sql, myswl, database server
---

Understanding the NoSQL DBMS MongoDB: why it is so popular, how it differs from others, who uses it and when. 10gen began developing MongoDB in mid-2007 as part of its Software Platform as a Service project. They wanted to create an application server and database that would serve as a host for web applications, while providing automatic scaling and management of software and hardware infrastructure. In the mid-2000s, this approach did not catch on in the market, but new database technologies became very popular. Now this is one of the classic examples of NoSQL systems.


## 1. NoSQL for unstructured data

Developers have been using SQL databases for decades to build large, scalable systems. But as time goes by, the need arises to store data without a particular structure. Working with them in a two-dimensional table doesn't work. Then they decided to use a non-relational database, which they called NoSQL. An additional benefit is that many data types that were previously modeled in a relational approach are much easier to represent and use in a NoSQL approach.

NoSQL allows you to operate with various types of data, while implementing full-text search in databases, including without specifying the `"schema"` of the data. The database is characterized by high availability and fault tolerance. There are no connections between records, so the data can be easily divided into independent parts and split: grouped into parts and placed on different, physically and logically independent database servers. This is how horizontal scaling works. This approach is fundamentally different from vertical scaling. With increasing load and data volume, this provides an increase in the computing capabilities of a single database server, which has objective physical limitations: the maximum number of supported CPUs, the amount of memory, etc.

According to the ranking of the DB-Engines portal, MongoDB is one of the five most popular DBMS in the world, I wonder if its authors Dwight Merriman, Eliot Horowitz and Kevin Ryan expected such success in 2007 when they started development?. Most likely huh?, after all, MongoDB has an impressive number of advantages with a small number of insignificant disadvantages.

Another important feature of NoSQL is the large number of database types that are designed and optimized for specific types of data models (document, graph, column, or key-value) and access patterns. NoSQL is best suited for applications that need to process large amounts of data with different structures quickly and with low latency.

Moreover, many modern databases are starting to combine SQL and NoSQL concepts. PostgreSQL, for example, still cannot scale horizontally with the database itself, but now supports not only storage, but also indexing of JSON data, like MongoDB.


## 2. What Is MongoDB

MongoDB is a document-based non-relational DBMS licensed under the SSPL and is open source. The creator is quite authoritative in the world of IT developers. In particular, it was they who founded DoubleClick in the early 2000s, one of the first companies to specialize in Internet advertising, with a fantastic display speed of up to 400,000 ads per second at that time.

In 2005, Merriman and his partners sold it profitably to Google and were able to solve a problem that had long worried them. The databases that existed in the mid-zero year did not have a clear structure, the information fragments stored in them were not connected to each other, and there were always problems with scalability and flexibility.

This is where the company 10gen was born, which was later renamed in honor of its flagship product MongoDB Inc. Several versions of MongoDB have been released over the years.

In a conventional relational database, information is stored in the form of interconnected tables. The structure is rigidly regulated, and it is not easy to change it. The rows of each table have the same set of fields, the data is processed using SQL queries. These databases are visual, but not always convenient, for example, if you need to store information without a certain structure, it is impossible to present it in the form of a two-dimensional table.

In MongoDB, things are a little different. A database consists of collections and documents, a hierarchical structure containing key-value pairs (fields). If we make an analogy with a relational database, collections with this storage method are related to tables, and documents are related to lines. The information is formatted in BSON, a binary encoding of JSON-like documents. This allows you to support both date and binary data, which is not possible with JSON. The document does not have a strict structure. They can contain different sets of fields, differing in type and quantity.


![oct-25-32](/img/oct-25/oct-25-32.jpg)


## 3. Installing MongoDB on FreeBSD

In this article we try to discuss the installation and configuration process, we will try to run the MongoDB database on the `FreeBSD 13.2` system.

In this installation process we will use the FreeBSD ports system. It is recommended that every time we install a database application, be it MySQL, MariaDB or MongoDB, use the ports system, because when using the pkg package, the supporting dependencies are often not loaded. Below is how to install MongoDB on FreeBSD.

```
root@ns1:~ # portmaster -af
root@ns1:~ # portupgrade -af
```

The script above is to update and upgrade the `ports system` on the FreeBSD system. After the pkg update process is complete, we continue with the installation of `MongoDB dependencies`.

```
root@ns1:~ # cd /usr/ports/devel/llvm
root@ns1:/usr/ports/devel/llvm # make install clean
root@ns1:/usr/ports/devel/llvm # cd /usr/ports/lang/python39
root@ns1:/usr/ports/lang/python39 # make install clean
root@ns1:/usr/ports/lang/python39 # cd /usr/ports/devel/scons
root@ns1:/usr/ports/devel/scons # make install clean
root@ns1:/usr/ports/devel/scons # cd /usr/ports/textproc/gsed
root@ns1:/usr/ports/textproc/gsed # make install clean
root@ns1:/usr/ports/textproc/gsed # cd /usr/ports/databases/py-pymongo
root@ns1:/usr/ports/databases/py-pymongo # make install clean
```

Then we continue by installing `MongoDB`.

```
root@ns1:~ # cd /usr/ports/databases/mongodb50
root@ns1:/usr/ports/databases/mongodb50 # make install clean
```

So that MongoDB can run automatically, add the following script to the `/etc/rc.conf` file.

```
root@ns1:~ # ee /etc/rc.conf
mongod_enable="YES"
mongod_dbpath="/var/db/mongodb"
mongod_flags="--logpath ${mongod_dbpath}/mongod.log --logappend --setParameter=disabledSecureAllocatorDomains=\*"
mongod_user="mongodb"
mongod_group="mongodb"
mongod_config="/usr/local/etc/mongodb.conf"
```


## 4. MongoDB Configuration

The main MongoDB config file is located at `/usr/local/etc/mongodb.conf`. Edit the file according to the specifications on our FreeBSD system. In this article we will run MongoDB on port `27017` with Private IP `192.168.5.2`. The following is an example of editing the mongodb.conf file.

```
root@ns1:~ # ee /usr/local/etc/mongodb.conf
# network interfaces
net:
  port: 27017
  bindIp: 192.168.5.2
```

Create file `ownership` or ownership rights in the MongoDB application.

```
root@ns1:~ # chown -R mongodb:mongodb /var/db/mongodb
```

After that, run MognoDB or restart, but for the first installation you must reboot the FreeBSD computer.

```
root@ns1:~ # reboot
```

```
root@ns1:~ # service mongod restart
```

To test the database and further confirm that MongoDB has started correctly and is fully operational, run the following command to check the MongoDB connection status.

```
root@ns1:~ # mongo --eval 'db.runCommand({ connectionStatus: 1 })'
```

By following this article, you have now successfully updated the FreeBSD system and repositories, you have successfully installed MongoDB, configured it to start at system boot-up, and finally secured the server to prevent unauthorized access.