---
title: Using Java Scala on FreeBSD
date: "2025-11-07 10:29:51 +0000"
updated: "2025-11-07 10:29:51 +0000"
id: using-java-scala-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-011.jpg
toc: true
comments: true
published: true
excerpt: On FreeBSD, it is very difficult to install Scala using the ports system, so we simply use the FreeBSD PKG package. Before installing Scala, ensure that its dependencies are installed.
keywords: java, openjdk, scala, kroki, maven, tomcat, javascript, code, coding
---

Scala is a general-purpose computer programming language that supports both object-oriented and functional programming styles on a larger scale. Scala is a powerful static programming language influenced by the Java programming language.

Scala is a pure object-oriented programming language that also provides support for functional programming approaches. Scala programs can be converted to bytecode and run on the JVM (Java Virtual Machine).

One of the best similarities between Scala and Java is that you can code in Scala in the same way as you code in Java. Scala stands for Scalable language. This language also provides a JavaScript runtime.

Scala is heavily influenced by Java and several other programming languages ​​such as Lisp, Haskell, Pizza, etc. Scala has become one of the most popular programming languages ​​among developers and continues to evolve with current technology.

Scala is a functional object hybrid language with several strengths and advantages:

- Scala relies on the functional principles of Haskell and ML, without abandoning the heavy burden of familiar object-oriented concepts that Java programmers love so much. As a result, Scala manages to combine the best of both worlds into one, providing significant advantages without sacrificing the simplicity we expect.
- Scala compiles to Java bytecode, meaning it runs on the JVM. In addition to your ability to continue to take full advantage of Java as a well-developed open-source ecosystem, Scala can be integrated into existing information spaces (environments) without migration effort.
- Scala was developed by Martin Odersky, perhaps better known in the Java community for the Pizza and GJ languages, the latter being a working prototype for generics in Java 5. Scala has a sense of "seriousness"; this language wasn't created on a whim, and it won't be abandoned.

<br/>
<img alt="Java Scala On FreeBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-011.jpg' | relative_url }}">

## 1. How to Install Scala

Scala runs on the Java programming language, so you'll need JDK 1.8 or higher installed to proceed with the Scala installation. Since you're here to learn Scala, I'm assuming you already have Java installed on your system. Installing Scala on Linux, Ubuntu, macOS, or any other Unix-based system is the same, so the steps below will work for any Unix-based system.

As a first step, we'll check the Java version on your FreeBSD server. This is very useful and ensures that your FreeBSD server has Java installed.

```console
root@ns7:~ # java -version
openjdk version "17.0.9" 2023-10-17
OpenJDK Runtime Environment (build 17.0.9+9-1)
OpenJDK 64-Bit Server VM (build 17.0.9+9-1, mixed mode, sharing)
```

Installing Scala via the ports system is very difficult on FreeBSD, so we simply use the FreeBSD PKG package. Before installing Scala, ensure the Scala dependencies are installed. The following dependencies are installed first.

```yml
root@ns7:~ # pkg install devel/coursier
root@ns7:~ # pkg install devel/sbt
root@ns7:~ # pkg install boehm-gc
```

Once you have these three dependencies installed, we move on to installing Scala.

```console
root@ns7:~ # pkg install lang/scala
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking integrity... done (0 conflicting)
The following 1 package(s) will be affected (of 0 checked):

Installed packages to be UPGRADED:
        scala: 3.1.0 -> 3.3.1

Number of packages to be upgraded: 1

The process will require 4 MiB more space.

Proceed with this action? [y/N]: y
```

Before you start running Scala on FreeBSD, it's a good idea to check the Scala version first. This is to ensure that Scala is installed on your FreeBSD server.

```console
root@ns7:~ # scala -version
Scala code runner version 3.3.1 -- Copyright 2002-2023, LAMP/EPFL
```

After completing the installation process, any IDE or text editor that supports Java can be used to write Scala Code and Run it in the IDE or Terminal using commands.

```yml
# scalac file_name.scala
# scala class_name
```

## 2. Creating a New Project with Scala

Once you've installed Scala on your system, you're ready to start your Scala programming project. Start by creating a simple "Hello World" program.

Create a text file named "HelloWorld.scala" and a folder called "/var/scala" using Putty and your preferred text editor.

```yml
root@ns7:~ # mkdir -p /var/scala
root@ns7:~ # cd /var/scala
```

We continue by creating the file `"/var/scala/HelloWorld.scala"`.

```console
root@ns7:/var/scala # ee HelloWorld.scala

object HelloWorld {
  def main(args: Array[String]): Unit = {
    println("Hello, Mount Everest!")
  }
}
```

After that, you do the compilation.

```yml
root@ns7:/var/scala # scalac HelloWorld.scala
```

Use the scala command to execute the generated bytecode.

```console
root@ns7:/var/scala # scala HelloWorld.scala
Hello, Mount Everest!
```

## 3. Creating a Scala Project with SBT

Since SBT is a dependency on Scala, we installed it along with the other dependencies. Before using SBT, you should verify that it has been correctly configured. Run the command.

```yml
root@ns7:/var/scala # sbt about
```

This command will display details about the installed SBT version. Okay, now let's move on to setting up an SBT project. Follow these steps.

To start an SBT project, create an SBT directory to store all the SBT files. For example, we'll create an SBT directory in `"/var"` and name it `"/var/sbt-project"`.

```yml
root@ns7:~ # mkdir -p /var/sbt-project
root@ns7:~ # cd /var/sbt-project
```

Initialize SBT in directory.

```console
root@ns7:/var/sbt-project # sbt new scala/scala-seed.g8
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
A minimal Scala project.

name [Scala Seed Project]: projectSBT

Template applied in /var/sbt-project/./projectsbt
```

To perform its tasks, SBT has a file called build.sbt for project configuration. This file is located in your project's `/var/sbt-project/projectsbt` directory. The build.sbt file contains settings such as library dependencies, Scala versions, and other project-specific configurations.

The primary purpose of any build tool is to compile source code. Use this command to compile SBT.

```yml
root@ns7:/var/sbt-project # cd projectsbt
root@ns7:/var/sbt-project/projectsbt # sbt compile
```

Once your project is ready, we'll package it. Use the package command to create a JAR file.

```yml
root@ns7:/var/sbt-project/projectsbt # sbt package
```

The above command will combine the compiled code into a JAR file. After that, continue with the `"sbt clean"` command.

Testing is an essential part of any project. With SBT, you can run tests using the `"sbt test"` command.

```yml
root@ns7:/var/sbt-project/projectsbt # sbt test
```

The final step is to run the SBT project.

```console
root@ns7:/var/sbt-project/projectsbt # sbt run
[info] welcome to sbt 1.9.7 (OpenJDK BSD Porting Team Java 17.0.9)
[info] loading project definition from /var/sbt-project/projectsbt/project
[info] loading settings for project root from build.sbt ...
[info] set current project to projectSBT (in build file:/var/sbt-project/projectsbt/)
[info] compiling 1 Scala source to /var/sbt-project/projectsbt/target/scala-2.13/classes ...
[info] running example.Hello
hello
[success] Total time: 7 s, completed Jan 1, 2024, 9:12:42 PM
```

## 4. Creating a Scala Project with Maven

To create a Scala project with Maven, make sure you have Maven installed on your FreeBSD server. You can read our previous article on how to install Maven on FreeBSD.

Maven is a comprehensive project management tool. It prioritizes convention over configuration, greatly simplifying the creation of "standard" projects, and Maven users can usually understand the structure of other Maven projects simply by looking at the pom.xml (Project Object Model).

If everything went well, you should now have Maven and Scala support on your FreeBSD server. Let's create a new Scala project with Maven, starting with a simple Scala project based on an archetype.

Run the following command to create `a Maven project`.

```yml
root@ns7:/ # cd var
root@ns7:/var # mvn archetype:generate -DgroupId=com.unixwinbsd.blogapp -DartifactId=java-blog-project -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
```

We save the Maven project in the `"/var/java-blog-project"` folder.

We open the `"/var/java-blog-project/pom.xml"` file, then delete all its contents and replace them with the script below.

```console
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.unixwinbsd</groupId>
    <artifactId>java-blog-project</artifactId>
    <version>1.0.0-SNAPSHOT</version>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>

        <java.version>1.8</java.version>
        <scala.version>2.12.6</scala.version>
    </properties>

    <dependencies>
        <!-- scala-maven-plugin determines the Scala version to use from this dependency -->
        <dependency>
            <groupId>org.scala-lang</groupId>
            <artifactId>scala-library</artifactId>
            <version>${scala.version}</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Configure maven-compiler-plugin to use the desired Java version -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>2.4</version>
                <configuration>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                    <archive>
                        <manifest>
                            <mainClass>com.unixwinbsd.blogapp.HelloScala</mainClass>
                        </manifest>
                    </archive>
                </configuration>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>


            <!-- Use build-helper-maven-plugin to add Scala source and test source directories -->
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>build-helper-maven-plugin</artifactId>
                <version>3.0.0</version>
                <executions>
                    <execution>
                        <id>add-source</id>
                        <phase>generate-sources</phase>
                        <goals>
                            <goal>add-source</goal>
                        </goals>
                        <configuration>
                            <sources>
                                <source>src/main/scala</source>
                            </sources>
                        </configuration>
                    </execution>
                    <execution>
                        <id>add-test-source</id>
                        <phase>generate-test-sources</phase>
                        <goals>
                            <goal>add-test-source</goal>
                        </goals>
                        <configuration>
                            <sources>
                                <source>src/test/scala</source>
                            </sources>
                        </configuration>
                    </execution>
                </executions>
            </plugin>

            <!-- Use scala-maven-plugin for Scala support -->
            <plugin>
                <groupId>net.alchim31.maven</groupId>
                <artifactId>scala-maven-plugin</artifactId>
                <version>3.2.2</version>
                <executions>
                    <execution>
                        <goals>
                            <!-- Need to specify this explicitly, otherwise plugin won't be called when doing e.g. mvn compile -->
                            <goal>compile</goal>
                            <goal>testCompile</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

            <!-- scala assembly-->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>2.4</version>
                <configuration>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                </configuration>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

Create a new folder in your maven project.

```yml
root@ns7:/var # cd /var/java-blog-project/src/main
root@ns7:/var/java-blog-project/src/main # mkdir -p scala/com/unixwinbsd/blogapp
```

Create a `HelloScala.scala` file.

```yml
root@ns7:/var/java-blog-project/src/main # cd scala/com/unixwinbsd/blogapp
root@ns7:/var/java-blog-project/src/main/scala/com/unixwinbsd/blogapp # touch HelloScala.scala
root@ns7:/var/java-blog-project/src/main/scala/com/unixwinbsd/blogapp # chmod +x HelloScala.scala
```

In the file `"/var/java-blog-project/src/main/scala/com/unixwinbsd/blogapp/HelloScala.scala"`, enter the following script.

```console
package com.unixwinbsd.blogapp;

object HelloScala extends App {
  println("Hello FreeBSD Scala")
}
```

We run the compile, package, and install commands on the Maven project we have created.

```console
root@ns7:/var/java-blog-project/src/main/scala/com/unixwinbsd/blogapp # cd /var/java-blog-project
root@ns7:/var/java-blog-project # mvn compile && mvn package && mvn install
```

Before we run the Maven Scala project, let's take a look at the `target` folder.

```console
root@ns7:/var/java-blog-project # cd target
root@ns7:/var/java-blog-project/target # ls
archive-tmp                                                     java-blog-project-1.0.0-SNAPSHOT-jar-with-dependencies.jar
classes                                                         java-blog-project-1.0.0-SNAPSHOT.jar
classes.-1515151658.timestamp                                   maven-archiver
generated-sources                                               maven-status
```

The executable JAR file is `java-blog-project-1.0.0-SNAPSHOT-jar-with-dependencies.jar`.

As a final step, we run the Maven Scala project.

```console
root@ns7:/var/java-blog-project/target # java -jar java-blog-project-1.0.0-SNAPSHOT-jar-with-dependencies.jar
Hello FreeBSD Scala
```

With the **"Hello FreeBSD Scala"** screen, you have successfully created a Scala project with Maven.

Congratulations! You have successfully installed Scala with SBT and Maven. You are now ready to start exploring the advanced features and flexibility Scala offers. Happy coding!.
