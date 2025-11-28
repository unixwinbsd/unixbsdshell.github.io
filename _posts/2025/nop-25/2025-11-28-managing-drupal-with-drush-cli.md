---
title: FreeBSD Tutorial - Managing Drupal CMS with Drush CLI
date: "2025-11-28 07:15:27 +0000"
updated: "2025-11-28 07:15:27 +0000"
id: managing-drupal-with-drush-cli
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: WebServer
background: 
toc: true
comments: true
published: true
excerpt: This guide will cover just a few of the many commands. The entire content of this article runs on a FreeBSD 13.2 server, but it can also be implemented on Linux or macOS systems.
keywords: freebsd, drupal, practical, instruction, configuring, drush, drush cli, command line, interface, framework, cms, bootstrap
---

Drush, also known as The Drupal Shell, is a Unix command-line shell and scripting interface for Drupal installations. This shell allows access to common Drupal features and tasks from the command line. With Drush commands, you can easily update Drupal core files, update modules, and run SQL queries.

Drush is a must-have utility for managing one or multiple Drupal installations. It can help speed up common tasks for Drupal site builders, developers, and DevOps teams. Furthermore, it makes it easy to integrate Drupal into CI/CD workflows.

This guide will cover just a few of the many commands. The entire content of this article runs on a FreeBSD 13.2 server, but it can also be implemented on Linux or macOS.

## 1. About Drush

Drush is built in the PHP programming language and can run in a terminal shell. Drush is used to support Drupal projects, allowing you to easily interact with one or more Drupal projects. The Drush core includes commands for performing common tasks such as managing configurations, performing database updates, and clearing caches. Drush also provides utilities for running SQL queries and migrations, and generating scaffolding code for frequently used Drupal core APIs.

Drush can automate many Drupal tasks. Users typically perform various steps in the Drupal UI, which can be time-consuming. With Drush, everything can be easily executed with just a CLI command.

For example, a website may require updates for various reasons, such as security issues or updated modules. Choosing to update modules through conventional methods can be a time-consuming task, requiring numerous clicks and other settings. However, Drush makes things easier and saves you time by allowing you to update your website with just one command line.

With Drush, you can quickly work in Drupal using the command line. However, you should back up your site and database first.

## 2. Install Drush

Drush cannot run without Drupal, but Drupal can run without it. If you want to use Drush, install Drupal first. Here's how to install Drupal on FreeBSD.

```yml
root@ns3:~ # cd /usr/ports/www/drupal10
root@ns3:/usr/ports/www/drupal10 # make install clean
```

You can read a complete guide on how to install Drupal in our previous article, ["FreeBSD Tutorial - How to Install Drupal to Create a Blog"](https://unixwinbsd.site/freebsd/drupal-with-drush-cli-composer-php-freebsd/).

Before installing Drush, there's a dependency you need to install: `"php82-phar"`.

```yml
root@ns3:~ # pkg install php82-phar
```

We recommend that you use the system port to install `Drush`, follow the commands below.

```yml
root@ns3:~ # cd /usr/ports/www/drush
root@ns3:/usr/ports/www/drush # make install clean
```

Let's start by looking at the status of Drush, using the status command.

```console
root@ns3:~ # drush status
 PHP configuration      :  /usr/local/etc/php.ini
 PHP OS                 :  FreeBSD
 Drush script           :  /usr/local/bin/drush.phar
 Drush version          :  8.4.12
 Drush temp directory   :  /tmp
 Drush configuration    :
 Drush alias files      :
 ```

 ## 3. How to Use Drush

You can find all the basic Drush commands in Drush core, but there are many specific Rules commands provided by the Rules module and the Rules Basics module. Below are some common examples of Drush command usage.

### 3.1. Update Commands

Check for available updates.

```yml
root@ns3:~ # drush pm-updatestatus
```

### 3.2. How to Update Drupal core and contrib projects

```yml
root@ns3:~ # drush pm-updatecode
```

### 3.3. How to Update Drupal database tables

```yml
root@ns3:~ # drush updatedb
```

### 3.4. How to Update Drupal core and contrib projects, and apply

```yml
root@ns3:~ # drush pm-update
```

### 3.5. Cache, List and Help Commands

How to clear cache files.

```console
root@ns3:~ # drush cache-clear
Enter a number to choose which cache to clear.
 [0]  :  Cancel
 [1]  :  drush
1
'drush' cache was cleared.
```

How to clear all cache files.

```yml
root@ns3:~ # drush cache-clear all
```

View a list of all available modules and themes.

```yml
root@ns3:~ # drush pm-list
root@ns3:~ # drush pm-info
```

You can see other Drush commands in the "help" command.

```yml
root@ns3:~ # drush help
```

### 3.6. Install, Enable, and Uninstall Plugins

To install a selected plugin, you must download it before activating it.

```console
root@ns3:~ # drush dl addtoany
Project addtoany (7.x-4.19) downloaded to /root/addtoany.
```

To enable the module installed in the example above, you need to run the command below.

```yml
root@ns3:~ # drush en addtoany
```

How to delete plugins.

```yml
root@ns3:~ # drush pm-uninstall addtoany
```

If your website or blog uses Drupal, using Drush is inevitable, as it simplifies module updates, database maintenance, and backups. So, Drupal and Drupal are inseparable.
