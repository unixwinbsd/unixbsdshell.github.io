---
title: How To Install AWStats with Apache On FreeBSD
date: "2025-10-01 11:12:21 +0100"
updated: "2025-10-01 11:12:21 +0100"
id: install-awstats-apache-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-54.jpg
toc: true
comments: true
published: true
excerpt: AWStats (Advanced Web Statistics) is an open source web analytics tool that analyzes and generates comprehensive reports on web server log files such as Apache or NGINX. All visitor information on the website and various aspects of web traffic are neatly arranged and easy to read
keywords: awstats, log, install, apache, nginx, web server, freebsd, visitor
---

AWStats is widely used by people for its ability to analyze Apache log files, email log files, and FTP log files in static or dynamic HTML report formats. Not only that, AWStats can process separate log files for clusters. One of the reasons why you should choose AWStats is because of its fast speed and ability to handle large log formats. Additionally, its functionality can be extended with plugins.

AWStats (Advanced Web Statistics) is an open source web analytics tool that analyzes and generates comprehensive reports on web server log files such as Apache or NGINX. All visitor information on the website and various aspects of web traffic are neatly arranged and easy to read. To do all that, AWStats requires a server log file, so it is important for me to set up a server log file on Apache or NGINX.

AWStats is a very powerful and useful software that allows webmasters to count visits to the websites they manage. This tool is built with Perl and was a very popular choice before Google launched the Google Analytics tool. However, currently not everyone uses Google Analytics services and it can even be difficult to utilize it for both companies and government agencies. This is AWStats in the modern web world that can be used with Apache but also with Nginx.


![oct-25-16](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25-16.jpg)



## 1. Pre-requisites

- OS: FreeBSD 13.2
- Apace24 with mod_perl
- IP Address 192.168.5.2
- Domain: unixwinbsd.site
- Hostname: ns6


## 2. Setup Apache mod_perl

Apache Perl is an integrated project that brings together the Perl programming language and the Apache web server. By connecting the Perl runtime library to the server and providing an object-oriented Perl interface to the server's C language API. These pieces are glued together seamlessly by the `mod_perl' server plugin, making it possible to write Apache modules entirely in Perl. Additionally, a persistent interpreter embedded in the server avoids the overhead of starting an external interpreter and the Perl start-up (compilation) time penalty.

This Mod_Perl is used by AWStats to connect to the Apache server. With `Mod_Perl` the server response time becomes faster. The following is a guide to installing mod_perl on Apache24.

```
root@ns6:~ # cd /usr/ports/www/mod_perl2
root@ns6:/usr/ports/www/mod_perl2 # make install clean
root@ns6:/usr/ports/www/mod_perl2 # cd /usr/ports/databases/p5-DBI
root@ns6:/usr/ports/databases/p5-DBI # make install clean
root@ns6:/usr/ports/databases/p5-DBI # cd /usr/ports/www/p5-Apache-DBI
root@ns6:/usr/ports/www/p5-Apache-DBI # make install clean
```

After that, add the script below to the file `"/usr/local/etc/apache24/httpd.conf"`.

```
<Location /cgi-bin/*.pl>
    SetHandler perl-script
    PerlResponseHandler ModPerl::PerlRun
    PerlSendHeader On
    Options ExecCGI
    Require all granted
</Location>
<Location /cgi-bin/*.cgi>
    SetHandler perl-script
    PerlResponseHandler ModPerl::PerlRun
    PerlSendHeader On
    Options ExecCGI
    Require all granted
</Location>
```

Then, you activate the mod_perl module in the file `"/usr/local/etc/apache24/modules.d/260_mod_perl.conf"`


```
#LoadModule perl_module        libexec/apache24/mod_perl.so

Remove the sign "#"

LoadModule perl_module        libexec/apache24/mod_perl.so
```


## 3. Setup awstats

The official documentation for setting up AWStats can be found here. However, to install AWStats on FreeBSD and configure it we will use the general configuration with default scripts. The default AWStats installation with the ports system can be found at `/usr/ports/www/awstats`. Follow the steps below.

```
root@ns6:~ # cd /usr/ports/www/awstats
root@ns6:/usr/ports/www/awstats # make install clean
```

The results of the installation above will produce a new folder `"/usr/local/www/awstats"`. We will use the IP address to connect with the Apache24 server, therefore copy the files awstats.model.conf to `awstats.192.168.5.2.conf`.


```
root@ns6:~ # cd /usr/local/www/awstats/cgi-bin
root@ns6:/usr/local/www/awstats/cgi-bin # cp awstats.model.conf awstats.192.168.5.2.conf
```

Change the Alias for CGI scripts in the `"/usr/local/etc/apache24/httpd.conf"` file.

```
ScriptAlias /cgi-bin/ "/usr/local/www/apache24/cgi-bin/"

Change

ScriptAlias /cgi-bin/ "/usr/local/www/awstats/cgi-bin/"
```

Next, create awstats permissions to the Apache24 server by adding the script below to the `"/usr/local/etc/apache24/httpd.conf"` file.


```
Alias /awstatsclasses "/usr/local/www/awstats/classes/"
Alias /awstatscss "/usr/local/www/awstats/css/"
Alias /awstatsicons "/usr/local/www/awstats/icon/"

<Directory "/usr/local/www/awstats">
    Options None
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>
```

We will now edit the file `"/usr/local/www/awstats/cgi-bin/awstats.192.168.5.2.conf"`, and change following parameters.


```
LogFile="/var/log/httpd/awstats.log"
SiteDomain="www.unixwinbsd.site"
HostAliases="unixwinbsd.site ns6 192.168.5.2"
DirData="."
DirCgi="/awstats"
EnableLockForUpdate=1
PurgeLogFile=1
```

Create log file and run the chown and chmod commands on the folder.

```
root@ns6:~ # touch /var/log/httpd/awstats.log
root@ns6:~ # chown -R www:www /usr/local/www/awstats/ && chown -R www:www /var/log/httpd/
root@ns6:~ # chmod -R 777 /usr/local/www/awstats/
```

Since the way awstats works is reading log files, let's go ahead and process the log file for the unixwinbsd.site domain with IP Address `192.168.5.2`.


```
root@ns6:~ # cd /usr/local/www/awstats/cgi-bin
root@ns6:/usr/local/www/awstats/cgi-bin # perl awstats.pl -update -config=192.168.5.2
Create/Update database for config "./awstats.192.168.5.2.conf" by AWStats version 7.9 (build 20230108)
From data in log file "/var/log/httpd/mylog.log"...
Phase 1 : First bypass old records, searching new record...
Searching new records from beginning of log file...
Jumped lines in file: 0
Parsed lines in file: 0
 Found 0 dropped records,
 Found 0 comments,
 Found 0 blank records,
 Found 0 corrupted records,
 Found 0 old records,
 Found 0 new qualified records.
```

After that, to execute all the configurations above, you restart the Apache server.


```
root@ns6:~ # service apache24 restart
```

The final step of our project this time is to carry out ASWTATs testing. If you haven't missed anything in the configuration above and you have set it according to the instructions above, you should be able to open AWStats in the `Yandex or Google Chrome web browser`. In the address bar menu of your web browser, enter `"http://192.168.5.2/cgi-bin/awstats.pl"` and the results will look like the image below.


![oct-25-17](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25-17.jpg)


Take a look at the image above, all the data is not displayed or is empty, because we are using a private IP `192.168.5.2`. If you have a website on a personal computer, replace the private IP address with your domain, surely all the data will be displayed by awstats. The method is the same, you just replace the private IP with your domain name.