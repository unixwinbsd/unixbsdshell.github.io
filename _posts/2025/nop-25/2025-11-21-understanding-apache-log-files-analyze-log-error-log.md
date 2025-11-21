---
title: Understanding Apache Log Files - How to View, Find, and Analyze Access Log and Error Log Files
date: "2025-11-21 19:17:23 +0000"
updated: "2025-11-21 19:17:23 +0000"
id: understanding-apache-log-files-analyze-log-error-log
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: SysAdmin
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-022.jpg
toc: true
comments: true
published: true
excerpt: This tutorial will introduce you to logging in Apache and how it can help you diagnose, troubleshoot, and quickly resolve any issues you may encounter on your Apache server.
keywords: understanding, apache, log, files, how, view, find, analyze, access, error
---

At the time of this writing, the Apache HTTP server powers over 30.8% of all web servers. If you're responsible for managing any system that uses Apache, you'll likely interact with its logging infrastructure on a regular basis.

Apache is an open-source web server and a crucial element of the web development stack (the A in LAMP and WAMP). In addition to serving web pages, Apache also tracks and logs server activity and errors. Apache logs are essential for monitoring and troubleshooting web server activity. Knowing how to view, use, and manage Apache log files is crucial for server administrators.

This tutorial will introduce you to Apache logging and how it can help you diagnose, troubleshoot, and quickly resolve any issues you may encounter on your Apache server.

You'll learn where logs are stored, how to access them, and how to customize the output and location of logs to suit your needs. You'll also learn how to centralize Apache logs in a log management system to facilitate tracking, searching, and filtering logs across your system.

<img alt="Understanding Apache Log Files - How to View, Find, and Analyze Access Log and Error Log Files" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-023.jpg' | absolute_url }}">

## A. What is an Apache Log File?

Apache logs are text files that contain all the information about the Apache server's activities. These logs provide insight into which resources were accessed, when they were accessed, who accessed them, and associated metrics. They also include information about errors that occurred, the resource mapping process, connection completion, and more.

In general, the entire Apache logging process consists of several phases. First, you need to store the logs somewhere for historical analysis purposes. Second, you need to analyze the logs and parse them to extract useful information and metrics. And finally, you may want to graph the data because visual representations are easier for humans to analyze and understand.

All Apache events are recorded in two different text files:

### a.1. What is the Apache Access Log?

The Apache access log is a text file that contains information about all requests processed by the Apache server. You can find information such as the request time, the requested resource, the response code, the response time, and the IP address used to request the data.

### a.2. Apache Access Log Location

The location of the Apache server access log varies depending on the operating system you are using.

By default, on Red Hat, CentOS, or Fedora Linux operating systems, the Apache access log can be found in `/var/log/httpd/access_log`. On Debian and Ubuntu, you can find the Apache log in `/var/log/apache2/access.log`, while on FreeBSD, the Apache server access log is stored in the `/var/log/httpd-access.log` file.

You can configure the location using the CustomLog command, for example:

```yml
CustomLog "/var/log/httpd-access.log"
```

### a.3. What is the Apache Error Log?

So far, we've discussed the Apache access log, which provides information about accessed resources. However, that's not the only thing we need to pay attention to. We should also pay attention to anything related to errors. In fact, the error log is the most important log file for the Apache HTTP server.

The Apache error log contains all errors that occur during request processing. However, most importantly, the error log will contain information about what went wrong during Apache server startup and will likely also contain instructions on how to fix the problem.

### a.4. Apache Error Log Location

The location of the Apache error log varies depending on the operating system running it.

On Red Hat, CentOS, or Fedora Linux, by default, the error log can be found in `/var/log/httpd/error_log`. On Debian and Ubuntu, you can find the Apache log in `/var/log/apache2/error.log`, while on FreeBSD, the Apache server access log is in `/var/log/httpd-error.log`.

You can configure its location using the ErrorLog command, for example:

```yml
ErrorLog "/var/log/httpd-error.log"
```

## B. Starting an Apache Log File

One of the most common ways to view Apache log files is through the tail command, which prints the last 10 lines of an Apache log file. When the -f option is specified, the command will monitor the file and display its contents live.

```yml
[root@ns1 ~]# sudo tail -f /var/log/apache2/access.log
```

To view the entire contents of a file, you can use the cat command or open the file in a text editor such as `nano or vim`:

```yml
[root@ns1 ~]# cat /var/log/apache2/access.log
or
[root@ns1 ~]# sudo nano /var/log/apache2/access.log
```

You may also want to filter log entries in a log file based on a specific term. In such cases, you'll need to use the grep command. The first argument to grep is the term you want to search for, and the second argument is the log file to search. In the example below, we're filtering all lines containing the word GET.

```yml
[root@ns1 ~]# sudo grep GET /var/log/apache2/access.log
```

## C. Examining the Apache Access Log Format

The access log records all requests processed by the server. You can see what resources are requested, the status of each request, and how long it takes to process the response. In this section, we'll delve into how to customize the information displayed in this file.

Before you can benefit from reading the log file, you need to understand the format used for each entry. The CustomLog directive controls the location and format of the Apache access log file. This directive can be placed in the server configuration file `(/etc/apache2/apache2.conf)` or in your virtual host entry. Note that specifying the same CustomLog directive in both files can cause problems.

Let's take a look at the common formats used in Apache access logs and their meaning.


### c.1. Common Log Format

Common Log Format is the standard access log format used by many web servers because it is easy to read and understand. This format is defined in the `/etc/apache2/apache2.conf` configuration file via the LogFormat command.

When you run the command below:

```yml
[root@ns1 ~]# sudo grep common /etc/apache2/apache2.conf
```

You will see the output displayed by the above command.

```yml
LogFormat "%h %l %u %t \"%r\" %>s %O" common
```

The above line defines a common nickname and associates it with a specific log format string. The log entries generated by this format will look like this:

```yml
127.0.0.1 alice Alice [06/May/2021:11:26:42 +0200] "GET / HTTP/1.1" 200 3477
```

### c.2. Combined Log Format

The Combined Log Format is very similar to the General log format but contains some additional information.

This format is also defined in the `/etc/apache2/apache2.conf` configuration file.

```yml
[root@ns1 ~]# sudo grep -w combined /etc/apache2/apache2.conf
```

## D. Creating a custom log format

You can define a custom log format in the `/etc/apache2/apache2.conf` file by using the LogFormat command followed by the actual output format and a nickname to be used as an identifier for the format. After defining a custom format, you will pass its nickname to the CustomLog command and restart the `apache2 service`.

In this example, we will create a custom log format that looks like this:

```yml
LogFormat "%t %H %m %U %q %I %>s %O %{ms}T" custom
```

Open your `/etc/apache2/apache2.conf` file and place the above line below the other LogFormat lines. This will generate an access log entry with the following details:

- **%t:** date and time of the request.
- **%H:** request protocol.
- **%m:** request method.
- **%U:** requested URL path.
- **%q:** query parameters (if any).
- **%I:** total bytes received including request headers.
- **%>s:** final HTTP status code.
- **%O:** number of bytes sent in the response.
- **%{ms}T:** time taken to generate the response in milliseconds.

### d.1. Changing the default location of Apache log files

To change the default location of Apache logs, do the following:

a. Open the Apache configuration file using a text editor. For nano, run .

```yml
[root@ns1 ~]# sudo nano /etc/apache2/apache2.conf
```

Find the ErrorLog script and change its path. The line should look like this.

```yml
ErrorLog "/var/log/httpd-error.log"
```

To change the access log location, use the CustomLog command. This command consists of at least two arguments: a path with a file name and a log format string. For example,

```yml
CustomLog /etc/apache/log/access.log combined
```

To make the custom log file changes take effect immediately, restart the Apache server.

```yml
[root@ns1 ~]# sudo systemctl restart apache2
```

Analyzing your Apache server logs is crucial for understanding the traffic entering your application, the errors that occur, and the performance of user-facing elements. After reading the article above, you should be able to go beyond simply understanding server logs. Knowing what resources are accessed, who is accessing them, and how long requests take to process them is crucial for understanding the behavior of your Apache web server users.

You also need to ensure you're aware of any errors that occur so you can react as quickly as possible. Combine this with the need for a distributed infrastructure to handle large numbers of concurrent users and provide high availability, using observability tools is a must.
