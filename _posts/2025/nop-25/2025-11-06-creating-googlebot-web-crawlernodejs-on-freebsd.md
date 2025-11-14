---
title: Creating a GoogleBot Web Crawler NodeJS on FreeBSD
date: "2025-11-06 08:33:46 +0000"
updated: "2025-11-06 08:33:46 +0000"
id: creating-googlebot-web-crawlernodejs-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-009.jpg
toc: true
comments: true
published: true
excerpt: In this article we will create a web scraper with NodeJs, we will show how to create a web crawler in Node js to scrape websites and store the retrieved data in a database.
keywords: freebsd, java, openjdk, npm, node, nodejs, web crawling, crawler, index, sitemap, crawler, google, yandex
---

Web scrapers and search engines rely on web crawling to extract information from the web. With web crawling, web URLs quickly appear in Google search results. As a result, web crawlers are becoming increasingly popular.

Creating a web spider project with the right library, like Node.js, is easy. Here, you'll learn how to create a JavaScript web crawler using the most popular web crawling library, Node.js.

In this article, we'll create a web scraper with Node.js. We'll show you how to create a web crawler in Node.js to scrape websites and store the extracted data in a database. Our web crawler will perform web scraping and data transfer using Node.js worker threads.

The benefits of using a Node.JS web crawler include:

- Web crawling with a Node crawler.
- Using JavaScript, making Node.js ideal for web scraping.
- Web scraping with worker threads in Node.js.
- Implementing a basic crawler with Cheerio and Axios.
- Best practices and crawler improvement techniques.
- Browser automation and proxies for evasion.

## 1. Web Crawling in Node.js

Besides indexing the world wide web, crawling can also collect data from websites. This is known as web scraping. The web scraping process can be quite demanding on a computer's CPU, depending on the site structure and the complexity of the data being extracted. You can use the number of threads used to optimize the CPU-intensive operations required for web scraping in Node.js.

With Java support, Node.js is widely used because it is a lightweight, high-performance, efficient, and easy-to-configure platform.

The event loop in JavaScript is a crucial component that allows Node.js to efficiently perform large-scale web crawling tasks. JavaScript can perform one task at a time, compared to other languages ​​like C or C++, which use multiple threads to perform multiple tasks simultaneously.

The underlying issue lies in the JavaScript language, which can't run multiple tasks in parallel, but can run multiple tasks simultaneously. JavaScript can't process all web crawling tasks simultaneously.

<br/>
<img alt="npm node js APP" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-009.jpg' | relative_url }}">
<br/>

JavaScript and NodeJS, when executing web scraping tasks, mean Node.js can start a task (such as making an HTTP request) and continue executing other code without waiting for the task to complete. Node.js's non-blocking nature allows it to efficiently manage multiple concurrent operations.

When executing web crawling tasks, Node.js uses an event-driven architecture. When an asynchronous operation, such as a network request or file read, completes, it triggers an event. The event loop listens for this event and dispatches a callback function to handle it. This event-driven model ensures Node.js can handle multiple concurrent tasks without any blocking.

## 2. Installing NodeJS on FreeBSD

Node.js doesn't require fancy or expensive hardware; most modern computers can run NodeJS efficiently. Even the smallest computers, like the BeagleBone or Arduino YÚN, ​​can run NodeJS. However, much still depends on the memory software you're running on the same system.

Each operating system has a different method and method for installing NodeJS. The core setup file differs for each operating system. However, the Node.js creators have taken care to provide the necessary files for each operating system.

On FreeBSD, NodeJS is run by the Node Package Manager. Therefore, you'll need to install NPM and Node to run NodeJS on FreeBSD. Here's a guide to installing NodeJS on FreeBSD.

```yml
root@ns7:~ # pkg install brotli && pkg install icu && pkg install libuv
```

After that you run the following command.

```yml
root@ns7:~ # cd /usr/ports/www/node
root@ns7:/usr/ports/www/node # make install clean
```

The last package you need to install is the Node Package Manager (NPM) with Node.js. NPM is an open-source library of Node.js packages. To install NPM on FreeBSD, use the following command:

```yml
root@ns7:~ # cd /usr/ports/www/npm-node18
root@ns7:/usr/ports/www/npm-node18 # make install clean
```

You can read a complete explanation of how to install NodeJS [in the previous article](https://unixwinbsd.site/freebsd/how-to-install-npm-node-js-on-freebsd14/).

## 3. Web Crawler with NodeJS

This CLI application crawls the user-supplied base URL and all its subpages. The NodeJS web crawler then divides the links into internal and external links. Internal links are links that point to other pages on the same domain. External links are links that point to other domains on your website. For each link, it counts the number of occurrences and displays the final results in descending order. The output is divided into internal and external links and printed to the terminal, where the output is saved in a .csv file.

To start the NodeJS web crawler, we have provided a script on the GitHub server. Clone the repository to your computer and run the following command in the directory where you placed the clone from GitHub.

```yml
root@ns7:~ # cd /var
root@ns7:/var # git clone https://github.com/unixwinbsd/WebCrawler-NodeJS-FreeBSD.git
root@ns7:/var # cd WebCrawler-NodeJS-FreeBSD
root@ns7:/var/WebCrawler-NodeJS-FreeBSD #
```

Use the `"ci"` command to start the installation.

```yml
root@ns7:/var/WebCrawler-NodeJS-FreeBSD # npm ci
```

Use the `"init"` command to initialize the application.

```console
root@ns7:/var/WebCrawler-NodeJS-FreeBSD # npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help init` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg>` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
package name: (web-crawler_js)
version: (1.0.0)
keywords:
author:
license: (ISC)
About to write to /var/WebCrawler-NodeJS-FreeBSD/package.json:

{
  "name": "web-crawler_js",
  "version": "1.0.0",
  "description": "You must have Node.js installed on your computer. This project was developed using Node.js v18.7.0",
  "main": "index.js",
  "scripts": {
    "test": "jest",
    "start": "node index.js"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "jest": "^29.3.1"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/Sunkio/web-crawler_js.git"
  },
  "bugs": {
    "url": "https://github.com/Sunkio/web-crawler_js/issues"
  },
  "homepage": "https://github.com/Sunkio/web-crawler_js#readme",
  "dependencies": {
    "jsdom": "^21.1.2",
    "json2csv": "^6.0.0-alpha.2"
  }
}


Is this OK? (yes) yes
```

In the "npm init" command, there are several options you need to fill in. Simply press Enter to speed up the process. Finally, type "yes" and press Enter to finish.

Run the following command to continue the installation.

```yml
root@ns7:/var/WebCrawler-NodeJS-FreeBSD # npm install jest --save-dev
root@ns7:/var/WebCrawler-NodeJS-FreeBSD # npm install jsdom
root@ns7:/var/WebCrawler-NodeJS-FreeBSD # npm install json2csv
```

Run the command `“npm start”` to start the NodeJS web crawler.

```console
root@ns7:/var/WebCrawler-NodeJS-FreeBSD # npm start

> web-crawler_js@1.0.0 start
> node index.js

Which URL do you want to crawl?https://www.unixwinbsd.site
```

Then, simply follow the instructions. The program will ask for the URL you want to search. Enter the URL you want to search. The program will then search the URL and all its subpages. The results will be displayed in the terminal and exported to a .csv file. The file will be saved in the reports directory.

<br/>
<img alt="NPM Start Web Crawling" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-010.jpg' | relative_url }}">
<br/>

In this tutorial, we've learned how to create a web crawler that collects data from your website and stores it in a database. Perform web crawls daily and regularly to ensure your website's page URLs are quickly indexed and appear in search engines.
