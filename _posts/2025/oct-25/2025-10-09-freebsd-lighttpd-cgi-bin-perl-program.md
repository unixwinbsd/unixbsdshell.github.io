---
title: FreeBSD Lighttpd CGI BIN Setup for Perl Programs
date: "2025-10-09 14:14:29 +0100"
updated: "2025-10-09 14:14:29 +0100"
id: freebsd-lighttpd-plus-mod-openssl-installation
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-68.jpg
toc: true
comments: true
published: true
excerpt: Since we'll be enabling the CGI BIN mod, you'll need to install Perl first. The FreeBSD server has its own binary package system. This makes it easier to install and manage software. This package system also allows you to manage Perl module installations.
keywords: freebsd, lighttpd, installation, configuration, perl, mod, openssl, ssl, http, https, mod, module, cgi, bin, program
---


CGI applications can read and write to any computer language that originates from STDIN and writes to STDOUT, regardless of whether the program is interpreted by a Unix shell and compiled in C or C++, or a combination of both, such as Perl. The first CGI programs were written in C and needed to be compiled into executable binary files. Therefore, the directory where the compiled CGI program was executed was named cgi-bin, and the directory where the source files were executed was named cgi-src. Most servers today come with preconfigured directories for CGI programs.

The interaction between browsers and web servers is governed by the HyperText Transfer Protocol (HTTP), which is now an official Internet standard. HTTP uses a simple request-and-response model. For example, a client establishes a TCP connection to a server and sends a request, the server sends a response, and the connection is closed. These requests and responses take the form of messages written in a series of simple lines of text.

HTTP request and response messages have two parts. The first is the header, which contains descriptive information about the request or response. The different types of headers and their possible contents are determined entirely by the HTTP protocol. The header is followed by a blank line, followed by the message body. The message body is the actual message content, such as an HTML page or a GIF image.

## 1. About Common Gateway Interface (CGI)

The Common Gateway Interface, or CGI for short, is a standard for connecting various application programs to web pages. CGI is like a computer program that acts as an intermediary between the HTML standard that creates web displays and other programs, such as databases. Search results are sent back to the web page to be displayed in HTML format.

Initially, CGI was an approach used for server-side programming applications. Commonly used CGI programs are C++ and Perl. CGI is part of a web server that can communicate with other programs on the server. With CGI, a web server can invoke programs written in various programming languages ​​(Common Language). Interaction between users and various applications, such as databases, can be bridged by CGI (Gateway). This CGI capability can be used with the IIS Web Server.

The HTTP protocol allows clients and servers to understand each other by transferring all information between them using headers, where each header is a key-value pair. When you submit a form, the CGI program looks for headers containing input information, processes the received data, for example, requesting keywords provided in the form to a database, and, when ready, returns a response to the form.

The client will send a special header that tells it what type of information to expect, followed by the information itself. The server can send additional headers, but this is optional. See the image below.

![header web browser](/img/oct-25/oct-25-68.jpg)


CGI is often used as a mechanism to obtain information from users through form completion, database access, or dynamic page generation. While CGI mechanisms are inherently safe, programs or scripts written as CGI can contain security vulnerabilities or unintentional exploits. Potential vulnerabilities that can occur with CGI include:

- A malicious user could install a CGI script that sends a password file to the visitor running the CGI.
- The CGI program is called repeatedly, overloading the server by having to run multiple CGI programs, consuming memory and CPU cycles.

## 2. Installing Perl Language

Since we'll be enabling the CGI BIN mod, you'll need to install Perl first. The FreeBSD server has its own binary package system. This makes it easier to install and manage software. This package system also allows you to manage Perl module installations.

Enter the following command to install Perl5.

```
root@ns5:~ # pkg install perl5.38-5.38.2_1
```

The above command will install Perl5 on your FreeBSD server, and the binary path to Perl is `/usr/local/bin/Perl`.

Because there are many versions of Perl in the FreeBSD package repository, you must specify the Perl version in the `/etc/make.conf` file.

```
root@ns5:~ # ee /etc/make.conf

DEFAULT_VERSIONS+=  perl5=5.30
```

## 3. Enable CGI mod on Lighttpd

CGI principles and how to write CGI applications are not the focus of this discussion. However, understanding CGI configuration helps us understand the mod_cgi code we'll use to configure Lighttpd to run CGI processes.

Before continuing with this article, to make configuring CGI mods on Lighttpd easier, we recommend reading our previous article. ["Instalasi dan Konfigurasi FreeBSD Lighttpd Plus Mod OpenSSL"](https://unixwinbsd.site/freebsd/freebsd-lighttpd-plus-mod-openssl-installation)

Before enabling the CGI mod, we first need to install some PHP applications that Lighttpd requires to enable the CGI mod. Type this command to install the CGI mod dependencies.

```
root@ns5:~ # pkg install php82 mod_php82 php82-mysqli php82-xmlwriter
```

<br/>

```
root@ns5:~ # pkg install php82-gd php82-phar php82-ctype php82-filter php82-iconv php82-curl php82-mysqli php82-pdo php82-tokenizer php82-mbstring php82-session php82-simplexml php82-xml php82-zlib php82-zip php82-dom php82-pdo_mysql php82-ctype
```

Okay, now let's move on to enabling the CGI mod. Open the file `"/usr/local/etc/lighttpd/modules.conf"`, and add mod_cgi inside it.

```
server.modules = (
#  "mod_rewrite",
  "mod_access",
#  "mod_auth",
#  "mod_authn_file",
#  "mod_redirect",
#  "mod_setenv",
"mod_alias",
"mod_cgi",
"mod_fastcgi"
)
```

Now that the CGI module is active, we'll run it. Open the file `"/usr/local/etc/lighttpd/conf.d/cgi.conf"` and delete all the scripts inside, then replace them with the script below.

```
$HTTP["url"] =~ "/cgi-bin/" {
cgi.assign                 = ( ".pl"  => "/usr/local/bin/perl",
                               ".cgi" => "/usr/local/bin/perl",
                               ".rb"  => "/usr/bin/ruby",
                               ".erb" => "/usr/bin/eruby",
                               ".py"  => "/usr/local/bin/python" )
}
```

Documents ending in `".pl", ".cgi", and ".py"` are considered CGI programs. Interpreters for these programs will be available shortly. 

The next step is to restart Lighttpd.


```
root@ns5:~ # service lighttpd restart
```

## 4. Running Lighttpd mod_cgi

Once you've configured everything, test to see if the above configuration works on the Lighttpd web server. Create a folder `"/usr/local/www/data/cgi-bin"` and then create a file `"arrays.pl"`.

```
root@ns5:~ # mkdir -p /usr/local/www/data/cgi-bin
root@ns5:~ # cd /usr/local/www/data/cgi-bin
root@ns5:/usr/local/www/data/cgi-bin # touch arrays.pl
root@ns5:/usr/local/www/data/cgi-bin # chown -R www:www /usr/local/www/data/cgi-bin
```

In the file `"/usr/local/www/data/cgi-bin/arrays.pl"`, you enter the following script.

```
#!/usr/bin/perl
use strict;
use warnings;

# initializing arrays
my @places = ('Bangalore', 'Chennai', 'Coimbatore');
my @prime_numbers = (2, 3, 5, 7);
my @books;
$books[0] = 'Harry Potter';
$books[1] = 'Sherlock Holmes';
$books[2] = 'To Kill a Mocking Bird';
my @mixed_arr = ('Hello', 1, 'q', @places, $books[0]);

# ----- printing entire array -----
print "\@places: @places\n";
print "\@prime_numbers: @prime_numbers\n";
print "\@mixed_arr: @mixed_arr\n";
# use join to connect array items with preferred characters
print "My favorite books: ".join(', ', @books)."\n\n";

# ----- printing individual item -----
print "First item in \@places: $places[0]\n";
print "Last  item in \@places: $places[-1]\n";
print "Third last item in \@mixed_arr: $mixed_arr[-3]\n";

# ----- printing array slice -----
print "2nd and 3rd item in \@prime_numbers: @prime_numbers[1..2]\n\n";

# ----- array size -----
print "Index of last item in \@places: $#places\n";
my $arr_size = @places;
print "Number of items in \@places:    $arr_size\n\n";

# ----- manipulating array -----
# Add an item, same as $places[$#places + 1]
$places[3] = "Salem";
print "Manually add item: @places\n";

# Delete first item and shift left
shift(@places);
print "shift:             @places\n";
# Delete last item
pop(@places);
print "pop:               @places\n";

# Add an item at end of array
push(@places, "Mysore");
print "push:              @places\n";
# Add an item at beginning of array
unshift(@places, "Hyderabad");
print "unshift:           @places\n";

# change array size by assigning value to $#places
# Change no. of items to 2
$#places = 1;
print "\$#places = 1       @places\n";
# Change no. of items to 0
$#places = -1;
print "\$#places = -1      @places\n";
```

Open Google Chrome web browser, type `"http://192.168.5.2/cgi-bin/arrays.pl"`, the result is as shown in the image below.


![Test Perl](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-69.jpg)


Let's continue by testing the .cgi file. Still in the `"/usr/local/www/data/cgi-bin"` folder, create the file `"cgiperl.cgi"`.


```
root@ns5:/usr/local/www/data/cgi-bin # touch cgiperl.cgi
root@ns5:/usr/local/www/data/cgi-bin # chown -R www:www cgiperl.cgi
```

Type the following script in the file `"/usr/local/www/data/cgi-bin/cgiperl.cgi"`.


```
#!/usr/local/bin/perl

print "Content-type: text/html\n\n";
print <<htmlcode;
<html>
<head>
<title>CGI Perl Example</title>
</head>
<body>
<h1>CGI Perl Example</h1>
<h3><p>Congratulations on successfully configuring the Perl mod on Apache24!</p><h3>
</body>
```

Open Google Chrome again and type `"http://192.168.5.2/cgi-bin/cgiperl.cgi"`. Please see the results.

Configuring CGI scripts on the Lighttpd web server is a relatively simple process that can be done by following the instructions in this article. Enabling CGI support, creating a CGI script, configuring Lighttpd to recognize the script, and testing the script are the essential steps in configuring CGI scripts on Lighttpd.

With these steps, you can create dynamic and interactive web pages that can be used to provide information or services to your website visitors.