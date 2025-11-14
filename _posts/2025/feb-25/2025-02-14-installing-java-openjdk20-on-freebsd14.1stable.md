---
title: Installing and Configuring Java OpenJDK 20 on FreeBSD 14.1 Stable
date: "2025-02-14 14:11:19 +0100"
updated: "2025-02-14 14:11:19 +0100"
id: installing-java-openjdk20-on-freebsd14.1stable
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/freebsd_14_java_openjdk_install.jpg
toc: true
comments: true
published: true
excerpt: OpenJDK is an open source implementation of Java Standard Edition (Java SE) and the Java Development Kit (JDK).
keywords: java, openjdk, freebsd, unix, linux, maven, development, kit, server
---

Java has become one of the leading programming languages ​​in software application development. In order to write, compile, and run Java code, a runtime environment is required to provide the necessary tools. With continued incremental growth, Java 17 is currently the latest long-term release under the extensive collaboration of Oracle and other members of the worldwide Java developer community through the OpenJDK Community and the Java Community Process (JPC).

OpenJDK is an open-source implementation of Java Standard Edition (Java SE) and the Java Development Kit (JDK). OpenJDK comes with components such as a virtual machine, Java Class Library, and Java Compiler (javac). In this article, I will guide you on how to install and configure openjdk17 on FreeBSD 13. In this tutorial, we will install Java with FreeBSD Ports.

## 1. Install Java OpenJDK on FreeBSD
The first step you have to log in to the FreeBSD server as root, if you have successfully logged in, continue by opening Java Ports in the /usr/ports/java/openjdk20 folder.

```
root@router2:~ # cd /usr/ports/java/openjdk20
root@router2:~ # make install clean
```
or
```
root@router2:~ # pkg install openjdk20
```
Once the installation is complete, you will be shown the following command shell screen:

![freebsd14 java openjdk install](https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/freebsd_14_java_openjdk_install.jpg)

Now we continue according to the instructions above, type the script mount -t fdescfs fdesc /dev/fd and mount -t procfs proc /proc.

```
root@hostname1:/var/db/pkg/repos/FreeBSD # mount -t fdescfs fdesc /dev/fd
root@hostname1:/var/db/pkg/repos/FreeBSD # mount -t procfs proc /proc
```

After that, you add the two scripts above to the "/etc/fstab" file.

```
root@router2:~ # ee /etc/fstab
fdesc   /dev/fd         fdescfs         rw      0       0
proc    /proc             procfs          rw      0       0
```

After that, if you want to check whether Java is installed on FreeBSD, do a check by checking the Java version, to check it use the "java -version" script.

```
root@ns4:~ # java -version
openjdk version "20.0.2" 2023-07-18
OpenJDK Runtime Environment (build 20.0.2+9-1)
OpenJDK 64-Bit Server VM (build 20.0.2+9-1, mixed mode, sharing)
root@ns4:~ #
```

The next step is to set JAVA as the JAVA_HOME Environment. JAVA_HOME is an operating system environment variable for the Java Development Kit (JDK) or Java Runtime Environment (JRE). JAVA_HOME can be optionally set after the JDK or JRE installation is complete.

The JAVA_HOME variable points to the location where the JDK or JRE is installed on a FreeBSD system. Java applications use this variable to find where the runtime is installed. On FreeBSD, you need to set the JAVA_HOME environment in /etc/csh.cshrc.
Open the csh.cshrc file and add the following two lines:

```
root@router2:~ # ee /etc/csh.cshrc
# $FreeBSD$
#
# System-wide .cshrc file for csh(1).
setenv JAVA_VERSION "20.0+"
setenv JAVA_HOME /usr/local/openjdk20
```

After that, you type the script below into /etc/csh.cshrc, the goal is to activate or execute the environment variable (PATH).

If the script above fails to execute the Java environment variable (PATH), you can add the JAVA_HOME Environment to $PATH in the root ~/.zshrc. Add $JAVA_HOME/bin to the .bashrc file in the /root folder.

```
root@router2:~ # ee .cshrc
set path = ($JAVA_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```

## 2. Test Java that has been installed on FreeBSD
The last step is to test the JAVA program. To test the JAVA program, we create a file in the /usr/local/openjdk20 folder. We name the file test.java.

```
root@router2:~ # cd /usr/local/openjdk20
root@router2:/usr/local/openjdk20 # touch test.java
root@router2:/usr/local/openjdk20 # ee test.java
```

Enter the following script into the "test.java" file.

```
public class test {
    public static void main(String[] args) {
        System.out.println("Test Program JAVA 20 Di FreeBSD 14.1 Stable");
    }
}
```

Now we compile or run the test.java file.

```
root@router2:~ # cd /usr/local/openjdk20
root@router2:/usr/local/openjdk17 # java test.java
```

Java offers developers a versatile and powerful programming platform for developing a variety of applications. With platform independence, an extensive standard library, and an active community, Java continues to grow and evolve, maintaining its relevance and popularity among developers worldwide.

In this article, you have learned how to install Java 20 on a stable FreeBSD 14.1 system. With the output of the JAVA program test results above, you have successfully run a JAVA program on FreeBSD 14. I suggest you try other JAVA versions to install on FreeBSD Server.
