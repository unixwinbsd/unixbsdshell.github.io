---
title: FreeBSD How to Install Bugzilla with Apache24 and SSL
date: "2025-11-22 18:45:02 +0000"
updated: "2025-11-22 18:45:02 +0000"
id: how-to-install-bugzilla-with-apache24-and-ssl
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: 
toc: true
comments: true
published: true
excerpt: This article will explain the installation and configuration of Bugzilla on FreeBSD. In this article, we'll configure Bugzilla with Apache24 mod perl and a MySQL database server.
keywords: apache, apache24, bugzilla, install, ssl, openssl, certificate. freebsd, openbsd, unix, bsd
---

Bugzilla, written by `Terry Weissman` in 1998 in the TCL programming language, was found to be very helpful for web developers and system administrators in tracking various bugs in application programs. This overwhelming interest prompted Terry Weissman to refine Bugzilla's capabilities and convert it to PERL and use a MySQL database.

Even more impressive, Bugzilla will provide a report when tracking the bug is complete. Bugzilla reports are written in various formats, including Atom, iCalendor, and others. The iCalendor format is used when using Bugzilla's time tracking feature. Bugzilla also offers a variety of formats, including a printable format containing details of all bugs and a CSV format that can be used to import the bug list into a spreadsheet.

This article will explain the installation and configuration procedures for Bugzilla on FreeBSD. In this article, we will configure Bugzilla with Apache24 mod perl and a MySQL database server.

## 1. Configure Apache24 using the Perl mod

To run Bugzilla with the Apache24 web server, you must use the Perl mod. For a complete discussion of how to install Apache24 in Perl mode, you can read our previous article on installing Apache24 on FreeBSD.

In this article, we will focus on configuring Apache24 for Bugzilla, and we will assume that you have already enabled Apache24 with the Perl mod. First, enable the Apache24 modules required by Bugzilla. Open the `/usr/local/etc/httpd.conf` file and remove the **"#"** symbol from the following modules.

```console
LoadModule authn_socache_module libexec/apache24/mod_authn_socache.so
LoadModule socache_shmcb_module libexec/apache24/mod_socache_shmcb.so
LoadModule expires_module libexec/apache24/mod_expires.so
LoadModule ssl_module libexec/apache24/mod_ssl.so
LoadModule cgi_module libexec/apache24/mod_cgi.so
LoadModule rewrite_module libexec/apache24/mod_rewrite.so
```

Let's continue by creating an SSL directory, which will be used to store the SSL files. Here's how to create an SSL certificate for Bugzilla.

```console
root@ns1:~ # cd /usr/local/etc/apache24/
root@ns1:/usr/local/etc/apache24 # mkdir ssl && cd ssl
root@ns1:/usr/local/etc/apache24/ssl # openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/etc/apache24/ssl/bugzilla.key -out /usr/local/etc/apache24/ssl/bugzilla.crt
Generating a RSA private key
.....................................................................................+++++
...................................+++++
writing new private key to '/usr/local/etc/apache24/ssl/bugzilla.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:id
State or Province Name (full name) [Some-State]:jawa barat
Locality Name (eg, city) []:bekasi
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mediatama
Organizational Unit Name (eg, section) []:networking
Common Name (e.g. server FQDN or YOUR name) []:unixexplore.com
Email Address []:datainchi@gmail.com
root@ns1:/usr/local/etc/apache24/ssl # chmod 600 *
```

Once the SSL certificate has been successfully created, proceed to edit the `/usr/local/etc/apache24/extra/httpd-vhosts.conf` file. Delete all contents of `/usr/local/etc/apache24/extra/httpd-vhosts.conf` and replace them with the following script.

```console
<VirtualHost *:80>
ServerName unixexplore.com
ServerAlias www.unixexplore.com
DocumentRoot /usr/local/www/bugzilla
Redirect permanent / https://unixexplore.com/
</VirtualHost>


Listen 443
<VirtualHost _default_:443>
ServerName unixexplore.com
DocumentRoot /usr/local/www/bugzilla
ErrorLog "/var/log/mybugzilla.me-error_log"
CustomLog "/var/log/mybugzilla.me-access_log" common

SSLEngine On
SSLCertificateFile /usr/local/etc/apache24/ssl/bugzilla.crt
SSLCertificateKeyFile /usr/local/etc/apache24/ssl/bugzilla.key

<Directory "/usr/local/www/bugzilla">
AddHandler cgi-script .cgi
Options +ExecCGI
DirectoryIndex index.cgi index.html
AllowOverride Limit FileInfo Indexes Options
Require all granted
</Directory>
</VirtualHost>
```

The server name corresponds to the domain name on your FreeBSD server. Then, enable the vhost mod in the `/usr/local/etc/apache24/httpd.conf` file. Remove the "#" in the following script.

```yml
LoadModule vhost_alias_module libexec/apache24/mod_vhost_alias.so
Include etc/apache24/extra/httpd-vhosts.conf
```

## 2. How to Create a Bugzilla Database

After configuring Apache24, continue by creating a Bugzilla database. In this article, we will create a Bugzilla database using MySQL Server 8. We will not explain how to install MySQL Server 8. You can read the previous article explaining how to configure MySQL Server on FreeBSD, ["Building MySQL and MariaDB on OpenBSD - Installation and Configuration"](https://unixwinbsd.site/openbsd/tutorilas-mariadb-installation-configuration/).

This allows Bugzilla to be used alongside MySQL Server for new MySQL users. This also increases the security of Bugzilla users, as using the MySQL root user makes them vulnerable to intruders.

We will use the SQL GRANT command to create the `"Bugzilla"` user. This command also restricts the "Bugzilla" user from operating within the database and only allows the account to connect from "localhost." The following explains how to create a Bugzilla database using MySQL Server version 8.

```console
root@ns1:~ # mysql -u root -p -e "create database bugzilla_database"
Enter password: router
root@ns1:~ # mysql -u root -p -e "show databases"
Enter password: router
+--------------------+
| Database           |
+--------------------+
| bugdb              |
| bugzilla_database  |
| bugzilla_demo      |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

The above script creates the `"bugzilla_database"` database, and router is the MySQL Server root password on my FreeBSD machine. Once the Bugzilla database is created, continue with the following script.

```console
root@ns1:~ # mysql -u root -p
Enter password: router
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 14
Server version: 8.0.33 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> create user 'userzilla'@'localhost' IDENTIFIED BY 'userzilla@123';
Query OK, 0 rows affected (0.05 sec)

root@localhost [(none)]> grant all privileges on bugzilla_database.* to 'userzilla'@'localhost';
Query OK, 0 rows affected (0.04 sec)

root@localhost [(none)]> flush privileges;
Query OK, 0 rows affected (0.01 sec)

root@localhost [(none)]> \q
Bye
```

The script above creates a Bugzilla user with the username `'userzilla'@'localhost'` and the password `'userzilla@123'`.

## 3. Installing and Configuring Bugzilla

Now that Apache24 is configured and we've created the Bugzilla database, we can proceed to install and configure the Bugzilla program. Here's how to install Bugzilla on FreeBSD.

```console
root@ns1:~ # cd /usr/ports/devel/bugzilla50
root@ns1:/usr/ports/devel/bugzilla50 # make install clean
====> Compressing man pages (compress-man)
===>  Installing for bugzilla50-5.0.4_3
===>  Checking if bugzilla50 is already installed
===>   Registering installation for bugzilla50-5.0.4_3
Installing bugzilla50-5.0.4_3...
  Bugzilla has now been installed.  To quick setup you have to:

  1. Create database user who has rights on bugs database manipulation
     by following mysql commands (for MySQL 4.0 or later):

     GRANT SELECT, INSERT, UPDATE, DELETE, INDEX, ALTER, CREATE, LOCK TABLES,
           CREATE TEMPORARY TABLES, DROP, REFERENCES
	   ON <database>.* TO <dbuser>@<host>
	   IDENTIFIED BY '<password>';
     FLUSH PRIVILEGES;

     where <database> is a bugs database name; <dbuser> is a bugs database
           owner; <host> is a host there bugzilla is being setup;
           <password> is a database owner's password;

  2. Change working directory to /usr/local/www/bugzilla
  3. Run "./checksetup.pl" script as root user
  4. Read output carefully and follow all instructions

  For more complete database setup and post-installation instructions
  and security tips/notes please read "Bugzilla Guide" in
  /usr/local/share/doc/bugzilla/en/html/ (chapter 2: "Installing Bugzilla")
For upgrades:
  0. Back up your data.

  1. Run the command inside /usr/local/www/bugzilla
      find . -mindepth 2 -name .htaccess -exec rm -f {} \;

  2. Run "./checksetup.pl" inside /usr/local/www/bugzilla.  You may need to
     run it several times.

  3. Restart your Web server, especially if you're using mod_perl: this
     will save you from a number of troubles.
```

After that, we continue by installing `p5-DBD-mysql`.

```yml
root@ns1:~ # cd /usr/ports/databases/p5-DBD-mysql
root@ns1:/usr/ports/databases/p5-DBD-mysql # make install clean
```

After that, open the file `/usr/local/www/bugzilla/localconfig` then edit the following script according to the Bugzilla database that we have created with MySql Server above.

```console
$db_host = 'localhost';
$db_name = 'bugzilla_database';
$db_user = 'userzilla'@'localhost';
$db_pass = 'userzilla@123';
```

For the other scripts in the `/usr/local/www/bugzilla/localconfig` file, leave them as default and don't change anything except the script above. Then, install the Bugzilla module. Here's how.

```yml
root@ns1:~ # cd /usr/local/www/bugzilla
root@ns1:/usr/local/www/bugzilla # /usr/local/bin/perl install-module.pl --all
```

Next is a perl module testing program for Bugzilla.

```yml
root@ns1:/usr/local/www/bugzilla # ./checksetup.pl
```

The final step is to `reboot/restart` the computer.

```yml
root@ns1:~ # reboot
```

Bugzilla is a highly efficient and effective web utility used for bug tracking. However, it still has some room for improvement. This tool is widely used by developers and system administrators worldwide. Even well-known companies like Wikipedia and Mozilla use this web-based bug tracking tool.

However, it also has many drawbacks. With increasing competition among web development tools, Bugzilla has long been outdated. With its outdated user interface, developers and software engineers no longer favor it. Many new features easily accessible in other bug tracking tools are not available in Bugzilla.



2025-11-22-how-to-install-bugzilla-with-apache24-and-ssl.md

<img alt="nextcloud" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ '/img/oct-25/oct-25-126.jpg' | relative_url }}">
<img alt="nextcloud" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ '/img/oct-25/oct-25-126.jpg' | absolute_url }}">


tags: "UnixShell WebServer DNSServer SysAdmin Anonymous DataBase"

keywords


tags: "UnixShell"
=================================================================
  - freebsd
  - openbsd
  - networking
  - linux
  - blogpost