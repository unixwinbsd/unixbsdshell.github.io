---
title: FreeBSD Tutorials To Create Web App With Node js
date: "2025-10-02 13:29:52 +0100"
updated: "2025-10-02 13:29:52 +0100"
id: freebsd-tutorials-create-web-app-with-node-js
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-52.jpg
toc: true
comments: true
published: true
excerpt: On the FreeBSD operating system, Node.js is bundled with the npm utility, which is the official package manager for Node.js and provides a command line interface (CLI) for interacting with an online registry to open source Node.js projects, modules, resources, and more
keywords: tutorials, npm, nodeJS, node, js, javascript, install, freebsd, linux, openbsd
---

Node.js is an application built on the Chrome JavaScript runtime, with Node.js it makes it easier for developers to create reliable, fast and scalable network applications. Node.js uses an event-driven, non-blocking I/O model, which makes it very lightweight and efficient, ideal for data-intensive real-time applications running on distributed devices.

Besides being able to build APIs, Node.js is great for creating standard web and static web applications. It has powerful tools to meet the needs of web developers. In this tutorial, you'll learn how to create a simple web application with Node.js While building, you'll learn several types of middleware, you'll see how to handle form submissions in Node.js, and you'll also be able to reference two models.

On the FreeBSD operating system, Node.js is bundled with the npm utility, which is the official package manager for Node.js and provides a command line interface (CLI) for interacting with an online registry to open source Node.js projects, modules, resources, and more.

![NodeJs Application Platform](https://raw.githubusercontent.com/unixwinbsd/FreeBSD_NodeJS_WebApp/refs/heads/main/NodeJs%20Application%20Platform.jpg){:loading='eager'}


Full code in this tutorial, you can download the complete code at "https://github.com/unixwinbsd/FreeBSD_NodeJS_WebApp.git"


## 1. Installing NPM and node.js

Before you start working with Node.js, make sure you have Node.js and NPM installed. If not, use the PKG FreeBSD package to start installing quickly.


```
root@ns7:~ # pkg install libuv && pkg install brotli && pkg install icu
```

The above command is used to install Node.js dependencies, after installing dependencies continue with installing Node.js.

```
root@ns7:~ # pkg install node && pkg install npm-10.2.5 && pkg install npm-node18
```

Check the NPM and Node.js versions.

```
root@ns7:~ # npm --version
root@ns7:~ # node --version
```

You can read the complete article on how to install Node.js at.

[How To Install NPM NodeJS On FreeBSD](https://unixwinbsd.site/openbsd/install-npm-node-js-openbsd)


## 2. Creating a Web App

Let's just create a Web App with Node.JS, create a new folder for your Node.js project and navigate to that folder using the terminal.

```
root@ns7:~ # cd /var
root@ns7:/var # mkdir -p WebAppNode
root@ns7:/var # cd WebAppNode
root@ns7:/var/WebAppNode #
```

The first thing you do is initialize our new module by running the init command from the npm utility. The `“npm init”` command will ask you a bunch of questions and then write the “package.json” file. This file is what will turn your code into a Node.js package.

```
root@ns7:/var/WebAppNode # npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help init` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg>` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
package name: (freebsd_nodejs_webapp)
version: (1.0.0)
description: Helping You To Do Learn Opensource UNIX BSD And Web Site With Blogger
entry point: (app.js)
test command: Success... Node.js test
git repository: https://github.com/unixwinbsd/FreeBSD_NodeJS_WebApp.git
keywords: FreeBSD Node.js Web App
author: Jhon Smith
license: (ISC)
About to write to /root/.cache/pypoetry/index/reverseproxy/www/FreeBSD_NodeJS_WebApp/package.json:

{
  "name": "freebsd_nodejs_webapp",
  "version": "1.0.0",
  "description": "Helping You To Do Learn Opensource UNIX BSD And Web Site With Blogger",
  "main": "app.js",
  "dependencies": {
    "accepts": "^1.3.8",
    "array-flatten": "^1.1.1",
    "body-parser": "^1.20.1",
    "bytes": "^3.1.2",
    "call-bind": "^1.0.5",
    "content-disposition": "^0.5.4",
    "content-type": "^1.0.5",
    "cookie": "^0.5.0",
    "cookie-signature": "^1.0.6",
    "debug": "^2.6.9",
    "define-data-property": "^1.1.1",
    "depd": "^2.0.0",
    "destroy": "^1.2.0",
    "ee-first": "^1.1.1",
    "encodeurl": "^1.0.2",
    "escape-html": "^1.0.3",
    "etag": "^1.8.1",
    "express": "^4.18.2",
    "finalhandler": "^1.2.0",
    "forwarded": "^0.2.0",
    "fresh": "^0.5.2",
    "function-bind": "^1.1.2",
    "get-intrinsic": "^1.2.2",
    "gopd": "^1.0.1",
    "has-property-descriptors": "^1.0.1",
    "has-proto": "^1.0.1",
    "has-symbols": "^1.0.3",
    "hasown": "^2.0.0",
    "http-errors": "^2.0.0",
    "iconv-lite": "^0.4.24",
    "inherits": "^2.0.4",
    "ipaddr.js": "^1.9.1",
    "media-typer": "^0.3.0",
    "merge-descriptors": "^1.0.1",
    "methods": "^1.1.2",
    "mime": "^1.6.0",
    "mime-db": "^1.52.0",
    "mime-types": "^2.1.35",
    "ms": "^2.0.0",
    "negotiator": "^0.6.3",
    "object-inspect": "^1.13.1",
    "on-finished": "^2.4.1",
    "parseurl": "^1.3.3",
    "path-to-regexp": "^0.1.7",
    "proxy-addr": "^2.0.7",
    "qs": "^6.11.0",
    "range-parser": "^1.2.1",
    "raw-body": "^2.5.1",
    "safe-buffer": "^5.2.1",
    "safer-buffer": "^2.1.2",
    "send": "^0.18.0",
    "serve-static": "^1.15.0",
    "set-function-length": "^1.1.1",
    "setprototypeof": "^1.2.0",
    "side-channel": "^1.0.4",
    "statuses": "^2.0.1",
    "toidentifier": "^1.0.1",
    "type-is": "^1.6.18",
    "unpipe": "^1.0.0",
    "utils-merge": "^1.0.1",
    "vary": "^1.1.2"
  },
  "devDependencies": {},
  "scripts": {
    "test": "Success... Node.js test"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/unixwinbsd/FreeBSD_NodeJS_WebApp.git"
  },
  "keywords": [
    "FreeBSD",
    "Node.js",
    "Web",
    "App"
  ],
  "author": "Jhon Smith",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/unixwinbsd/FreeBSD_NodeJS_WebApp/issues"
  },
  "homepage": "https://github.com/unixwinbsd/FreeBSD_NodeJS_WebApp#readme"
}


Is this OK? (yes) yes
```


### a. Main script file

The main Node.js script file is usually the starting point of a Node.js module. By default, the script name is index.js. In this example, we named it webapp.js, the file will start our Node.js project development test server. We will implement this later in the article.

Now we can start writing the script. Create an `"app.js"` file to store your web server code.

```
root@ns7:/var/WebAppNode # touch app.js
```

The contents of the `"app.js"` file should look like this.

```
const express = require('express');
const app = express();
const path = require('path');


app.get('/', (req,res) => {
  res.sendFile(path.join(__dirname+'/index.html'));
  
});


app.get('/about', (req,res) => {
    res.sendFile(path.join(__dirname+'/about.html'));
   
  });

app.listen(3000, () => {
    console.log('Listening on port 3000');
});
```

This code creates a simple server that listens on port 3000 and responds to requests to the Node.js directory.


### b. Module Requirements

Once the `“package.json”` and `"app.js"` file is ready, you can install the js package framework using `“npm install --save-dev express”`. In your terminal, run the following command.

```
root@ns7:/var/WebAppNode # npm install --save-dev express
```

The command above will also create a node_modules folder in your project directory, then the Express dependencies will be included in the contents of the `"package.json"` file. the "npm install `--save-dev express"` command will also tell npm to save the dependency to the `"package.json"` file.

After that we create the files `"about.html"` and `"index.html"`.

```
root@ns7:/var/WebAppNode # touch index.html
root@ns7:/var/WebAppNode # touch about.html
```

The contents of the `"/var/about.html"` file should look like this.

```
<!DOCTYPE html>
<head>
    <title> About Us Page </title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  </head>
  <body>
    <div style="margin:6px;">
      <nav class="navbar navbar-inverse navbar-static-top">
    <div class="container">
      <a class="navbar-brand" href="/"> unixwinbsd.site </a>
      <ul class="nav navbar-nav">
        <li>
          <a href="/">Home</a>
        </li>
        <li class="active">
          <a href="/about">About</a>
        </li>
      </ul>
    </div>
  </nav>
      <div class="jumbotron"  style="padding:40px;">
        <h1>About Us</h1>
        <strong><p> Helping You To Do Learn Opensource UNIX BSD And Web Site With Blogger.</p></strong>
        <p><a class="btn btn-primary btn-lg" href="#" role="button">Click here to Join us</a></p>
      </div>
    </div>
  </body>
</html>
```

The contents of the  `"/var/index.html"` file should look like this.

```
<!DOCTYPE html>
<head>
    <title> DevOps HomePage </title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  </head>
  <body>
    <div style="margin:6px;">
      <nav class="navbar navbar-inverse navbar-static-top">
    <div class="container">
      <a class="navbar-brand" href="/"> unixwinbsd.site </a>
      <ul class="nav navbar-nav">
        <li class="active">
          <a href="/"> Home </a>
        </li>
        <li>
          <a href="/about"> About </a>
        </li>
      </ul>
    </div>
  </nav>
      <div class="jumbotron"  style="padding:40px;">
        <h1> Hello FreeBSD  <span class="text-primary"> The Power </span><span class="text-danger"> To Server </span></h1>
        <p> Subscribe to Channel for  <span class="bg-info"> More </span> & Interesting <span class="bg-success"> FreeBSD  Tutorials </span></p>
        <p><a class="btn btn-primary btn-lg" href="#" role="button">What's New</a></p>
      </div>
    </div>
  </body>
</html>
```

Now, run your Node.js `"Web App"` project with the following command.

```
root@ns7:/var/WebAppNode # node app.js
Listening on port 3000
```

You can see the results by opening Google Chrome and entering the command `"127.0.0.1:3000"`.


![Resul WebApp NodeJS](https://raw.githubusercontent.com/unixwinbsd/FreeBSD_NodeJS_WebApp/refs/heads/main/Resul%20WebApp%20NodeJS.jpg){:loading='eager'}


Now that you know how to create a standard web application in Node.js, you can take it a step further by extending the application—with add, delete and other commands. We hope this tutorial helps you get up and running with a simple Node.js application on a FreeBSD server.