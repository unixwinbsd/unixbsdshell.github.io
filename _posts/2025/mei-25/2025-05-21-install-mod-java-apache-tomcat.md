---
title: How to Install mod_jk Module on Freebsd for Apache Tomcat
date: "2025-05-21 12:05:35 +0100"
updated: "2025-05-21 12:05:35 +0100"
id: install-mod-java-apache-tomcat
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Mod_jk is a complete replacement for the old mod_jser module that handles communication between Tomcat and HTTP servers using the Apache JServ protocol. The Apache mod_jserv module is the old bridge between Java and Apache.
keywords: mod_jk, modul, java, apache, tomcat, install, freebsd, openbsd, web, http, https
---

Mod_jk is an Apache module or connector that connects the Apache Tomcat servlet container with a web server such as Apache, IIS, etc. Mod_jk is a complete replacement for the old mod_jser module that handles communication between Tomcat and HTTP servers using the Apache JServ protocol. The Apache mod_jserv module is the old bridge between Java and Apache.

The Apache mod_jk module is a bridge between the Apache Web Server and the Tomcat Server. Web requests over port 80 are handled by Apache and then Java Servlet and JSP requests are forwarded to the appropriate place such as the Tomcat server. This article will explain how to configure mod_jk with Apache http server and Tomcat. The Apache Tomcat connector allows the use of the Apache httpd server as a front-end for Apache Tomcat applications.

To run Tomcat and Apache simultaneously, Apache needs to load an "adapter" module, which uses a specific protocol, such as the Apache JServ Protocol (AJP), to communicate with Tomcat, over another TCP port (port 8009 is the default configuration in the server.xml file under the Tomcat server). When Apache server receives an HTTP request, it checks whether the request belongs to Tomcat server and if YES, it forwards it to Tomcat.

AJP is a wire protocol and an optimized version of the HTTP protocol, which allows standalone http servers, such as Apache, to communicate with Tomcat. For many years, Apache http servers have been much faster than Tomcat at serving static content. The idea here is to let Apache http servers serve static content when possible, but use Apache http servers as a proxy to Tomcat servers for Tomcat related content.

The Apache Tomcat Connector project is part of the Tomcat project and provides web server plugins for connecting web servers to Tomcat and other backends. The supported web servers are:
- Apache HTTP Server with a plugin (module) called mod_jk.
- Microsoft IIS with a plugin (extension) called ISAPI redirector (or simply redirector).
- iPlanet Web Server with a plugin called NSAPI redirector. iPlanet Web Server was previously known by various names, including Netscape Enterprise Server, SunOne Web Server, and Sun Enterprise System web server.

In all cases, the plugin uses a special protocol called Apache JServ Protocol or simply AJP to connect to the backend. Known backends that support AJP are Apache Tomcat, Jetty, and JBoss. Although there are 3 versions of the protocol, ajp12, ajp13, ajp14, most installations only use ajp13. The older ajp12 does not use persistent connections and is deprecated, the newer ajp14 version is still experimental. Sometimes ajp13 is called AJP 1.3 or AJPv13, but we mostly use the name ajp13.

Most of the plugin features are the same for all web servers. Some details vary by web server. The documentation and configuration are divided into general sections and web server specific sections.

## 1. Installing mod_jk on FreeBSD

mod_jk is part of the "www" port system on FreeBSD. Installing mod_jk is very easy. We just type the command below to install mod_jk.

```
root@ns1:~ # cd /usr/ports/www/mod_jk
root@ns1:/usr/ports/www/mod_jk # make install clean
```

Now, after the mod_jk module is installed, now check whether the module is active or not. The mod_jk module is in the "httpd.conf" file, open the /usr/local/etc/apache24/httpd.conf file and look for the "LoadModule jk_module libexec/apache24/mod_jk.so" script. To activate it, remove the "#" sign in front of the script, if the "#" sign is not there, it means the mod_jk module can be used.

## 2. Mod_jk configuration

Although mod_jk can be used, the module is not yet active, so how do I activate it? Here are the steps on how to activate the mod_jk module.

### 2.1. Create a mod_jk.conf file

We will place the mod_jk.conf file in the /usr/local/etc/apache24/Includes folder, in the /usr/local/etc/apache24/Includes/mod_jk.conf file enter the script below.

```
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

The script above is used to create the /usr/local/etc/apache24/Includes/mod_jk.conf file, and the orange script is the CONTENTS script of the /usr/local/etc/apache24/Includes/mod_jk.conf file.

After that, we create a file named "workers.properties" which we will place in the /usr/local/etc/apache24 folder. Follow the steps below to create a script in the /usr/local/etc/apache24/workers.properties file. In this article, use the "ee" editor to include the script in the /usr/local/etc/apache24/workers.properties file.

```
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

Now we create a log file and name the user group "www:www".

```
root@ns1:~ # touch /var/log/jk.log
root@ns1:~ # touch /var/log/jk-runtime-status
root@ns1:~ # chown -R www:www /var/log/jk.log
root@ns1:~ # chown -R www:www /var/log/jk-runtime-status
```

The next step is to enable the mod_jk module on the Tomcat server. Open the /usr/local/apache-tomcat-9.0/conf/server.xml file, and find the following script.

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

```
root@ns1:~ # service apache24 restart
root@ns1:~ # service tomcat9 restart
```

This tutorial only shows a small part of how to configure and use the mod_jk module on Apache24 and Tomcat9 servers. You can learn more from the official documentation on the websites of both applications.
