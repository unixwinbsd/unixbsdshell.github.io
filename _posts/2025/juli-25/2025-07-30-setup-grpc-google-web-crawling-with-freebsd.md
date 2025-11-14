---
title: Setup GRPC Google Web Crawling With FreeBSD
date: "2025-07-30 09:33:37 +0100"
updated: "2025-07-30 09:33:37 +0100"
id: setup-grpc-google-web-crawling-with-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/diagram-grpc-web-crawler.jpg
toc: true
comments: true
published: true
excerpt: As we know, gRPC uses HTTP 2.0 as the main protocol, for communication between server and client. This allows gRPC to get the most out of the HTTP 2 protocol, including streaming communications and bidirectional support. With the HTTP 2 protocol
keywords: grpc, crawling, crawler, web crawling, freebsd, http, gsc, google search engine
---

In gRPC, you can define services to determine what methods can be called remotely with appropriate parameters and return types. These services are run by gRPC on the server side, and the gRPC server will carry out those client calls, while on the client side, it only provides access to the same methods as the server runs.

As we know, gRPC uses HTTP 2.0 as the main protocol, for communication between server and client. This allows gRPC to get the most out of the HTTP 2 protocol, including streaming communications and bidirectional support. With the HTTP 2 protocol, gRPC is able to receive multiple requests from multiple clients.

In this article, we will create a web crawling service with gRPC in Go. A gRPC web crawler will work to crawl a blog or wordpress site and then force GSC to display it on search engines such as Google search engine.

The application consists of a `Web Crawler as a gRPC primary service` implementation, consisting of a command line client and a local service that performs the actual web crawling. Communication between clients and servers is defined as a gRPC service. The crawler only follows links on the provided URL domain and not any external URL links. gRPC web crawling uses channels and goroutines to improve performance.

<br/>
<img alt="diagram grpc web crawler" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/diagram-grpc-web-crawler.jpg' | relative_url }}">
<br/>

## 1. Setup GRPC Web Crawler

Before starting to run the gRPC web crawler, make sure Go Lang is installed on your FreeBSD server, if not, complete the Go Lang installation first.

To make it easier to control the web crawler, we create a working directory. In this article, we will place the gRPC server and client in `/usr/local/etc`.

To make the `gRPC web crawler` configuration process easier, we have provided the following file containing the script code. You just clone from the unixwinbsd Github repository.

```yml
root@ns7:~ # cd /usr/local/etc
root@ns7:/usr/local/etc # git clone git@github.com:unixwinbsd/FreeBSD-grpc-WebCrawler.git
```

After the repository cloning process is complete, we start carrying out the **build** command on the gRPC server and client files.

```yml
root@ns7:/usr/local/etc # cd FreeBSD-grpc-WebCrawler
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler # cd crawl
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/crawl # go build -o bin/client crawl.go
```

The above `"build"` command will generate a bin file named `"client"`. You can directly execute the file to run the gRPC client.

At this stage, we have finished configuring the gRPC client, now we continue configuring the gRPC server. The command is almost the same as above, only the location of the file directory is the difference.

```yml
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/crawl # cd ..
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler # cd server
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server # go build -o bin/server main.go
```

Run the gRPC server with the following command.

```yml
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server # cd bin
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server/bin # ./server
2024/01/08 10:12:04 starting gRPC server...
```

Now we have a gRPC web crawling server. But, to run it must be done manually. We will create a script so that the gRPC server can run automatically when the computer is turned off or restarted.


## 2. Start Up rc.d

To do the work above, you have to create a Start Up `rc.d` script, the goal is none other than so that each application can run automatically.

Run the command below to create the `rc.d` Start Up script.

```yml
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server/bin # touch /usr/local/etc/rc.d/server
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server/bin # chmod +x /usr/local/etc/rc.d/server
```

With the command above, you have created a file called `"server"`, this file will automatically run the gRPC server. In the `/usr/local/etc/rc.d/server` file, you enter the script code below.

```console
#!/bin/sh

# PROVIDE: server
# REQUIRE: LOGIN
# KEYWORD: shutdown
#
# Add the following lines to /etc/rc.conf.local or /etc/rc.conf
# to enable this service:
#
# kpropd_enable (bool):      Set to NO by default.
#                            Set it to YES to enable kpropd.
# kpropd_flags (str):        Set to "" by default.

. /etc/rc.subr

name=server
rcvar=server_enable

load_rc_config $name

: ${grpc_enable:="NO"}
: ${server_flags=""}

command=/usr/local/etc/FreeBSD-grpc-WebCrawler/server/bin/${name}

run_rc_command "$1"
```

We activate it in the `/etc/rc.conf` file.

```console
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server/bin # ee /etc/rc.conf
server_enable="YES"
```

Run the `rc.d` script.

```console
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server/bin # service server restart
server not running?
Starting server.
2024/01/08 10:24:11 starting gRPC server...
```

Your gRPC server has been activated automatically, perform the restart command on your FreeBSD server.

```yml
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/server/bin # reboot
```

After that, run the gRPC client.

```console
root@ns7:~ # cd /usr/local/etc/FreeBSD-grpc-WebCrawler/crawl/bin
root@ns7:/usr/local/etc/FreeBSD-grpc-WebCrawler/crawl/bin # ./client -start https://www.unixwinbsd.site
crawling https://www.unixwinbsd.site
2024/01/08 10:31:11 response: started:true
```

You can replace the site URL name with the name of your blog or WordPress site URL.

gRPC is an application made by Google, so its stability and reliability are beyond doubt. With the gRPC server and client running automatically, it will speed up your blog or WordPress URL link appearing on the Google search engine page.