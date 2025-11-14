---
title: How to Install Apache ZooKeeper on FreeBSD 14
date: "2025-02-15 10:17:10 +0100"
updated: "2025-02-15 10:17:10 +0100"
id: how-to-install-apache-zookeeper-freebsd14
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Apache ZooKeeper aims for configuration management, distributed system synchronization, and clustering and naming
keywords: apache, zookeeper, java, openjdk, freebsd, unix, linux, maven, development, kit, server
---

Apache ZooKeeper aims for configuration management, distributed system synchronization, and clustering and naming. ZooKeeper services are often used in distributed systems to coordinate and manage state that needs to be distributed between cluster nodes. ZooKeeper is designed to be easy to program, and uses a data model that is based on the common file system directory tree structure. It runs in Java and has bindings for Java and C.

The ZooKeeper service was created as part of the Apache Hadoop ecosystem to interface large cluster management and is a critical part of many distributed systems, such as Apache Kafka, HBase, Solr, and others. ZooKeeper solves synchronization, configuration management, distributed lock management, and leadership in distributed applications.

Coordination services are notoriously difficult to configure correctly and precisely. They are highly susceptible to errors such as race conditions and deadlocks. The motivation behind ZooKeeper is to relieve distributed applications from the responsibility of implementing coordination services from scratch.

## 1. Why ZooKeeper is So Necessary
Apache Zookeeper is an open-source distributed configuration and synchronization service and naming registry for distributed applications. In distributed systems, it is often necessary to synchronize state between multiple nodes. For example:
- Make sure that only one node performs a specific task (leadership).
- Manage the configuration that must be consistent across all nodes.
- Detect changes in the cluster (for example, adding or deleting nodes).
- Support for distributed locking to prevent concurrent access to shared resources.

### a. Examples of using ZooKeeper:
- Apache Kafka: ZooKeeper is used for Kafka broker coordination, metadata management, and distributed synchronization.
- Apache HBase: ZooKeeper manages and coordinates distributed HBase servers.
- Distributed databases: ZooKeeper can be used to manage distributed transactions and select a leader in the database.

## 2. System specifications
- OS: FreeBSD 14.1-STABLE
- Hostname: ns4
- IP Address: 192.168.5.71
- JAVA version: 
	- openjdk version "20.0.2" 2023-07-18
	- OpenJDK Runtime Environment (build 20.0.2+9-1)
	- OpenJDK 64-Bit Server VM (build 20.0.2+9-1, mixed mode, sharing)
	- ZooKeeper Version: apache-zookeeper-3.8.3

## 3. Installing Apache ZooKeeper on FreeBSD

Apache ZooKeeper ensures high availability, consistency, and reliability by efficiently managing configuration, synchronization, and service discovery across multiple nodes. On the FreeBSD system, the ZooKeeper repository is available, you can directly install it via the PKG package or the Ports system.

However, before you install ZooKeeper on FreeBSD, make sure all dependencies required by ZooKeeper are installed correctly. Here are the dependencies that you must install.

```
root@ns4:~ # pkg install libzookeeper
```

### a. Install Java OpenJDK
ZooKeeper is written in Java and requires Java to run properly. On FreeBSD the Java OpenJDK repository is available, for a guide to installing Java OpenJDK you can read [the previous article](https://unixwinbsd.site/freebsd/installation-java-development-kit-on-freebsd/).

So, in this article we do not explain the process of installing Java OpenJDK on FreeBSD, you can read the article above which explains the process of installing Java.

### b. Install Apache ZooKeeper
ZooKeeper repository has been added to FreeBSD system since 2012, so it is very easy for you to install it. Because ZooKeeper repository is available, you only need to make a few changes such as enabling it in the "/etc/rc.conf" file.

```
root@ns4:~ # pkg install zookeeper
```

## 4. Configure ZooKeeper in Standalone Mode
For testing or development purposes, ZooKeeper runs in the Standalone mode. Standalone mode is to install ZooKeeper on a single machine.

### a. Set the machine id

```
root@ns4:~ # echo 1 > /var/db/zookeeper/myid1
root@ns4:~ # echo 2 > /var/db/zookeeper/myid2
root@ns4:~ # echo 3 > /var/db/zookeeper/myid3
```

After that you run the "chown" command. This command is used to change the owner and/or group of a file or directory in the file system. This command allows users to grant more specific access rights and control to existing files or directories.

```
root@ns4:~ # chown -R zookeeper:zookeeper /var/db/zookeeper
root@ns4:~ # chown -R zookeeper:zookeeper /var/log/zookeeper
```

### b. Enable and Start zookeeper on Boot
To enable ZooKeeper at boot, you need to add the script below in the **"/etc/rc.conf"** file.

```
root@ns4:~ # echo 'zookeeper_enable="YES"' >> /etc/rc.conf
```

### c. Create a configuration file
Configuration files are very important to set the application to run as we wish. By default the "ZooKeeper" configuration file is located in the "/usr/local/etc/zookeeper" folder.

```
root@ns4:~ # cp /usr/local/etc/zookeeper/zoo.cfg.sample /usr/local/etc/zookeeper/zoo.cfg
```

After that, you type or activate the script below in the file "/usr/local/etc/zookeeper/zoo.cfg".

```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/var/db/zookeeper
clientPort=2181
server.1=192.168.5.71:2888:3888
server.2=192.168.5.72:2888:3888
server.3=192.168.5.73:2888:3888
```

### d. Running ZooKeeper
The final step is to run ZooKeeper with the "service" command.

```
root@ns4:~ # service zookeeper restart
root@ns4:~ # service zookeeper status
```

Once the server is up and running, you can connect to the server using the zkCli.sh command
and try out a few commands to verify that everything is working as expected.

```
root@ns4:~ # zkCli.sh -server 192.168.5.71:2181
```

In this article we have learned how to install Apache ZooKeeper on FreeBSD 14.1. This article explains how to install ZooKeeper and outlines all the steps to take before installing and running ZooKeeper.
