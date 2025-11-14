---
title: Setting up FreeBSD System Monitoring Tool With Cacti
date: "2025-09-12 08:41:10 +0100"
updated: "2025-09-12 08:41:10 +0100"
id: freebsd-system-monitoring-with-cacti
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Besides being able to maintain Graphs, Data Sources, and Round Robin Archives in a database, Cacti can also handle data collection. Another advantage of Cacti is that it has SNMP support for those who are used to creating traffic graphs with MRTG
keywords: system, monitoring, cacti, server, tools, freebsd, utility
---

Cacti is a complete frontend for RRDTool, it can store all the information needed to create graphs and copy all that information into MySQL Server database tables. Cacti's frontend runs entirely in PHP. Besides being able to maintain Graphs, Data Sources, and Round Robin Archives in a database, Cacti can also handle data collection. Another advantage of Cacti is that it has SNMP support for those who are used to creating traffic graphs with MRTG.

In general, with the help of Cacti you can graph channel usage, HDD partition usage, display resource latency, and much more. So it is very natural that everyone praises Cacti. Because, Cacti is an easy solution for monitoring servers and network devices, allowing you to monitor the status of beautiful graphs at various intervals.

In this article we will look at Cacti as a complete graphics Solution based on RRDTool. The contents of this article will not teach you how to work with Cacti. But it will explain how to install and configure Cacti on a FreeBSD machine, so you can use it to monitor any devices you have on your network.


## 1. System Requirements

- OS: FreeBSD 13.2
- IP address: 192.168.5.2
- Hostname: ns3
- Database: mysql80-server
- PHP version: PHP82
- PHP-FPM
- Web server: apache24
- Dependencies: 
rrdtool php82 php82-ctype php82-filter php82-gd php82-gettext hp82-gmp php82-intl php82-ldap php82-mbstring php82-pcntl php82-pdo php82-pdo_mysql php82-posix php82-session php82-simplexml php82-sockets php82-snmp php82-xml php82-zlib

## 2. Install Dependencies Cacti RRDTool

Cacti runs with a web browser, therefore Cacti requires a web server such as Apache. In order for Cacti to connect with Apache, there are several PHP dependencies that must be installed. These PHP dependencies will connect Cacti with Apache, because almost all Cacti scripts are written in PHP. Run the following command to install PHP Cacti dependencies.

```yml
root@ns3:~ # pkg install php82 php82-ctype php82-filter php82-gd php82-gettext php82-intl php82-ldap php82-mbstring php82-pcntl php82-pdo php82-pdo_mysql php82-posix php82-session php82-simplexml php82-sockets php82-snmp php82-xml php82-zlib php82-gmp
```

As we explained above, Cacti is a RRDTool that is used to monitor all devices on your computer network. Because of this, Cacti needs a utility that can monitor all of our computer network activities. This is where RRDTool kicks in. It lets you log and analyze the data you gather from all kinds of data-sources. The data analysis part of RRDTool is based on the ability to quickly generate graphical representations of the data values collected over a definable time period.

Run the following command to install the RRDTools utility.

```yml
root@ns3:~ # cd /usr/ports/databases/rrdtool
root@ns3:/usr/ports/databases/rrdtool # make install clean
```

## 3. Create the MySQL database, a cacti user, and initialize

Cacti requires a database server, to store all monitoring results information. The monitoring results will be saved by Cacti in a database table which you can call back if necessary. The database commonly used by Cacti is MySQL Server. On the MySQL database server we will create a database, user and password for Cacti.

OK, let's just create a Cacti database, along with a user and password.

```console
root@ns3:/usr/ports/databases/rrdtool # mysql -u root -p
root@localhost [(none)]> CREATE DATABASE `cacti`;
root@localhost [(none)]> CREATE USER 'usercacti'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> FLUSH PRIVILEGES;
```

After that you run the command `"GRANTS"`.

```console
root@localhost [(none)]> GRANT ALL ON `cacti`.* TO 'usercacti'@'localhost';
root@localhost [(none)]> GRANT SELECT ON `mysql`.`time_zone_name` TO 'usercacti'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
```

Run the Import default Cacti database command.

```yml
root@localhost [(none)]> exit;
root@ns3:~ # mysql -u root -p cacti < /usr/local/share/cacti/cacti.sql
```

## 4. Install Cacti

In this section the process of installing Cacti onto the FreeBSD system. This procedure starts after you have just created a cacti database. To install Cacti, we will use the FreeBSD ports system, although the installation process takes a long time, this method is more complete because it includes all the PHP library files. Run the following command to install Cacti.

```yml
root@ns3:~ # cd /usr/ports/net-mgmt/cacti
root@ns3:/usr/ports/net-mgmt/cacti # make install clean
```

All Cacti files from the installation are saved in the `"/usr/local/share/cacti"` directory, copy the files to the `"/usr/local/www"` directory.

```yml
root@ns3:/usr/ports/net-mgmt/cacti # cp -R /usr/local/share/cacti /usr/local/www
```

Run the chown and chmod commands in the `"/usr/local/www"` directory.

```yml
root@ns3:/usr/ports/net-mgmt/cacti # chown -R www:www /usr/local/www/cacti
root@ns3:/usr/ports/net-mgmt/cacti # chmod -R 775 /usr/local/www/cacti
```

Create a `config.php` file by copying from an existing file. Follow the following commands.

```yml
root@ns3:/usr/ports/net-mgmt/cacti # cd /usr/local/www/cacti/include
root@ns3:/usr/local/www/cacti/include # cp -R config.php.sample config.php
```

Open the file you copied, namely `/usr/local/www/cacti/include/config.php`, and look for the script below

```console
$database_type     = 'mysql';
$database_default  = 'cacti';
$database_hostname = 'localhost';
$database_username = 'cactiuser';
$database_password = 'cactiuser';
$database_port     = '3306';
$database_retries  = 5;
$database_ssl      = false;
$database_ssl_key  = '';
$database_ssl_cert = '';
$database_ssl_ca   = '';
$database_persist  = false;
```

Replace the contents of the script above with the Cacti database that you created above.

```console
$database_type     = 'mysql';
$database_default  = 'cacti';
$database_hostname = 'localhost';
$database_username = 'usercacti';
$database_password = 'router123';
$database_port     = '3306';
$database_retries  = 5;
$database_ssl      = false;
$database_ssl_key  = '';
$database_ssl_cert = '';
$database_ssl_ca   = '';
$database_persist  = false;
```

## 5. Apache VHost Configuration

We assume you have installed PHP-FPM on the Apache web server. We will run Cacti with the Apche virtual host. So we just open the `/usr/local/etc/apache24/httpd.conf` file. To activate the Apache virtual host, you type or activate the script below in the file.

```console
LoadModule alias_module libexec/apache24/mod_alias.so
LoadModule vhost_alias_module libexec/apache24/mod_vhost_alias.so
Include etc/apache24/extra/httpd-vhosts.conf
```

After that, you create an Apache Virtual Host configuration file, in the `/usr/local/etc/apache24/extra/httpd-vhosts.conf` file. In that file, type the script below.

```console
<VirtualHost 192.168.5.2:80>

  ServerName datainchi.com

  DocumentRoot "/usr/local/www/cacti"

  DirectoryIndex index.php index.html

  Alias /cacti /usr/local/www/cacti/

  <Directory /usr/local/www/cacti>

  AllowOverride None
  Order Allow,deny
  Allow from all
  Require all granted


  </Directory>
    ErrorLog "/var/log/cacti/log"
    CustomLog "/var/log/dummy-host.example.com-access_log" common

  </VirtualHost>
  ```

In the Cacti log file, run the chown command, as in the following example.

```console
root@ns3:~ # chown -R www:www /var/log/cacti/log
```

The next thing to do is to add a cron job that polls your machines and routers each 5 minutes. To do that add the following lines to your `/etc/crontab file`.

```console
*/5 * * * * /usr/local/bin/php /usr/local/www/cacti/poller.php > /dev/null 2>&1
```

Restart the Apache24 web server.

```console
root@ns3:~ # service apache24 restart
```

Run Cacti by opening the Google Chrome web browser, and typing `"http://192.168.5.2/cacti/install/install.php"`.

The display above is the Cacti opening screen, type the Cacti username and password. After you have successfully logged in, it means you have run Cacti on the FreeBSD server. Now you can monitor your computer or network activity with Cacti. All activities that occur on your computer will be stored in the Cacti database table.