---
title: Node JS and NPM Installation Guide on Ubuntu
date: "2025-10-11 07:25:10 +0100"
updated: "2025-10-11 07:25:10 +0100"
id: node-js-npm-installation-guide-ubuntu
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: SysAdmin
background: /img/oct-25/oct-25-62.jpg
toc: true
comments: true
published: true
excerpt: Node.js dibangun di atas mesin JavaScript V8 milik Google, yang mengompilasi JavaScript langsung menjadi kode mesin asli. Hal ini memastikan pemrosesan kode yang cepat, yang memungkinkan aplikasi Node.js menangani beban tinggi dengan baik.
keywords: ubuntu, node, js, npm, installation, guide
---

Node.js is a server-side JavaScript runtime environment based on Google's V8 JavaScript engine that has become extremely popular in recent years. Its first edition was published in 2010. Over this time, Node.js has evolved from a daring experiment to a market leader, backed by Microsoft, Google, IBM, LinkedIn, NASA, and many others.

Node.js has several key features, including:

- First, Node.js operates on an asynchronous, event-driven model. This allows it to process multiple requests simultaneously without having to wait for a single operation to complete. This makes it suitable for I/O-intensive applications.
- Second, it can manage multiple connections simultaneously thanks to its event loop, making it lightweight and efficient.
- The third feature is its fast operation. Node.js is built on Google's V8 JavaScript engine, which compiles JavaScript directly into native machine code. This ensures fast code processing, allowing Node.js applications to handle high loads well.

<br/>
<img alt="Tutorial Install Node.js and NPM On Ubuntu" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ '/img/oct-25/oct-25-62.jpg' | relative_url }}">
<br/>

Additionally, Node.js comes with a sophisticated package management system called NPM, which provides access to a vast repository of libraries and modules. This makes it easy for developers to share and reuse code, speeding up the development process.


## A. System Specifications
- OS: Ubuntu 24.04.2 LTS x86_64 
- Host: B55PS.AR5M50D TA001 
- Kernel: 6.8.0-54-generic 
- Uptime: 2 hours, 13 mins 
- Packages: 1065 (dpkg) 
- Shell: bash 5.2.21 
- Resolution: 1024x768 
- WM: Openbox 
- WM Theme: Typewriter 
- Theme: Minwaita-Vanilla [GTK2/3] 
- Icons: Vivacious-NonMono-Light-Blue [GTK2/3] 
- Terminal: x-terminal-emul 
- CPU: Intel i3-2100 (4) @ 3.100GHz
- GPU: Intel 2nd Generation Core Processor Family
- Memory: 4102MiB / 7834MiB


## B. Installing Node JS with apt via the Ubuntu repositories

This method is for beginners and those who don't want to bother. The Ubuntu repositories contain stable versions, but not the latest ones. It's suitable for getting to know Node, but it's not recommended for use in production.

Let's update the repository information configured on the machine:


```shell
ns4@iwans:~$ sudo apt update
```

Next, install Node.js using the apt install nodejs command. The `-y` option will automatically answer `"yes"` to the program's questions.

```console
ns4@iwans:~$ sudo apt install nodejs -y
```

This is enough to start creating your own programs in Node.js. In the future, npm will be required to download additional modules. Here's the command in Ubuntu's package manager to install npm.


```console
ns4@iwans:~$ sudo apt install npm -y
```

To check whether Node JS and NPM are installed on Ubuntu, run the command below.


```console
ns4@iwans:~$ node -v && npm -v
v18.19.1
9.2.0
```

## C. How to Run Node.js / NPM

So, we've looked at several ways to install Node.js. Let's say you've chosen one of the methods and installed what you need. To ensure everything works, it's not enough to just print the version. Let's try creating a primitive application and verify it works correctly.

In this example, we'll create a file called `"testnode.js"` and save it in the `"/tmp"` folder.


```
ns4@iwans:~$ cd /tmp
ns4@iwans:/tmp$ touch testnode.js
```
In the file `"/tmp/test node.js"`, you type the script below.

```
console.log('Timeweb Cloud')
```

Then you run the file, and see the results in your shell menu.

```
s4@iwans:/tmp$ sudo node testnode.js
Timeweb Cloud
```

Today, Node.js is considered one of the leading technologies for web development. Many large companies like PayPal, Yahoo, eBay, General Electric, Microsoft, and Uber use this platform to build their websites.

There are several ways to install Node.js. The method you choose depends on your goals. For beginners, the version from the distribution repositories is suitable. Newer versions can be obtained from the NodeSource PPA. The NVM program will help you install multiple versions simultaneously and easily manage them. And in unusual situations, Node.js can be installed from an archive with binaries or compiled from its source code.