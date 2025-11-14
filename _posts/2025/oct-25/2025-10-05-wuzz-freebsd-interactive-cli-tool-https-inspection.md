---
title: How To Use WUZZ With FreeBSD as Interactive cli tool for HTTP Inspection
date: "2025-10-05 08:31:19 +0100"
updated: "2025-10-05 08:31:19 +0100"
id: wuzz-freebsd-interactive-cli-tool-https-inspection
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-57.jpg
toc: true
comments: true
published: true
excerpt: Wuzz, written in Go Lang, has many advantages so it is very popular with developers. One of the advantages of Wuzz is that it saves resources, you don't need a lot of RAM to run backend API development tasks. Despite having a CLI interface, the menu is very interactive, very effective, light and fast for HTTP checks.
keywords: installation, wuzz, interactive, cli, tool, check, http, inspection, freebsd, command, cli
---



As you can't believe, we are currently in an era where productivity is achieved more through smart work than hard work. Through intelligent methods, humans continue to try to find the best, faster, easier and smarter ways to achieve maximum results.

When you are doing the task of "developing backend API", you will definitely interact with HTTP inspection. Usually people use Postman, but many developers are disappointed, because it is a bit heavy, takes up a lot of RAM and the UI is also increasingly complex and difficult.

When you lose patience, Wuuz is here to offer a solution and your work can be finished quickly. Wuzz is the best HTTP inspection interactive CLI tool out there.

In carrying out its work, Wuzz will visually examine what the HTTP protocol returns for each different HTTP argument value. Wuzz command line arguments are similar to CURL arguments, so they can be used to check or modify requests copied from browser network checkers with the "copy as cURL" feature.

Wuzz, written in Go Lang, has many advantages so it is very popular with developers. One of the advantages of Wuzz is that it saves resources, you don't need a lot of RAM to run backend API development tasks. Despite having a CLI interface, the menu is very interactive, very effective, light and fast for HTTP checks.


## 1. Install WUZZ

Because the nature of the Wuzz application is very light and simple, it is not difficult to install Wuzz and there is no configuration. So you can immediately run wuzz.

On FreeBSD systems, wuzz can be installed with system ports or the PKG package. But you should use the ports system to install Wuzz. Run the following command to install wuzz.

```
root@ns7:~ # cd /usr/ports/www/wuzz
root@ns7:/usr/ports/www/wuzz # make install clean
```

After the installation is complete, check the wuzz version.

```
root@ns7:/usr/ports/www/wuzz # wuzz -v
wuzz 0.5.0
```

If you want to know the wuuz command, run the following command.

```
root@ns7:/usr/ports/www/wuzz # wuzz -h
wuzz - Interactive cli tool for HTTP inspection

Usage: wuzz [-H|--header HEADER]... [-d|--data|--data-binary DATA] [-X|--request METHOD] [-t|--timeout MSECS] [URL]

Other command line options:
  -c, --config PATH        Specify custom configuration file
  -e, --editor EDITOR      Specify external editor command
  -f, --file REQUEST       Load a previous request
  -F, --form DATA          Add multipart form request data and set related request headers
                           If the value starts with @ it will be handled as a file path for upload
  -h, --help               Show this
  -j, --json JSON          Add JSON request data and set related request headers
  -k, --insecure           Allow insecure SSL certs
  -R, --disable-redirects  Do not follow HTTP redirects
  -T, --tls MIN,MAX        Restrict allowed TLS versions (values: SSL3.0,TLS1.0,TLS1.1,TLS1.2)
                           Examples: wuzz -T TLS1.1        (TLS1.1 only)
                                     wuzz -T TLS1.0,TLS1.1 (from TLS1.0 up to TLS1.1)
  --tlsv1.0                Forces TLS1.0 only
  --tlsv1.1                Forces TLS1.1 only
  --tlsv1.2                Forces TLS1.2 only
  -1, --tlsv1              Forces TLS version 1.x (1.0, 1.1 or 1.2)
  -v, --version            Display version number
  -x, --proxy URL          Set HTTP(S) or SOCKS5 proxy

Key bindings:
  ctrl+r              Send request
  ctrl+s              Save response
  ctrl+e              Save request
  ctrl+f              Load request
  tab, ctrl+j         Next window
  shift+tab, ctrl+k   Previous window
  alt+h               Show history
  pageUp              Scroll up the current window
  pageDown            Scroll down the current window
```




## 1. How to Use Wuzz

Wuzz provides a simple and intuitive user interface for inspecting and modifying HTTP headers and payloads. Wuzz supports various HTTP methods such as GET, PUT, DELETE, POST and others. Using Wuzz users can easily upload files, visualize the response contents, and make customized HTTP requests. Not only that, Wuzz supports HTTP/1.0 and HTTP/1.1 protocols, and is compatible with IPv4 and IPv6.

The tool has a built-in syntax highlighting feature for easy identification of different parts of HTTP requests and responses. Wuzz also supports proxy mode, which allows users to send requests through a proxy server for debugging or other testing. Wuzz can save and load each session, making it convenient for repetitive tasks or when starting from a previous state. Wuzz is available for FreeBSD, Windows, macOS, and Linux operating systems.

On FreeBSD, using Wuzz is very easy. Run the following command to start Wuzz.

```
root@ns7:~ # wuzz
```

You will be presented with the Wuzz Command Line display, enter the URL address you want to inspect. For more details, look at the following image.

![oct-25-57](/img/oct-25/oct-25-57.jpg)


The wuzz command is a powerful tool for interactively inspecting HTTP requests and responses. With its capabilities wuzz can display help information, send HTTP requests, and navigate between different views. By using Wuzz users can test and analyze HTTP-based applications effectively.