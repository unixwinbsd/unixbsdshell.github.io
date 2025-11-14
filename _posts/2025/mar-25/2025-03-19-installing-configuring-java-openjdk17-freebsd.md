---
title: Installing and Configuring Java openjdk17 in FreeBSD
date: "2025-03-19 20:35:15 +0100"
updated: "2025-03-19 20:35:15 +0100"
id: installing-configuring-java-openjdk17-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/mount_java_freebsd.jpg
toc: true
comments: true
published: true
excerpt: Java has become one of the prominent programming languages in software application development. To be able to write, compile, and run Java code, a runtime environment is needed to provide the necessary tools
keywords: java, maven, openjdk, freebsd, install, implementing, jar, unix, apache
---

Java has become one of the prominent programming languages in software application development. To be able to write, compile, and run Java code, a runtime environment is needed to provide the necessary tools. With continued incremental growth, Java 17 is currently the latest long-term release under the extensive collaboration of Oracle and other members of the worldwide Java developer community through the OpenJDK Community and the Java Community Process (JPC).


OpenJDK is an open-source implementation of the Java Standard Edition (Java SE) and the Java Development Kit (JDK). It comes with components such as a virtual machine, Java Class Library, and Java Compiler (javac). In this article, I will guide you on how to install and configure openjdk17 on FreeBSD 13. In this tutorial we will install Java with FreeBSD Ports.

The first step you have to log in to the FreeBSD server as root, if you have successfully logged in, continue by opening Java Ports in the /usr/ports/java/openjdk17 folder.

```
root@router2:~ # cd /usr/ports/java/openjdk17
root@router2:~ # make install clean
```

After the installation is complete you will be shown the following display:

![mount java freebsd](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/mount_java_freebsd.jpg)

Now we continue, according to the instructions above, type the script **mount -t fdescfs fdesc /dev/fd and mount -t procfs proc /proc**.

```
root@router2:~ # mount -t fdescfs fdesc /dev/fd
root@router2:~ # mount -t procfs proc /proc
```

Then add the two scripts above to the /etc/fstab file.

```
root@router2:~ # ee /etc/fstab
fdesc   /dev/fd         fdescfs         rw      0       0
proc    /proc           procfs          rw      0       0
```

Check JAVA Version, to check it use this script **java -version**.

```
root@router2:~ # java -version
openjdk version "1.8.0_442"
OpenJDK Runtime Environment (build 1.8.0_442-b06)
OpenJDK 64-Bit Server VM (build 25.442-b06, mixed mode)
```

The next step is to set JAVA as JAVA_HOME Environment. JAVA_HOME is an operating system environment variable for the Java Development Kit (JDK) or Java Runtime Environment (JRE). JAVA_HOME can be optionally set after the JDK or JRE installation is complete.

The JAVA_HOME variable points to the location where the JDK or JRE is installed on the FreeBSD system. Java applications use this variable to find where the runtime is installed. On FreeBSD, you need to set the JAVA_HOME environment in /etc/csh.cshrc.
Open the csh.cshrc file and add the following two lines:

```
root@router2:~ # ee /etc/csh.cshrc
# $FreeBSD$
#
# System-wide .cshrc file for csh(1).
setenv JAVA_VERSION "17.0+"
setenv JAVA_HOME /usr/local/openjdk17
```

Type the source script /etc/csh.cshrc

```
root@router2:~ # source /etc/csh.cshrc
openjdk version "17.0.7" 2023-04-18
OpenJDK Runtime Environment (build 17.0.7+7-1)
OpenJDK 64-Bit Server VM (build 17.0.7+7-1, mixed mode, sharing)
```

If the results do not show the above information, you can add Environment JAVA_HOME to $PATH in the root of ~/.cshrc. Add $JAVA_HOME/bin in the .cshrc file in the /root folder.

```
root@router2:~ # ee .cshrc
set path = ($JAVA_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```

The final step is that we test the JAVA program. To test the JAVA program, we create a file in the /usr/local/openjdk17 folder. We will name the file test.java.

```
root@router2:~ # cd /usr/local/openjdk17
root@router2:/usr/local/openjdk17 # touch test.java
root@router2:/usr/local/openjdk17 # ee test.java
```

Enter the following script in the test.java file.

```
public class test {
    public static void main(String[] args) {
        System.out.println("Test Program JAVA 17 Di FreeBSD 13");
    }
}
```

Now we compile the test.java file.

```
root@router2:~ # cd /usr/local/openjdk17
root@router2:/usr/local/openjdk17 # java test.java
```

Java offers developers a versatile and powerful programming platform for developing a variety of applications. With its platform independence, extensive standard library, and active community, Java continues to evolve and evolve, maintaining its relevance and popularity among developers around the world.

In this article, you have learned how to install Java 17 on a FreeBSD 13.2 stable system. With the output from the JAVA program test results above, you have successfully run the JAVA program on FreeBSD 13. I suggest you try another version of JAVA to install on the FreeBSD Server.
