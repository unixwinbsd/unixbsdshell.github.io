---
title: How to Install Ghost Blog on FreeBSD - Blogger Alternative
date: "2025-06-15 07:45:23 +0100"
updated: "2025-06-15 07:45:23 +0100"
id: install-ghost-blog-freebsd-blogger-alternative
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F36Install%20ghost%20blog%20on%20freebsd.jpg&commit=599f2082595470f07dca7f389d0aab1fe1a24563
toc: true
comments: true
published: true
excerpt: Ghost blogging helps individuals or organizations build a strong online presence and reputation by producing high-quality content that resonates with their target audience of readers. Ghost bloggers are typically hired by businesspeople, public figures, politicians, and others who want to maintain a consistent voice and image on their blog or website but don’t have the time, skills, or resources to write their own content
keywords: ghost, blog, writer, blogger, freebsd, seb server, alternative, ghost blog
---

You may have heard of ghost blogging or ghost writing. Many famous authors write celebrity biographies with "Ghost Writers" and you may be wondering if this service is available for any type of content writing.

The answer is yes! In fact, many web pages and blogs are written by ghostwriters. So, what is ghost blogging and how does it work? Let's find out.

For those who are not yet captivated by its furor, Ghost is a new blogging system that is much more minimalist than WordPress and other more popular systems. Ghost is one of the alternative blogging platforms that you should try besides blogger and wordpress. Ghost blog is rich in advanced features that make it run very fast.

Ghost is an alternative blogging app. The app is more performant than WordPress, and the editor is more developer-friendly because it is responsive to Markdown. In this article we will explain the process of installing and configuring `Ghost blog` on a `FreeBSD 14`system.


## 🏛️ 1. What is Ghost Blogging?
Ghost is a great app for professional writers and publishers to create, share, and grow their business around their content. It comes with a variety of modern tools for building websites, writing and publishing content, sending newsletters, and offering paid subscriptions to members.

There’s nothing creepy about ghost blogging! Ghost blogging is a writing platform for creators. Like Blogger, ghost blogging allows you to create content, such as blog posts, articles, and other written materials, for other people or organizations without receiving a byline (or credit) for your work. Instead, the content is typically published under the name of the person or organization hiring the ghost blogger, giving the impression that the content was written by the author.

Ghost blogging helps individuals or organizations build a strong online presence and reputation by producing high-quality content that resonates with their target audience of readers. Ghost bloggers are typically hired by businesspeople, public figures, politicians, and others who want to maintain a consistent voice and image on their blog or website but don’t have the time, skills, or resources to write their own content.

<br/>

<img alt="install ghost blog on freebsd" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F36Install%20ghost%20blog%20on%20freebsd.jpg&commit=599f2082595470f07dca7f389d0aab1fe1a24563' | relative_url }}">
<br/>


There are many benefits to using ghost bloggers, including:
- Helps to increase online visibility.
- Saves time: We live in a busy world, where we have to fulfill our obligations every minute of the day. Creating a quality blog takes time, which you might be better off leaving to someone else.
- Breaks down communication barriers.
- Demonstrates expertise: Ghost bloggers can research specialist subject areas themselves or take your expert knowledge and produce insightful articles that demonstrate your credibility and leadership in the field.
- Maintains consistency.
- Protects anonymity.
- Builds brand identity: Blogs are a great way for companies to interact with their audience. Brands use them to discuss opinions, provide feedback, and market products.

## 🏛️ 2. Update the FreeBSD system
The first step you should take is to make sure your FreeBSD system is up to date and all repositories are up to date. Open your terminal and run the following command.


```console
root@hostname1:~ # freebsd-update fetch
root@hostname1:~ # freebsd-update install
```
After that, update your package repositories.

```console
root@hostname1:~ # pkg update -f
root@hostname1:~ # pkg upgrade -f
```

## 🏛️ 3. Install NPM and node.js
Almost all Ghost Blogging features are javascript based. Therefore you need to install Java derivatives, namely [NPM and node.js](https://unixwinbsd.site/de/openbsd/2025/04/16/install-npm-node-js-on-openbsd/).

```console
root@hostname1:~ # pkg install npm-10.8.3
root@hostname1:~ # pkg install node20
root@hostname1:~ # pkg install npm-node20
```
Once you have installed NPM and node.js, make sure both applications are installed on your FreeBSD server. You can do this by checking the versions of both applications.

```console
root@hostname1:~ # node -v && npm -v
v20.17.0
10.8.3
```

## 🏛️ 4. How to Install mysql90-server and mysql90-client
MySQL database is used as the backend, which serves to store all Ghost user information and others. You don't have to use MySQL, you can also use `SQLite3 or MariaDB`. Follow these steps to install MySQL. For more details, you can read our previous article about the MySQL installation and configuration process on the FreeBSD system.

```console
root@hostname1:~ # pkg install databases/mysql90-client
root@hostname1:~ # pkg install databases/mysql90-server
```
Once you have finished installing `MySQL`, enable `MySQL` in the `/etc/rc.conf` file.

```console
root@hostname1:~ # ee /etc/rc.conf
mysql_enable="YES"
mysql_dbdir="/var/db/mysql"
mysql_confdir="/usr/local/etc/mysql"
mysql_optfile="/usr/local/etc/mysql/my.cnf"
#mysql_pidfile="/var/db/mysql/hostname1.pid
```
Then run restart MySQL server.

```console
root@hostname1:~ # service mysql-server restart

```
The next step is to create a password for your MySQL database, run the command below.

```console
root@hostname1:~ # mysql_secure_installation

```

### a. Create a database for ghost blogger
In order for the Ghost application to connect to the MySQL server, we must create a database named `"ghost"` which will be the backend of the Ghost blog.


## 🏛️ 5. How to Install Ghost-CLI
Ghost-CLI is a command-line tool to help you install and manage Ghost. You can install `ghost-cli` with the `npm command`, as in the example below.

```console
root@hostname1:~ # npm install -g ghost-cli
or
root@hostname1:~ # npm install ghost-cli@latest -g
```
Ghost is a powerful open-source publishing platform designed for professional blogging. Known for its clean design and robust features, it’s an excellent choice for anyone looking to create a personal blog or publication.

If you’re using FreeBSD, you may find the installation process a little different than other operating systems. This guide will walk you through the steps to install Ghost on FreeBSD.