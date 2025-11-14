---
title: Creating a Web Crawling Googlebot with Colly on FreBSD 14
date: "2025-04-15 08:01:15 +0100"
updated: "2025-04-15 08:01:15 +0100"
id: web-crawling-google-bot-colly-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/colly.jpg
toc: true
comments: true
published: true
excerpt: Web crawling is a technique that allows you to examine, parse, and extract data that may be difficult to access from a blog or website.
keywords: web crawling, crawler, colly, java, openjdk, intellij, freebsd, google bot, google crawler, crawler
---

Web crawling is a technique that allows you to examine, parse, and extract data that may be difficult to access from a blog or website. Web crawling is done systematically, starting with a "seed" URL, and recursively visiting the links the crawler finds on each page visited.

The Colly library is a Go package that can be used to create web scrapers and web crawlers. It is based on Go's net/HTTP (for network communication) and goquery (which allows you to use a "jQuery-like" syntax to target HTML elements).

With Colly, you can easily extract structured data from a blogsite or Web Application. You can use this data for various applications, such as data mining, data processing, or data archiving.

**Colly Key Features:**
* Clean API.
* Google App Engine support.
* Fast (capable of performing >1k requests/second on a single core).
* Manages request delays and maximum concurrency per domain.
* Sync/async/parallel scraping.
* Distributed scraping.
*Can cache data.
* Automatic encoding of non-unicode responses.
* Robots.txt support.
* Automatic cookie and session handling.
* Configuration via environment variables.
* Extensions.

In this article, we will use the Go programming language, a popular scripting language from Google, and one of the packages we will use is Colly.

Building a crawler in Go and Colly is easy. In this article, I will show you how to create a basic script that can check the health of links, labels, and images across a website. I will also share some things that will help you build a professional crawler.



## 1. How to Install Colly
Because the Colly library runs in GO language, then as a first step we install the GO application first. To speed up the installation process, you can use the FreeBSD PKG package.

```console
root@ns7:~ # pkg install go
```
Now it's time to install Colly, to get the complete Colly library we simply use the FreeBSD Port system.

```console
root@ns7:~ # cd /usr/ports/www/colly
root@ns7:/usr/ports/www/colly # make install clean
```
We will create a new directory to store all the projects we will be working on with Colly.

```console
root@ns7:/usr/ports/www/colly # mkdir -p /usr/local/etc/colly
root@ns7:/usr/ports/www/colly # cd /usr/local/etc/colly
```
To create a new scraper, we can use the command below.

```console
root@ns7:/usr/local/etc/colly # colly new crawlingblogsite.go
root@ns7:/usr/local/etc/colly # ls
crawlingblogsite.go
```
You have successfully created a scraper file named `"/usr/local/etc/colly/crawlingblogsite.go"`. You can see the contents of the `"/usr/local/etc/colly/crawlingblogsite.go"` file below.

```go
package main

import (
        "log"

        "github.com/gocolly/colly/v2"
)

func main() {
        c := colly.NewCollector()

        c.Visit("https://yourdomain.com/")
}
```
Change the domain name to your own domain, for example "https://unixwinbsd.site".


## 2. Colly Web Crawler
Colly’s main entity is the Collector structure. The Collector keeps track of every page that is queued to be visited, manages network communication, and is responsible for running attached callbacks while pages are being scraped.

Colly provides us with a number of callbacks that can be set or not. These callbacks will be called at various stages in the crawling process, and we must decide which ones to choose based on our needs. Here is a list of all the callbacks and the order in which they are called.

- `OnResponse(f ResponseCallback)` Called after response received.
- `OnRequest(f RequestCallback)` Called before a request.
- `OnXML(xpathQuery string, f XMLCallback)` Called right after OnHTML if the received content is HTML or XML.
- `OnError(f ErrorCallback)` Called if error occured during the request.
- `OnHTML(goquerySelector string, f HTMLCallback)` Called right after OnResponse if the received content is HTML.
- `OnScraped(f ScrapedCallback)` Called after OnXML callbacks.


Okay, let's start making a web crawler with Colly. The first step is to edit the file `"/usr/local/etc/colly/crawlingblogsite.go"`, then we delete all its contents, then add the script below to the file.

```go
package main

import (
	"flag"
	"fmt"
	"net/url"
	"os"
	"regexp"
	"time"

	"github.com/gocolly/colly"
	_ "go.uber.org/automaxprocs"
)

var (
	domain, header            string
	parallelism, delay, sleep int
	daemon                    bool
)

func init() {
	flag.StringVar(&domain, "domain", "", "Set url for crawling. Example: https://example.com")
	flag.IntVar(&parallelism, "parallelism", 2, "Parallelism is the number of the maximum allowed concurrent requests of the matching domains")
	flag.IntVar(&delay, "delay", 1, "Delay is the duration to wait before creating a new request to the matching domains")
	flag.BoolVar(&daemon, "daemon", false, "Run crawler on daemon mode")
	flag.IntVar(&sleep, "sleep", 60, "Time in seconds to wait before run crawler again")
	flag.StringVar(&header, "header", "", "Set header for crawler request. Example: header_name:header_value")
}

func crawler() {
	u, err := url.Parse(domain)

	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		os.Exit(1)
	}

	// Instantiate default collector
	c := colly.NewCollector(
		// Turn on asynchronous requests
		colly.Async(true),
		// Visit only domain
		colly.AllowedDomains(u.Host),
	)

	// Limit the number of threads
	c.Limit(&colly.LimitRule{
		DomainGlob:  u.Host,
		Parallelism: parallelism,
		Delay:       time.Duration(delay) * time.Second,
	})

	// On every a element which has href attribute call callback
	c.OnHTML("a[href]", func(e *colly.HTMLElement) {
		link := e.Attr("href")
		// Visit link found on page
		// Only those links are visited which are in AllowedDomains
		c.Visit(e.Request.AbsoluteURL(link))
	})

	if len(header) > 0 {
		c.OnRequest(func(r *colly.Request) {
			reg := regexp.MustCompile(`(.*):(.*)`)
			headerName := reg.ReplaceAllString(header, "${1}")
			headerValue := reg.ReplaceAllString(header, "${2}")
			r.Headers.Set(headerName, headerValue)
		})
	}

	c.OnResponse(func(r *colly.Response) {
		fmt.Println(r.Request.URL, "\t", r.StatusCode)
	})

	c.OnError(func(r *colly.Response, err error) {
		fmt.Println(r.Request.URL, "\t", r.StatusCode, "\nError:", err)
	})

	fmt.Print("Started crawler\n")
	// Start scraping
	c.Visit(domain)
	// Wait until threads are finished
	c.Wait()
}

func main() {
	flag.Parse()

	if len(domain) == 0 {
		fmt.Fprintf(os.Stderr, "Flag -domain required\n")
		os.Exit(1)
	}

	if daemon {
		for {
			crawler()
			fmt.Printf("Sleep %v seconds before run crawler again\n", sleep)
			time.Sleep(time.Duration(sleep) * time.Second)
		}
	} else {
		crawler()
	}
}
```
Then you continue with the following command.

```console
root@ns7:/usr/local/etc/colly #  go mod colly
root@ns7:/usr/local/etc/colly # go get go.uber.org/automaxprocs
root@ns7:/usr/local/etc/colly # go get github.com/gocolly/colly
```

To run a web crawler, we need to add some **"flags"**.
- **daemon:** Run the crawler in daemon mode.
- **delay int:** Duration to wait before making a new request to a matching domain (default 1).
- **domain string:** Set url for crawling. Example: https://unixwinbsd.site.
- **header string:** Set headers for crawler requests. Example: header_name:header_value.
- **parallelism int: Parallelism is the maximum number of concurrent requests allowed from a matching domain (default 2).
- **sleep int:** Time in seconds to wait before running the crawler again (default 60).

Usage examples:

```console
root@ns7:/usr/local/etc/colly # go run crawlingblogsite.go -domain https://www.unixwinbsd.site -header header_name:header_value -daemon
```

<br/>
{% lazyload data-src="/img/oct-25/colly.jpg" src="/img/oct-25/colly.jpg" alt="Colly web crawler Java OpenJDK For Google Crawler" %}
<br/>

Or, as a practical way, you can download the Colly Web Crawler repository from Github.

```console
root@ns7:~/.cache/pypoetry/index # git clone https://github.com/unixwinbsd/CollyWebCrawling.git
```
Now you have your own web crawler, and ready to use anytime. Do it every day by crawling your Blogsite or website, so that Googlebot can quickly index the URLs on our blogsite.