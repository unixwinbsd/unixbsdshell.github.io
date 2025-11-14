---
title: IntelliJ IDEA Java Setup on FreeBSD Desktop
date: "2025-05-01 19:01:15 +0100"
updated: "2025-05-01 19:01:15 +0100"
id: intellij-idea-java-openjdk-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/oct-25-0007.jpg
toc: true
comments: true
published: true
excerpt: IntelliJ IDEA, written in Java and Kotlin, released its first version in January 2011, and immediately became the first IDE to develop Java-based applications. This IDE supports advanced code navigation and integrated refactoring capabilities.
keywords: intellij, idea, ide, java, openjdk, jre, freebsd, desktop
---

For those of you who like coding with Java or Kotlin, you must be familiar with this great IDE. IntelliJ IDEA, an IDE developed by Jetbrains. IntelliJ IDEA is available in 2 (two) versions, namely the Community Edition version with the Apache 2 Licensed license that we can use for free and the Ultimate Edition version for commercial use.

IntelliJ IDEA, written in Java and Kotlin, released its first version in January 2011, and immediately became the first IDE to develop Java-based applications. This IDE supports advanced code navigation and integrated refactoring capabilities.

In general, an IDE provides several features such as a text editor that we will use to write code, tools to automate the build process of the program we create and also a debugger that will help us detect and correct errors in the program.


<br/>
{% lazyload data-src="/img/oct-25/oct-25-0007.jpg" src="/img/oct-25/oct-25-0007.jpg" alt="IntelliJ IDEA Java Setup on FreeBSD Desktop" %}
<br/>


## 1. IntelliJ IDEA Features
In general, an IDE can provide many features such as a text editor that can be used to write some code. Tools that are intended to automate the process of creating programs that you have created and debuggers can help you detect and fix many errors in the program.

In addition, IntelliJ IDEA also still has various more advanced features. This feature can help you complete several programs that are being developed quickly. Here are the various features that you need to know:

### a. Intelligent Code Editor
IntelliJ IDEA provides an editor that is used to support various types of code completion, which is a feature that can help you write code quickly. The IDE is able to analyze the context of the code that has been written, thus providing direction and completion of correct code typing.

Another thing is that IntelliJ IDEA can support integrated refactoring, making it easier for you to minimize errors that can occur when changes occur to the project you are developing.

### b. Decompiler
In addition, IntelliJ IDEA has a decompiler with a default breakthrough used for Java Classes and is quite widely used to see what is in the library without having to have the code from the source. Using this method generally requires a third-party plugin, but you can use IntelliJ IDEA directly.

### c. Build Tools
Build tools, software that we will use to help automate processes such as packaging the project we will develop, running tests, and further development. IntelliJ IDEA supports several build tools such as Maven, Gradle, Ant, SBT, NPM, Webpack, Grunt, Gulp, and other build tools that are well integrated with each other.

### d. Shortcuts
To support productivity in its use, IntelliJ IDEA provides shortcuts related to navigation, editing, refactoring, and other activities in IntelliJ IDEA. The following are some commonly used shortcuts:

#### d.1. Ctrl + Ctrl (perform any action)
The shortcuts below are used to run commands, such as opening a project, running commands on the command line, bringing up the configuration window, and many other commands.

#### d.2. Shift + Shift (search)
If you want to search for a project that you are going to do or are working on, for example searching for a project file, you can use this shortcut.

#### d.3. Ctrl + E (Latest File)
This command is used to display previously opened files in the form of a list.

#### d.4. Ctrl + Space (code completion)
This command is used in fast code completion.

#### d.5. Ctrl + D (duplicate code)
This command aims to duplicate a line of code, so you don't have to copy and paste.

#### d.6. Ctrl + / &Ctrl + Shift + / (Comment block)
This command is used to comment on one or more lines of code. In addition to those mentioned above, there are many more things you can do using shortcuts that can make your activities easier.

#### d.7. Terminal
When running several commands in the terminal, you don't need to switch from the editor. Therefore, Intellij IDEA is also equipped with a built-in terminal with a platform base that can be used, such as Far, Bash, Powershell, and command prompt.


## 2. Why Choose IntelliJ IDEA?
It’s a favorite among Java developers for its rich features, efficient tools, and support for a wide range of languages. Pair it with the Java Development Kit (JDK), and you’ve got a powerhouse for coding.

Even if you’re [new to Linux](https://www.linkedin.com/pulse/intellij-idea-java-setup-freebsd-desktop-iwan-setiawan-o7t4c)
, setting up IntelliJ can be smoother than you might think. With a few commands, users can [get the IDE ready](https://inventyourshit.com/setting-up-the-environment-writing-our-first-program/) to tackle projects of any size. Sometimes taking that first step makes all the difference, especially when you’re eager to build something amazing.

In this modern IT world, developers and programmers can’t rely on text editors or notepads for writing code. A suitable IDE that provides a comprehensive suite of code editors, testing, and debugging tools is needed. IDEs simplify the coding process and increases the productivity of developers. 


## 3. IntelliJ IDEA Installation
The main requirement for installing IntelliJ IDEA on FreeBSD is that Java applications must be installed on your FreeBSD server. Read the previous article about [How to install Java OpenJDK on FreeBSD 14](https://unixwinbsd.site/en/freebsd/2025/02/14/installing-java-openjdk20-on-freebsd14.1stable/).

In this article we will install IntelliJ IDEA using the FreeBSD system port.

```console
root@ns7:~ # cd /usr/ports/java/intellij
root@ns7:/usr/ports/java/intellij # make install clean
```
On FreeBSD servers, IntelliJ IDEA can only be run with FreeBSD Desktop Gnome or KDE. So, you can use GhostBSD or hellosystem.

Recommended system requirements for running IntelliJ IDEA according to JetBrains:

- GNOME or KDE desktop.
- 1 GB RAM minimum, 2 GB RAM recommended.
- 300 MB hard disk space + at least 1 GB for caches.
- 1024x768 minimum screen resolution.
- Java17 or higher.

You do not need to install Java to run IntelliJ IDEA because JetBrains Runtime is included with the IDE (based on JRE 17). However, to develop Java applications, a stand-alone JDK is required.