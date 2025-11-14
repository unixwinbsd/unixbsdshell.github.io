---
title: With FreeBSD and JAVA Kroki Making Diagrams Becomes Easier
date: "2025-11-05 09:21:30 +0000"
updated: "2025-11-05 09:21:30 +0000"
id: java-kroki-making-diagrams-becomes-easier
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-008.jpg
toc: true
comments: true
published: true
excerpt: In this article, we will assume that you have already installed JAVA on FreeBSD, so we will proceed directly to installing the JAVA libraries that will be used to run Kroki.
keywords: freebsd, java, openjdk, kroki, diagram, making, jdk, jre, eaasier
---

A free Java library allows software developers to create diagrams from textual descriptions. Kroki is an open-source, MIT-licensed unified Java API that makes it easy for software developers to create diagrams from textual descriptions in their Java applications. Kroki is a highly stable, unified API for all diagramming libraries that can be used anywhere.

The Kroki library follows a modular architecture, providing many different modules, such as a Java web server that acts as a gateway, the Umlet Java API for creating diagrams, the Node.js CLI, and more.

Kroki also supports BlockDiag (BlockDiag, SeqDiag, ActDiag, NwDiag, PacketDiag, RackDiag), BPMN, Bytefield, C4 (with PlantUML), D2, DBML, Ditaa, Erd, Excalidraw, GraphViz, Mermaid, Nomnoml, Pikchr, PlantUML, Structurizr, SvgBob, Symbolator, TikZ, UMLet, Vega, Vega-Lite, WaveDrom, and WireViz.

## 1. Kroki Features

The Kroki library boasts excellent performance and speed. You can easily interact with the library using any HTTP client. The library provides an HTTP API for creating diagrams from textual descriptions and can handle GET and POST requests.

Kroki supports diagram encoding and allows users to use the deflate + base64 algorithm with GET requests.

<br/>
<img alt="format java kroki" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-008.jpg' | relative_url }}">
<br/>

With FreeBSD and Java, Kroki Makes Creating Diagrams Easier:
- **Simple:** Kroki provides a unified API for all diagramming libraries.
- **Fast:** Built using a modern architecture, Kroki offers great performance.
- **Ready to use:** The diagramming library is written in various languages: Haskell, Python, JavaScript, Go, PHP, Java.
- **Free & Open Source:** All code is available on GitHub.

## 2. Starting Kroki on FreeBSD

To run Kroki on FreeBSD, you must first install Java. Read the previous article on installing Java on FreeBSD.

[Installing and Configuring Java OpenJDK 20 on FreeBSD 14](https://unixwinbsd.site/freebsd/installing-configuring-java-openjdk17-freebsd/)

In this article, we will assume that you have already installed Java on FreeBSD, so we will proceed directly to installing the Java libraries that will be used to run Kroki.

```console
root@ns7:~ # pkg install graphviz erd svgbob
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
The following 3 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
        erd: 3.0.6_6
        graphviz: 9.0.0
        svgbob: 0.7.1_6

Number of packages to be installed: 3

The process will require 9 MiB more space.
820 KiB to be downloaded.

Proceed with this action? [y/N]: y
```

You can also create a manual Kroki installation, customizing it to your needs. To do this, you'll need to manually install the Kroki gateway server as a standalone executable jar file, install any diagramming libraries you want to use, and then run the gateway server jar file. Read the full [Kroki Installation Guide](https://docs.kroki.io/kroki/setup/install/).

```yml
mkdir -p root@ns7:~ # mkdir -p ~/kroki-server
root@ns7:~ # cd ~/kroki-server
root@ns7:~/kroki-server #
```
<br/>
```yml
root@ns7:~/kroki-server # pwd
/root/kroki-server
```

After we have finished creating the Kroki folder, we continue by downloading the Kroki file from Github.

```console
root@ns7:~/kroki-server # fetch https://github.com/yuzutech/kroki/releases/download/v0.23.0/kroki-standalone-server-v0.23.0.jar
kroki-standalone-server-v0.23.0.jar                     16 MB 6184 kBps    03s
<br/>

```console
root@ns7:~/kroki-server # file kroki-standalone-server-v0.23.0.jar
kroki-standalone-server-v0.23.0.jar: Java archive data (JAR)
```

We started running the Kroki server.

```yml
root@ns7:~/kroki-server # java -jar kroki-server-v0.16.0.jar
```

The above command will open the Kroki web server on port 8080. You can change the port to suit your FreeBSD system.

Using a web browser, navigate to `http://localhost:8000/`.

Kroki's advantage is that it also provides an HTTP API for creating diagrams, accessible using tools like cURL. Give Kroki a try for some fun diagramming!.
