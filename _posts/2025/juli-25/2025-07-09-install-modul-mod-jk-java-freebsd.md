---
title: Freebsd Install mod jk Java module For Apache Tomcat
date: "2025-07-08 08:45:23 +0100"
updated: "2025-07-08 08:45:23 +0100"
id: install-modul-mod-jk-java-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The Apache mod_jk module bridges the Apache Web Server and the Tomcat server. Web requests over port 80 are handled by Apache, and Java Servlet and JSP requests are then forwarded to the appropriate host, such as the Tomcat server
keywords: module, mod jk, swoole, php, apache. freebsd, framework, web server, openjdk, java
---

Mod_jk is an Apache module or connector that connects the Apache Tomcat servlet container with web servers such as Apache, IIS, etc. Mod_jk is a complete replacement for the legacy mod_jser module, which handles communication between Tomcat and HTTP servers using the Apache JServ protocol. The Apache mod_jserv module is the legacy bridge between Java and Apache.

The Apache mod_jk module bridges the Apache Web Server and the Tomcat server. Web requests over port 80 are handled by Apache, and Java Servlet and JSP requests are then forwarded to the appropriate host, such as the Tomcat server. This article will explain how to configure mod_jk with the Apache http server and Tomcat. The Apache Tomcat connector allows the Apache httpd server to be used as a front-end for Apache Tomcat applications.

To run Tomcat and Apache simultaneously, Apache needs to load an "adapter" module, which uses a specific protocol, such as the Apache JServ Protocol (AJP), to communicate with Tomcat over a different TCP port (port 8009 is the default configuration in the server.xml file under the Tomcat server). When the Apache server receives an HTTP request, it checks whether the request belongs to the Tomcat server and if YES, it forwards it to Tomcat.

AJP is a wire protocol and an optimized version of the HTTP protocol that allows standalone http servers, such as Apache, to communicate with Tomcat. For years, Apache http servers have been significantly faster than Tomcat at serving static content. The idea here is to let the Apache http server serve static content whenever possible, but use the Apache http server as a proxy to the Tomcat server for Tomcat-related content.

The Apache Tomcat Connector project is part of the Tomcat project and provides web server plugins for connecting web servers with Tomcat and other backends. Supported web servers are:

- Apache HTTP Server with a plugin (module) called mod_jk.
- Microsoft IIS with a plugin (extension) called ISAPI redirector (or simply redirector).
- iPlanet Web Server with a plugin called NSAPI redirector. iPlanet Web Server was previously known by various names, including Netscape Enterprise Server, SunOne Web Server, and Sun Enterprise System web server.

In all cases, the plugin uses a special protocol called the Apache JServ Protocol, or simply AJP, to connect to the backend. Known backends that support AJP are Apache Tomcat, Jetty, and JBoss. Although there are three versions of the protocol: ajp12, ajp13, and ajp14, most installations use only ajp13. The older ajp12 does not use persistent connections and is deprecated, while the newer ajp14 version is still experimental. Sometimes ajp13 is called AJP 1.3 or AJPv13, but we prefer to use the name ajp13.

Most plugin features are the same for all web servers. Some details vary by web server. The documentation and configuration are divided into general and web server-specific sections.


## 1. Installing mod_jk on FreeBSD
mod_jk is part of the `"www"` port system on FreeBSD. Installing mod_jk is very easy. Simply type the command below to install mod_jk.

```console
root@ns1:~ # cd /usr/ports/www/mod_jk
root@ns1:/usr/ports/www/mod_jk # make install clean
```

Now, after the `mod_jk` module is installed, now check whether the module is active or not. The `mod_jk` module is in the `"httpd.conf"` file, open the `/usr/local/etc/apache24/httpd.conf` file and look for the script `"LoadModule jk_module libexec/apache24/mod_jk.so"`. To activate it, remove the `"#"` sign in front of the script, if the `"#"` sign is not there, it means the `mod_jk` module can be used.


## 2. Configure mod_jk
Although `mod_jk` is ready to use, the module is not yet active, so how do I activate it? Here are the steps to activate the `mod_jk` module.


### a. Create a mod_jk.conf file

We will place the `mod_jk.conf` file in the `/usr/local/etc/apache24/Includes` folder. In the `/usr/local/etc/apache24/Includes/mod_jk.conf` file, insert the script below.

```console
root@ns1:~ # cd /usr/local/etc/apache24
root@ns1:/usr/local/etc/apache24 # touch Includes/mod_jk.conf
root@ns1:/usr/local/etc/apache24 # chmod +x Includes/mod_jk.conf
root@ns1:/usr/local/etc/apache24 # ee Includes/mod_jk.conf
# Replace jsp-hostname with the hostname of your JSP server, as
# specified in workers.properties.
#
<IfModule mod_jk.c>
	JkWorkersFile etc/apache24/workers.properties
	JkLogFile  /var/log/jk.log
	JkShmFile  /var/log/jk-runtime-status
	JkLogLevel error

	# Sample JkMounts.  Replace these with the paths you would
	# like to mount from your JSP server.
	JkMount /*.jsp jsp-hostname
	JkMount /servlet/* jsp-hostname
	JkMount /examples/* jsp-hostname
</IfModule>
```
The script above is used to create the file `/usr/local/etc/apache24/Includes/mod_jk.conf`, and the orange script is the CONTENTS of the file `/usr/local/etc/apache24/Includes/mod_jk.conf`.

Next, we create a file named `"workers.properties"` which we will place in the `/usr/local/etc/apache24` folder. Follow the steps below to create the script in the `/usr/local/etc/apache24/workers.properties` file. In this article, use the **"ee"** editor to include the script in the `/usr/local/etc/apache24/workers.properties` file.

```console
root@ns1:/usr/local/etc/apache24 # touch /usr/local/etc/apache24/workers.properties
root@ns1:/usr/local/etc/apache24 # chmod +x /usr/local/etc/apache24/workers.properties
root@ns1:/usr/local/etc/apache24 # ee /usr/local/etc/apache24/workers.properties
# Incredibly simple workers.properties file, intended for connecting
# to one host, via AJP13.  See the tomcat documentation for
# information on more exotic configuration options.
#
# Change jsp-hostname to the hostname of your JSP server.
#
worker.list=jsp-hostname

worker.jsp-hostname.port=8009
worker.jsp-hostname.host=jsp-hostname
worker.jsp-hostname.type=ajp13
worker.jsp-hostname.lbfactor=1
root@ns1:/usr/local/etc/apache24 # chown -R www:www /usr/local/etc/apache24/workers.properties
```
Now we create a log file and name the user group `"www:www"`.

```console
root@ns1:~ # touch /var/log/jk.log
root@ns1:~ # touch /var/log/jk-runtime-status
root@ns1:~ # chown -R www:www /var/log/jk.log
root@ns1:~ # chown -R www:www /var/log/jk-runtime-status
```
The next step is to enable the `mod_jk` module on the Tomcat server. Open the `/usr/local/apache-tomcat-9.0/conf/server.xml` file and find the following script.

```
<!-- dan -->
    <Connector protocol="AJP/1.3"
               address="192.168.5.2"
               port="8009"
               redirectPort="8443"
               maxParameterCount="1000"
               />
    -->
```
To activate the mod_jk module, remove the "<!--" and "-->" signs in the script, so the result will be like below.

```
<Connector protocol="AJP/1.3"
               address="192.168.5.2"
               port="8009"
               redirectPort="8443"
               maxParameterCount="1000"
               />
```
Then we restart the Apache24 application.

```console
root@ns1:~ # service apache24 restart
root@ns1:~ # service tomcat9 restart
```
This tutorial only shows a small part of how to configure and use the mod_jk module on Apache24 and Tomcat9 servers. You can learn more from the official documentation on both applications' websites.

