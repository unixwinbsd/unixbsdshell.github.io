---
title: Creating a Web Crawler With FreeBSD And Python
date: "2025-09-22 10:01:21 +0100"
updated: "2025-09-22 10:01:21 +0100"
id: creating-web-crawl-freebsd-and-python
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/oct-25-20.jpg
toc: true
comments: true
published: true
excerpt: A web crawler bot works like someone going through all the books in an unorganized library and putting together a card catalog so that anyone visiting the library can quickly and easily find the information they need
keywords: python, crawling, web crawler, freebsd, index, robots, sitemap
---

A web crawler, spider, or search engine bot downloads and indexes content from web sites such as blogs, WordPress or others. The goal of such a bot is to learn (almost) every blog page on the web, so that the information can be retrieved when needed. They are called "web crawlers" because crawling is the technical term for automatically accessing a blog site and obtaining data through a software program.

These bots are almost always operated by search engines such as Google search console (GSC). By applying structured algorithms to data collected by web crawlers, a search engine can provide relevant links in response to a blog or WordPress user's search query, resulting in a list of web pages that appear after the user types a search into Google, Bing, Yandex (or other search engines).

A web crawler bot works like someone going through all the books in an unorganized library and putting together a card catalog so that anyone visiting the library can quickly and easily find the information they need. However, a web site or blog, unlike a library, does not consist of physical stacks of books, so it is difficult to know whether all the necessary information has been indexed correctly, or if large amounts of information have been missed.

A crawler bot tries to find all the relevant information displayed by a blog. A web crawler bot will start with a particular set of known blog pages and then follow the hyperlinks from those pages to other pages, follow the hyperlinks from those other pages to additional pages, and so on.

<br/>
<img alt="web crawler Gitea FreBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/oct-25-20.jpg' | relative_url }}">
<br/>

In this article, we will first introduce crawler bots in crawling a blogsite. Then we will build a web crawler with Python, and finally we will practice how to use the Python web crawler.

To work on the web crawler, we used the `FreeBSD 13.2 Stable` server with `Python 3.10`. However, you can apply all the contents of this article to an Ubuntu or Debian server.


## 1. Installation Process

The first thing you have to do is install Python on the FreeBSD server. After that, you also install Python PIP and Python Virtual Environment (VENV). Read our previous article about Python PIP and Python Virtual Environment (VENV).

To create a website crawler in Python, we need some Python libraries that are used to download HTML files from URLs and libraries to extract links. To do all this, Python has provided the standard library urllib for making HTTP requests and html.parser for parsing HTML.

We have also optimized the capabilities of this web crawler with the help of other libraries such as Requests and Beautiful Soup (BS4), which can provide a better developer experience when making HTTP requests and handling HTML documents.

We assume you have installed Python PIP and Python VENV, so we just go straight to the Python virtual environment. In this article we have created a Python virtual environment in the `/root/.cache/pypoetry` directory.

```yml
root@ns7:~ # cd /root/.cache/pypoetry
root@ns7:~/.cache/pypoetry # source bin/activate.csh
(pypoetry) root@ns7:~/.cache/pypoetry #
```

You can directly install two Python libraries, namely `"Requests" and "Beautiful Soup"`.

```yml
(pypoetry) root@ns7:~/.cache/pypoetry # pip install requests bs4
```


## 2. Building Python Web Crawler

A Python web crawler is an automated program that crawls a blog or website to search the entire contents of a web page. Utilities are Python scripts that crawl through pages, find links, and follow them for indexing. The goal is so that your URL links can be found in search engines.

Search engines rely on crawling bots to build and maintain their page indexes, while web scrapers use them to visit and discover all pages to apply data extraction logic.

This article will make it easier to crawl websites. You only need to download the file that we have provided on Github, and place the file in the `Python VENV directory`.

```yml
root@ns7:~/.cache/pypoetry # git clone https://github.com/unixwinbsd/PythonWebCrawler.git
```

You open the `crawlerino.py` file, change the domain name to your own domain.


```console
if __name__ == "__main__":
    # set stdout to support UTF-8
    sys.stdout = open(sys.stdout.fileno(), mode="w", encoding="utf-8", buffering=1)
    START = default_timer()
    crawler("https://www.unixwinbsd.site", maxpages=1000)
    END = default_timer()
    print("Elapsed time (seconds) = " + str(END - START))
```

Change `"https://www.unixwinbsd.site"` with your domain. After that you can run crawling. Use Python VENV to open this application.


```yml
root@ns7:~ # cd /root/.cache/pypoetry
root@ns7:~/.cache/pypoetry # source bin/activate.csh
(pypoetry) root@ns7:~/.cache/pypoetry # cd PythonWebCrawler
(pypoetry) root@ns7:~/.cache/pypoetry/PythonWebCrawler # python crawlerino.py
```

<br/>
<img alt="Gitea FreBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/oct-25-21.jpg' | relative_url }}">
<br/>

In fact, there are many ways to crawl web data with Python. This depends on the complexity of the target location and the size of the project. For basic crawling and scraping tasks, the crawling application in this article is enough to call Googlebot.