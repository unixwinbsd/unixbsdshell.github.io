---
title: How to Install mod_jk Module on Freebsd for Apache Tomcat
date: "2025-05-21 12:05:35 +0100"
id: install-mod-java-apache-tomcat
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
excerpt: Mod_jk is a complete replacement for the old mod_jser module that handles communication between Tomcat and HTTP servers using the Apache JServ protocol. The Apache mod_jserv module is the old bridge between Java and Apache.
keywords: mod_jk, modul, java, apache, tomcat, install, freebsd, openbsd, web, http, https
---

Mod_jk is an Apache module or connector that connects the Apache Tomcat servlet container with a web server such as Apache, IIS, etc. Mod_jk is a complete replacement for the old mod_jser module that handles communication between Tomcat and HTTP servers using the Apache JServ protocol. The Apache mod_jserv module is the old bridge between Java and Apache.

The Apache mod_jk module is a bridge between the Apache Web Server and the Tomcat Server. Web requests over port 80 are handled by Apache and then Java Servlet and JSP requests are forwarded to the appropriate place such as the Tomcat server. This article will explain how to configure mod_jk with Apache http server and Tomcat. The Apache Tomcat connector allows the use of the Apache httpd server as a front-end for Apache Tomcat applications.

To run Tomcat and Apache simultaneously, Apache needs to load an "adapter" module, which uses a specific protocol, such as the Apache JServ Protocol (AJP), to communicate with Tomcat, over another TCP port (port 8009 is the default configuration in the server.xml file under the Tomcat server). When Apache server receives an HTTP request, it checks whether the request belongs to Tomcat server and if YES, it forwards it to Tomcat.
