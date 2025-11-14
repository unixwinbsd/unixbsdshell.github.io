---
title: How to Install Hugo GoHugo on FreeBSD GoLang
date: "2025-05-27 08:01:00 +0100"
updated: "2025-05-27 08:01:00 +0100"
id: install-hugo-gohugo-freebsd-golang
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Gohuugo is a static HTML and CSS website generator written in the Go language. By using the Go language, Gohugo is optimized for speed, ease of use, and configurability
keywords: hugo, gohugo, freebsd, go, golang, static, static page, ruby, jekyll, github page
---

Gohuugo is a static HTML and CSS website generator written in the Go language. By using the Go language, Gohugo is optimized for speed, ease of use, and configurability. Gohugo takes a directory with content and templates and makes it a complete HTML website.

Due to its flexible framework with multilingual support as well as a powerful taxonomy system Gohugo is widely used to create:
- Corporate, government, non-profit, educational, news, event and project sites.
- Documentation site.
- Image portfolio.
- Article page.
- Business, professional and personal blogs.
- Resume and CV.

With Gohugo we can create websites with little or no code. Static site generators usually allow you to write content in a simple markup language, such as Markdown. The static site generator then converts article or other content into HTML files. Using Gohugo, you can choose from a library of themes and template designs that other people have created. After downloading Tempalte, you can start writing content which is then published so that many people can read it.

Surely everyone will think about how to create a website. It could be a resume, portfolio, or even blog articles. In this post, we will look at how to launch a static website with minimal investment. This article was written using the FreeBSD 13.2 system which has the GO (go language) application installed.


## 1. What is a static site generator

Static site generator (SSG) is a software tool that generates modern static websites from various source files. Developers use static site generators to create websites that are fast, secure, scalable, and easy to maintain. And what's even better, SSG itself is Open source software, meaning it is freely available for everyone to use and modify. Popular SSGs have large and active communities built around them, with a
constant stream of improvements and updates provided by community members.

Static websites don't necessarily require databases, API requests, and complex backends. In many cases, a plain HTML document is sufficient, but beautiful and with the same style for all pages. Of course, you can create something appropriate yourself, but you can use tools that accept text, images and other content as input and generate pages from them. This approach allows you to save time and get results in a short time. In addition, the results will be of high quality.

There are many generators on the Web that differ in various parameters. In this article, we will look at working with the Gohugo generator, which has a number of advantages:
- Hugo is written in the GO language, which makes it very fast. The developer claims a build speed of less than 1 ms per page, and the average website is created in 1 second.
- Additional features of the Markdown markup language are included, allowing you to embed new types of content.
- Built-in templates for working with SEO, optimization and analytics.
- Open source and free.
- There are ready-to-use templates that can be used as a basis for creating articles.

Currently, Gohugo is capable of generating most websites in seconds (<1 ms per page). That explains why Gohugo bills itself as “the world's fastest framework for building websites.


## 2. Gohugo Installation

How to install Gohugo on FreeBSD can be done in various ways:

- Installation from source binary, and
- Installation from Repository packages pkg or Repository system ports.

In this article we will not discuss installation of binary sources, we will focus on installing packages and ports, because these two methods are common and widely used on FreeBSD. To start installing Gohugo, we must first install dependent supporting applications. The following is an example of installing Gohugo dependencies.

```console
root@ns1:~ # cd /usr/ports/devel/git
root@ns1:/usr/ports/devel/git # make install clean
root@ns1:/usr/ports/devel/git # cd /usr/ports/lang/go
root@ns1:/usr/ports/lang/go # make install clean
root@ns1:/usr/ports/lang/go # cd /usr/ports/textproc/libsass
root@ns1:/usr/ports/textproc/libsass # make install clean
root@ns1:/usr/ports/textproc/libsass # cd /usr/ports/graphics/webp
root@ns1:/usr/ports/graphics/webp # make install clean
```

After the dependencies above are installed, the next step is to install Gohugo as the main topic of this article. Below is how to install Gohugo using the FreeBSD ports system.

```console
root@ns1:~ # cd /usr/ports/www/gohugo
root@ns1:/usr/ports/www/gohugo # make install clean


The method above is installing Gohugo using the ports system, then how to install Gohugo with the FreeBSD pkg package. Here's how to install Gohugo with the pkg package.

```console
root@ns1:~ # pkg install git go libsass webp
root@ns1:~ # pkg install gohugo
```

One of the advantages of running Gohugo on a FreeBSD system is that we don't configure config files. After the installation process is complete, Gohugo can be used immediately.


## 3. How to Use Gohugo

Before we discuss how to use Gohugo further, first check the version of Gohugo you are using.

```console
root@ns1:~ # hugo version
hugo v0.115.4+extended freebsd/amd64 BuildDate=2023-07-28T05:46:23Z+0700 VendorInfo=freebsd
```

How to use Gohugo on FreeBSD is very easy. Follow these steps to use or how to run Gohugo on FreeBSD.

```console
root@ns1:~ # mkdir -p /usr/local/www/gohugo
root@ns1:~ # cd /usr/local/www/gohugo
root@ns1:/usr/local/www/gohugo #
```

The script above is to create a working folder with the name `gohugo`. We will later use this folder/directory to store all the files for creating a website using Gohugo.

In this example we will create a website with Gohugo, here's how.

```console
root@ns1:/usr/local/www/gohugo # hugo new site portfolio
Congratulations! Your new Hugo site is created in /usr/local/www/gohugo/portfolio.
```

The command above will produce a new directory called `portfolio`. If we use the ls command, the result which contains files and directories as below.

```console
root@ns1:/usr/local/www/gohugo/portfolio # ls -l
total 4
drwxr-xr-x  2 root  wheel   3 Aug 22 09:18 archetypes
drwxr-xr-x  2 root  wheel   2 Aug 22 09:18 assets
drwxr-xr-x  2 root  wheel   2 Aug 22 09:18 content
drwxr-xr-x  2 root  wheel   2 Aug 22 09:18 data
-rw-r--r--  1 root  wheel  82 Aug 22 09:18 hugo.toml
drwxr-xr-x  2 root  wheel   2 Aug 22 09:18 layouts
drwxr-xr-x  2 root  wheel   2 Aug 22 09:18 static
drwxr-xr-x  2 root  wheel   2 Aug 22 09:18 themes
```

At this point you have successfully installed and run Gohugo on the FReeBSD system. Due to the extensive discussion of Gohugo, we will close this article here. To learn more about Gohugo, you can read the continuation of this article. Enjoy learning Gohugo with "Nusantara Bercoding".