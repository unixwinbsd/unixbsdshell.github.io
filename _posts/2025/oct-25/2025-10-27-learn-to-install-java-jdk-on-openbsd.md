---
title: Learn to Install Java JDK on OpenBSD 7.6
date: "2025-10-27 09:25:12 +0100"
updated: "2025-10-27 09:25:12 +0100"
id: learn-to-install-java-jdk-on-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://media.licdn.com/dms/image/v2/D5612AQGGlzMWNVgznw/article-cover_image-shrink_720_1280/B56ZZVp.rdGkAI-/0/1745193791112?e=1763596800&v=beta&t=fS440G_6PpTms8SQ7AyuDWCGENPoRzkVzMo_1CsUdW8
toc: true
comments: true
published: true
excerpt: For a list of pointers to packages of the BSD Port for DragonFly BSD, FreeBSD, Mac OS X, NetBSD and OpenBSD, please see the BSD porting Project's wiki page.
keywords: freebsd, java, openjdk, jre, jdk, ports, package, bsd, Java Development Kit
---

OpenJDK is an open-source implementation of Java Standard Edition (Java SE) and the Java Development Kit (JDK). OpenJDK includes components such as a virtual machine, the Java Class Library, and the Java Compiler (javac). OpenJDK boasts many powerful features, including String Templates, Sequenced Collections, Record Patterns, Foreign Function & Memory API, Virtual Threads, Unnamed Patterns and Variables, Unnamed Classes and Instance Main Methods, and the Key Encapsulation Mechanism API.

The Java Development Kit (JDK) is one of the three core technologies used in Java programming. It also includes the JVM (Java Virtual Machine) and the JRE (Java Runtime Environment). It's important to understand the differences between the two and how they relate to each other. Here's a brief explanation:

- The JRE creates and runs the JVM.
- The JDK allows developers to create programs that can be executed and run by the JVM and JRE.
- The JVM is responsible for executing Java programs.

Beginning Java developers often confuse the JDK and the JRE. The difference between the JDK and the JRE is that the JDK is a tool package for software development, while the JRE is a tool package for running Java code.

The JRE can be used as a standalone component to simply run Java programs, or it can be part of the JDK. The JDK requires the JRE because running programs is an integral part of its development.

Let's look at the technical and general definitions of the JDK:

- Technical definition: The JDK is an implementation of the Java platform specification, including the compiler and class libraries.
- General definition: The JDK is the software package you download to create Java applications.

In addition to the JRE, which is the environment used to run Java applications, every JDK contains [a Java compiler](https://unixforum.org/viewtopic.php?t=12029). A compiler is a program that can take a source file with the extension .java, which is plain text, and convert it into an executable file with the extension .class.

We'll see how the compiler works soon, but first, let's look at how to download and configure the JDK.

## A. System Specifications:

- OS: OpenBSD 7.6 amd64
- Hostname: ns5
- Domain: kursor.my.id
- IP Address: 192.168.5.3
- Java version: jdk-21.0.4.7.1v0

## B. Start Installing Java
Now that you know the technical and general definitions of the JDK, it's time to start installing Java. Java applications on OpenBSD are available through PKG packages and the Ports system. In this article, we will install [Java using the PKG package](https://unixwinbsd.site/freebsd/install-modul-mod-jk-java-freebsd/).

For a complete list of BSD Ports package repositories for DragonFly BSD, FreeBSD, Mac OS X, NetBSD, and OpenBSD, please see the BSD Ports Project [wiki page](https://wiki.openjdk.org/display/BSDPort/Main).

```yml
ns5# pkg_info jdk
```

Once you know the Java repository on OpenBSD, we continue by installing Java.

```console
ns5# pkg_add jdk
Ambiguous: choose package for jdk
a       0: <None>
        1: jdk-1.8.0.422.b05.1v0
        2: jdk-11.0.24.8.1v0
        3: jdk-17.0.12.7.1v0
        4: jdk-21.0.4.7.1v0
Your choice: 4
jdk-21.0.4.7.1v0:lcms2-2.16p0: ok
jdk-21.0.4.7.1v0:giflib-5.2.2: ok
jdk-21.0.4.7.1v0: ok
New and changed readme(s):
        /usr/local/share/doc/pkg-readmes/jdk-21
--- +jdk-21.0.4.7.1v0 -------------------
You may wish to add /usr/local/jdk-21/man to /etc/man.conf
```

Take a look at the script above; there are four Java versions available for installation. In this article, you'll choose number 4.

### b. 1. Create the Java JDK21 Path
Creating this path is crucial, as Java won't run if you don't specify it. This path will contain all Java files. The [Java JDK21 path](https://github.com/lea2501/guides/blob/main/openbsd_guide_install-post_install-install_java_jdk.md) is located in the `/usr/local/jdk-21/` folder by default.

To create the Java JDK21 path, type the following script into the `/root/.profile` file.

```yml
export PATH=$PATH:/usr/local/jdk-21/bin
export JAVA_HOME=/usr/local/jdk-21/
```

### b.2. Check the Java JDK21 Version

This step is to verify whether Java is installed on OpenBSD. You can run the `java -version` command, as in the following example.

```yml
ns5# java -version
openjdk version "21.0.4" 2024-07-16
OpenJDK Runtime Environment (build 21.0.4+7-1)
OpenJDK 64-Bit Server VM (build 21.0.4+7-1, mixed mode, sharing)
```

## C. Creating a Simple Java Application

In this section, we will demonstrate how to create a simple [Java application on OpenBSD](https://unixwinbsd.site/freebsd/implementing-maven-and-java-on-freebsd/). The purpose of this application is not only to test Java but also to provide information on how to use Java on OpenBSD. Follow each step below.

### c.1. Create a test file

In this section, we will create a file named "testjavaopenbsd.java".

```yml
ns5# cd /usr/local/jdk-21
ns5# touch testjavaopenbsd.java
```

In the file `/usr/local/jdk-21/testjavaopenbsd.java`, type the script below.

```console
public class test {
    public static void main(String[] args) {
        System.out.println("Test Program JAVA JDK 21 Di OpenBSD 7.6");
    }
}
```

### c.2. Run the file /usr/local/jdk-21/testjavaopenbsd.java

After you've entered the script above in the file `/usr/local/jdk-21/testjavaopenbsd.java`, now let's run the file.

```yml
ns5# cd /usr/local/jdk-21
ns5# java testjavaopenbsd.java
Test Program JAVA JDK 21 Di OpenBSD 7.6
```

The message **"Test Program JAVA JDK 21 On OpenBSD 7.6"** has appeared, meaning you have successfully installed and run [Java JDK21 on OpenBSD](https://github.com/JabRef/jabref/issues/9745).