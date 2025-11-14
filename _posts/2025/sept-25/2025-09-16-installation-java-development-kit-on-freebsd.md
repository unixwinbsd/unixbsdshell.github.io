---
title: Installing and Using the Java Development Kit on FreeBSD
date: "2025-09-16 08:57:03 +0100"
updated: "2025-09-16 08:57:03 +0100"
id: installation-java-development-kit-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/java-openjdk.jpg
toc: true
comments: true
published: true
excerpt: Redmine is open source software or application that uses the Ruby On Rails Framework. Redmine is a project management or project tracking application which requires a DB server when running the application
keywords: java, installation, development, kit, freebsd, setup, http, tomcat, jdk, openjdk
---

FreeBSD is a powerful and reliable operating system that is widely used by developers and system administrators. If you are a Java developer, you need to install a Java development environment on your FreeBSD system, to help make it easier to run your Java projects.

In this article we will learn a brief introduction to setting up a Java development environment on your computer running reeBSD 13 or above. You can also apply the tutorials in this article to FreeBSD Desktops such as GhostBSD or Hello.

## 1. What Is Java

Java is a popular programming language, created in 1995 by Sun Microsystems (purchased by Oracle in 2010), and more than 3 billion devices in the world run Java.

One of Java's primary design goals is a high degree of portability across platforms. Java writing is summarized by the slogan write once, run anywhere, and is realized by compiling Java source code into 'bytecode', which can be run in a very uniform environment across different architectures and platforms.

So, someone can write code on Windows, but execute it on FreeBSD or GNU/Linux servers. Over time, Java has become extremely popular, and is a very reliable choice for writing server-side applications as well as Android applications.

Java environments can be found on all sorts of devices, large and small, and therefore a Java developer has more flexibility when it comes to being able to treat code as agnostic to the system on which it runs. The Java programming language itself is an object-oriented language that is syntactically similar to C++. Java has always been designed with an object-oriented design.

Because Java is built with the C++ language which is similar to the FreeBSD system, it can be easily run on Unix-based computers, such as FreeBSD, DragonFly BSD, GhostBSD, HardenedBSD and others.

**Java is used for:**

- Desktop applications.
- Web applications.
- Mobile applications (specially Android apps).
- Database connection.
- Web servers and application servers.
- Games.
- And much, much more!.

<br/>
{% lazyload data-src="/img/oct-25/java-openjdk.jpg" src="/img/oct-25/java-openjdk.jpg" alt="Java OpenJDK On FreeBSD" %}
<br/>

## 2. Install the Java Development Kit

Since Oracle Corporation bought Sun and is now the owner of the official Java runtime and development kit implementation. To be able to write Java, Oracle has provided implementations for Windows, Mac OSX, and Linux operating systems. The official reference implementation is open sourced under GPLv2 (with the exception of links), and therefore the OpenJDK implementation is workable for FreeBSD.

To be able to write applications in Java on FreeBSD, you need the Java Development Kit which provides a compiler, runtime and standard libraries. This package is available on FeeBSD, you just need to install it.

There are two different Java packages that can be installed:

- Java Runtime Environment (JRE), and
- Java Development Kit (JDK).

JRE is an implementation of the Java Virtual Machine (JVM), which runs compiled Java applications and applets. Whereas the JDK includes the JRE and other software needed to write, develop, and compile Java applications and applets.

Before we start installing Java, use the following command to view the list of Java available on `FreeBSD`.

```yml
root@ns7:~ # pkg search openjdk
```

You will see all versions of Java on FreeBSD.

```console
bootstrap-openjdk11-11.0.5.10.1 Java Development Kit 11
bootstrap-openjdk17-17.0.1.12.1 Java Development Kit 17
bootstrap-openjdk8-r450802_2   Java Development Kit 8
openjdk11-11.0.21+9.1          Java Development Kit 11
openjdk11-jre-11.0.21+9.1      Java Runtime Environment 11
openjdk17-17.0.9+9.1           Java Development Kit 17
openjdk17-jre-17.0.9+9.1       Java Runtime Environment 17
openjdk18-18.0.2+9.1_2         Java Development Kit 18
openjdk19-19.0.2+7.1_1         Java Development Kit 19
openjdk20-20.0.2+9.1           Java Development Kit 20
openjdk21-21.0.1+12.1          Java Development Kit 21
openjdk8-8.392.08.1            Java Development Kit 8
openjdk8-jre-8.392.08.1        Java Runtime Environment 8
rxtx-openjdk8-2.2p2_4          Native interface to serial ports in Java
```

Please select the version of Java that you want to install, with the following command.

```yml
root@ns7:~ # pkg install openjdk17-17.0.9+9.1
```

## 3. Editing Java Code

Java Editor is a simple and powerful application for creating, editing, and saving Java files on your FreeBSD Drive. With an intuitive interface and important features such as import and export and syntax highlighting. The Java Editor makes it easy for you to write Java code while traveling or at home. Java Editor is the perfect tool for anyone who needs to manage their Java code. Install Java Editor on your FreeBSD server and experience the power of easy Java editing!.

You can edit Java code using a plain text editor, but almost all Java programmers use an IDE to edit their code. There are several editors is available and you can install it on FreeBSD.

### a. Intellij IDEA

IntelliJ IDEA is an integrated development environment for Java applications from the JetBrains company. It is positioned as the smartest and most convenient Java development environment with support for all the latest technologies and frameworks. IntelliJ IDEA is one of the three most popular Java IDEs along with Eclipse IDE and NetBeans IDE.

Users will find that every aspect of IntelliJ IDEA is designed to maximize developer productivity. Both powerful static code analysis and ergonomic program design make development not only productive. They can make it a pleasant experience if we compare it with other IDEs.

Use the following command to install IntelliJ IDEA.

```yml
root@ns7:~ # pkg install intellij-2020.2.3
root@ns7:~ # pkg install intellij-ultimate-2022.2.5_1
```

### b. Netbeans

For those of you who are involved in the world of programming, you will definitely be familiar with this software. What is Netbeans? Netbeans is a software that is often used in the world of programmers or developers. Not an ordinary text editor, Netbeans is an IDE or Integrated Development Environment application that is based on Java and runs on Swing. What I mean by Swing here is a technology that allows the development of desktop applications and can run on various platforms such as FreeBSD, Windows, Mac OS, Linux and Solaris.

Meanwhile, the Integrated Development Environment is a programming or development system that is integrated into software. Netbeans provides several tools such as a Graphic User Interface (GUI), code or text editor, a compiler and debugger. This will make the performance of programmers or developers who use Netbeans easier. Not only does it support the Java programming language, by using Netbeans you can also create or develop programs based on C, C++ or even dynamic languages such as PHP, JavaScript, Groovy, and Ruby.

Netbeans is an open code (open source) application that is quite successful with many users and a growing community throughout the world and currently has 100 business partners and will likely continue to grow in the future. Sun Microsystems as the main sponsor of Netbeans has been around and developed since 2000 and to this day continues its collaboration.

Installing Netbeans on FreeBSD is very easy, just run the following command.

```yml
root@ns7:~ # pkg install netbeans-17
```

### c. Eclipse

Eclipse is a platform that has been designed to build various applications that can be integrated such as websites, mobile and so on. Eclipse is open source which is usually used to develop Java-based applications that allow software developers to create customized development environments (IDEs). You can develop and learn this platform if you take an Android course wherever you are.

Eclipse was started in 2001 by IBM, at which time the company donated three million lines of code from its Java tool. The goal of Eclipse is to create and foster an open source IDE community that will complement the Apache community.

Eclipse provides a common user interface (UI) model for working with other tools. It is designed to run on multiple operating systems while providing tight integration with each underlying OS. Plug-ins are used for Eclipse portable API programs and change on any of the supported operating systems.

Before you install Eclipse, look at the version of Eclipse available on freeBSD.

```yml
root@ns7:~ # pkg search Eclipse
```

Below are the Eclipse versions available on FreeBSD.

```console
eclipse-4.24_2                 Eclipse IDE 2022-06
eclipse-EPIC-0.6.35_3          EPIC adds Perl support to the Eclipse IDE Framework
eclipse-ShellEd-1.0.2a_4       Shell script editor for Eclipse
eclipse-cdt-9.0.1              C/C++ plugin for Eclipse IDE
eclipse-drjava-0.9.8_6         DrJava plugin for Eclipse
eclipse-ecj-4.4.2_1            Eclipse Java Compiler
eclipse-findbugs-3.0.1.20150306.5.a4.d1 Eclipse plug-in that provides FindBugs support
eclipse-glassfish-5.1.0_1      Eclipse Jakarta EE Platform
eclipse-pydev-10.2.1           Eclipse plugin for Python and Jython development
phpeclipse-1.2.3_6             PHP Eclipse adds PHP support to the Eclipse IDE Framework
redeclipse-2.0.0_2             Single-player and multi-player first-person ego-shooter
redeclipse-data-2.0.0          Data files for Red Eclipse first-person shooter
redeclipse-data16-1.6.0        Data files for Red Eclipse first-person shooter
redeclipse16-1.6.0_2           Single-player and multi-player first-person ego-shooter
```

Run the following command to install Eclipse.

```yml
root@ns7:~ # pkg install eclipse-4.24_2
```

### d. Maven

Maven is an application or program that is widely used to assist in creating Java projects. Maven was developed by the Apache Group with the aim of building, publishing, and distributing projects created by developers.

On FreeBSD Maven can be installed with the ports or PKG system, in this article we will install Maven with the PKG package.

```yml
root@ns7:~ # pkg install maven
```

### e. Scala

Scala is a general purpose programming language that supports object-oriented programming and functional programming. In general, the purpose of creating Scala is to criticize the Java programming language.

Scala source code is built to compile with Java Bytecode, resulting in code execution running on a Java virtual machine. Scala provides language interoperability with Java, so that libraries written in these two languages can be referenced directly in Scala or Java code.

Use the PKG package to install Scala on FreeBSD.

```yml
root@ns7:~ # pkg install scala
```

Installing the Java Development Kit on a FreeBSD system can help you develop Java applications. While this article doesn't go into detail about writing Java programs, customizing the IDE, or the various options you can provide to the JVM when running it, it can be used to supplement your knowledge of Java programming.