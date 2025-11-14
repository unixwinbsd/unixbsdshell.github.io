---
title: Enabling PERL mod on FreeBSD CGI BIN in Apache24
date: "2025-10-01 20:17:46 +0100"
updated: "2025-10-01 20:17:46 +0100"
id: enabling-perl-mod-freebsd-cgi-bin-apache24
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-55.jpg
toc: true
comments: true
published: true
excerpt: Perl mod installed on FreeBSD is more than just a more advanced CGI script. Perl mod is a new way to create dynamic content by harnessing the full power of the Apache web server to make the web stateful.
keywords: apache, web server, perl, mod, module, freebsd, cgi, bin, cgi bin
---

Perl mod is a Perl programming language module embedded into the Apache24 web server. Perl mod can be used to manage the Apache24 web server, respond to web page requests, and more.

Perl mod installed on FreeBSD is more than just a more advanced CGI script. Perl mod is a new way to create dynamic content by harnessing the full power of the Apache web server to make the web stateful. It includes a customized user authentication system, more advanced proxy usage, and more. Yet, miraculously, your old CGI scripts will still work and run incredibly fast. With Perl mod, you'll get even more out of the performance of Perl mod integrated into Apache24.

This article will explain how to enable Perl mod in Apache24. In this article, Perl and Apache24 mod will be installed simultaneously on a FreeBSD 13.2 system.

![oct-25-22](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-22.jpg)

<br/>


## 1. Installing Apache24 Perl mod CGI
To use the Perl mod feature, you must first install the Apache24 web server. Here's a guide on how to install the Perl mod on Apache24.

```
root@ns1:~ # cd /usr/ports/www/apache24
root@ns1:/usr/ports/www/apache24 # make install clean
```

Once apache24 is successfully installed, you can proceed with installing the perl mod.


```
root@ns1:~ # cd /usr/ports/www/mod_perl2
root@ns1:/usr/ports/www/mod_perl2 # make install clean
root@ns1:~ # cd /usr/ports/databases/p5-DBI
root@ns1:/usr/ports/databases/p5-DBI # make install clean
root@ns1:~ # cd /usr/ports/www/p5-Apache-DBI
root@ns1:/usr/ports/www/p5-Apache-DBI # make install clean
```
Open the file `/usr/local/etc/apache24/httpd.conf`, enable ServerName by removing the **"#"** sign in front of the script.

```
#ServerName www.example.com:80

Then change it with the script below.

ServerName www.unixexplore.com:80
```


www.example.com is converted to a domain name on your FreeBSD server, in this case the domain name I specified in the `/etc/hosts` file is unixexplore.com. If you haven't specified a domain name in the `/etc/hosts` file, please create one. See the example of writing a domain name in the `/etc/hosts` file below.

```
root@ns1:~ # ee /etc/hosts
::1                      localhost   localhost.unixexplore.com
127.0.0.1                localhost   localhost.unixexplore.com
192.168.5.2              ns1.unixexplore.com  ns1
192.168.5.2              www.unixexplore.com
```

Still in the `/usr/local/etc/apache24/httpd.conf` file, after the script.


```
<Directory "/usr/local/www/apache24/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>
```

You have to add the following script below it.


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

Now you open the file `/usr/local/etc/apache24/modules.d/260_mod_perl.conf` and enable the perl module by removing the **"#"** sign in the following script.


```
#LoadModule perl_module        libexec/apache24/mod_perl.so

Remove the “#” sign so that it becomes

LoadModule perl_module        libexec/apache24/mod_perl.so
```


Once Apache24 configuration is complete, enter the following script in the `/etc/rc.conf` file.

```
root@ns1:~ # ee /etc/rc.conf
apache24_enable="YES"
```

Restart the Apache24 web server.


```
root@ns1:~ # service apache24 restart
```

## 2. Test Apache24 Perl mod CGI

To test this Perl mod, we'll create a test file called `"test.cgi"`, which will be placed in the `/usr/local/www/apache24/cgi-bin` folder. Here's how to create the file.


```
root@ns1:~ # touch /usr/local/www/apache24/cgi-bin/test.cgi
```

Grant permission to the file `/usr/local/www/apache24/cgi-bin/test.cgi`.


```
root@ns1:~ # chmod 755 /usr/local/www/apache24/cgi-bin/test.cgi
```

Give ownership rights to the file `/usr/local/www/apache24/cgi-bin/test.cgi` or the folder `/usr/local/www/apache24/`.


```
root@ns1:~ # chown -R www:www /usr/local/www/apache24/
root@ns1:~ # chown -R www:www /usr/local/www/apache24/cgi-bin/test.cgi
```

Now you open the file `/usr/local/www/apache24/cgi-bin/test.cgi` and enter the script below, use the **"ee"** editor or **"nano"** editor to enter the following script.


```
root@ns1:~ # ee /usr/local/www/apache24/cgi-bin/test.cgi
#!/usr/local/bin/perl
print "Content-Type: text/html; charset=utf-8 \n\n";
print "<h1>Congratulations on successfully configuring the Perl mod on Apache24!</h1>";
```

Restart the Apache24 web server.


```
root@ns1:~ # service apache24 restart
```
After restarting, test it by opening the Yandex browser or Google Chrome. Type the following command into the browser `http://192.168.5.2/cgi-bin/test.cgi`



Remember, the IP address `192.168.5.2` is the IP address of the FreeBSD private server. If there are no configuration errors, the following message will appear:
<br/>

*Congratulations on successfully configuring the Perl mod on Apache24!*