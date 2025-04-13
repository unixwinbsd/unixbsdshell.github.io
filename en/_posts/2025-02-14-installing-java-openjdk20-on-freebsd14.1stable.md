---
title: Installing and Configuring Java OpenJDK 20 on FreeBSD 14.1 Stable
date: "2025-02-14 14:11:19 +0100"
id: installing-java-openjdk20-on-freebsd14.1stable
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
excerpt: OpenJDK is an open source implementation of Java Standard Edition (Java SE) and the Java Development Kit (JDK).
keywords: java, openjdk, freebsd, unix, linux, maven, development, kit, server
---

Java has become one of the leading programming languages ​​in software application development. In order to write, compile, and run Java code, a runtime environment is required to provide the necessary tools. With continued incremental growth, Java 17 is currently the latest long-term release under the extensive collaboration of Oracle and other members of the worldwide Java developer community through the OpenJDK Community and the Java Community Process (JPC).

OpenJDK is an open-source implementation of Java Standard Edition (Java SE) and the Java Development Kit (JDK). OpenJDK comes with components such as a virtual machine, Java Class Library, and Java Compiler (javac). In this article, I will guide you on how to install and configure openjdk17 on FreeBSD 13. In this tutorial, we will install Java with FreeBSD Ports.

## Install Java OpenJDK on FreeBSD
The first step you have to log in to the FreeBSD server as root, if you have successfully logged in, continue by opening Java Ports in the /usr/ports/java/openjdk20 folder.

```
root@router2:~ # cd /usr/ports/java/openjdk20
root@router2:~ # make install clean
```
or
```
root@router2:~ # pkg install openjdk20
```



Memasang dan Mengkonfigurasi Java OpenJDK 20 di FreeBSD 14.1 Stable
