---
title: How to Install Jekyll on Ubuntu - Static Web Development Guide
date: "2025-09-23 08:23:32 +0100"
updated: "2025-09-23 08:23:32 +0100"
id: install-jekyll-on-ubuntu-static-web-development
lang: en
author: Iwan Setiawan
robots: index, follow
categories: Linux
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-23.jpg
toc: true
comments: true
published: true
excerpt: Jekyll is written in Ruby, so to install and use Jekyll on Ubuntu 22.04, you will need to install Ruby and other required packages
keywords: ruby, jekyll, static, web, blog, development, guide, github, ubuntu, debian
---

How to Install Jekyll on Ubuntu - Static Web Development Guide
install-jekyll-on-ubuntu-static-web-development.md

Jekyll is a versatile and easy-to-use static website generator that lets you create stunning websites with ease. Whether you're an experienced developer or an aspiring blogger, Jekyll provides a simple and efficient way to build and manage your website. In this article, we'll walk you through installing Jekyll on Ubuntu 24.04, allowing you to harness the power of this powerful tool.

Not only can you create a blog without a database, but you can also host your blog for free on GitHub if you don't have a server. Jekyll is especially useful if you want to be able to create static websites from the terminal.

In this tutorial, you'll learn how to install Jekyll on Ubuntu 22.04 and how to create a website using it.


## A. Specifications of the Computer Used

<br/>

<img alt="Jekyll On Ubuntu" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-23.jpg' | relative_url }}">

<br/>

## B. Update APT

Before installing Jekyll, be sure to update the package database on your Ubuntu 24.04 machine. Updating the package database is necessary before installing Jekyll to ensure it installs smoothly.

Check for updates on your Ubuntu 24.04 by running the command below.


```
ns4@iwans:~$ sudo apt update -y
```

And proceed to upgrade the outdated packages, using the upgrade command.

```
ns4@iwans:~$ sudo apt upgrade -y
```

## C. Install Ruby and Create a GEM PATH

Jekyll is written in Ruby, so to install and use Jekyll on Ubuntu 22.04, you will need to install Ruby and other required packages.

To do this, just run the command below.

```
ns4@iwans:~$ sudo apt install ruby-full build-essential zlib1g-dev
```

Now you need to add the Ruby package manager to your ~/.bashrc file to ensure you can use Rubygems to install Jekyll in the next step.

Add the following script to your `~/.bashrc` file.

```
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"
```

Next, proceed to source `~/.bashrc` for the changes to take effect.

```
ns4@iwans:~$ source ~/.bashrc
```

## D. Jekyll Installation Process

Once you've updated your system and installed the Jekyll requirements, you can now install Jekyll on your Ubuntu 22.04 computer.

To install Jekyll, run the following command.

```
ns4@iwans:~$ sudo apt-get -y install ruby-bundler
ns4@iwans:~$ sudo apt-get -y install ruby-rubygems
ns4@iwans:~$ sudo apt-get -y install jekyll
```

Let's continue by looking at the versions of each of the applications you have installed above. 

```
ns4@iwans:/$ jekyll -v
jekyll 4.4.1
```

<br/>

```
ns4@iwans:/$ su root
Password: 
root@iwans:/# bundler -v
Bundler version 2.6.5
root@iwans:/# gem -v
3.4.20
root@iwans:/# ruby -v
ruby 3.2.3 (2024-01-18 revision 52bb2ac0a6) [x86_64-linux-gnu]
```

Next, you'll see the following output in your terminal. This means Jekyll is being installed on your system, so all you need to do now is wait for the installation process to complete.

Once you've finished installing Jekyll, by default,
Jekyll will open port 4000. Enable this port so it can be used immediately.

```
ns4@iwans:~$ sudo ufw allow 4000
ns4@iwans:~$ sudo ufw enable
```

## E. Creating a Website with Jekyll

Once you've completed all of this, you should be able to create a website using Jekyll. Creating a site in Jekyll is quite easy, and you can easily create one by following the steps below.

```
ns4@iwans:~$ sudo mkdir -p /home/blogjekyll
ns4@iwans:~$ cd /home/blogjekyll
ns4@iwans:/home/blogjekyll$
```

After that, you need to create a directory where your site files will be hosted. The directory name should be your website name.

```
ns4@iwans:/home/blogjekyll$ sudo jekyll new blogsite
ns4@iwans:/home/blogjekyll$ cd blogsite
ns4@iwans:/home/blogjekyll/blogsite$ 
```

The next step is to run Jekyll with the command below.

```
ns4@iwans:/$ su root
Password: 
root@iwans:/# cd /home/blogjekyll/blogsite
root@iwans:/home/blogjekyll/blogsite# bundle exec jekyll serve --host 127.0.0.1
```

To see the results, you can open Google Chrome or Yandex Browser and type "http://127.0.0.1:4000".

Congratulations! If you've made it this far, Jekyll is up and running on your system and ready to build some awesome websites. Using Jekyll has saved you a lot of time and effort in building websites. You can also take advantage of Jekyll's capabilities to easily create and customize static websites.