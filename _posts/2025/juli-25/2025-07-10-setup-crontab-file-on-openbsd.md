---
title: Setting up a crontab file on OpenBSD
date: "2025-07-10 11:35:33 +0100"
updated: "2025-07-10 11:35:33 +0100"
id: setup-crontab-file-on-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: UnixShell
background: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaVNja6EGdkyK1JzvFEt08iP_HIYjDboGyTA&s
toc: true
comments: true
published: true
excerpt: The active line in a crontab file is where the environment variable or cron command is set. Setting an environment variable in the crontab file creates the environment in which any commands in the crontab are executed.
keywords: crontab, cron, cronjob, openbsd, command, ddclient, shell
---

The crontab file is a file that contains instructions to the daemon [cron(8)](https://man.openbsd.org/cron.8). Commands in any crontab file will be executed either as the user that owns the crontab or, in the case of a system crontab, as the user specified on the command line. Although crontabs are text files, they are not intended to be edited directly. Creating, modifying, and deleting crontabs must be done using the crontab command [crontab(1)](https://man.openbsd.org/crontab.1).

The active line in a crontab file is where the environment variable or cron command is set. Setting an environment variable in the crontab file creates the environment in which any commands in the crontab are executed.

On OpenBSD systems, the crontab file is not immediately active. You must activate the crontab file for it to run according to your instructions. By default, on OpenBSD systems, the crontab file is located in `/etc/crontab`.

## A. Overview of the Crontab File

To make it easier to understand crontab files, we will briefly explain what crontab files are. Crontab files are commands [UNIX](https://www.techtarget.com/searchdatacenter/definition/Unix) which creates a table or list of commands, each of which will be executed by the operating system (OS) at a specific time and according to a schedule you specify. The crontab file is used to create a crontab file (list) and then to modify a previously created crontab file.

A crontab, short for cron table, is a file that schedules various cron entries to run at specific times. Another way to describe a crontab is as a utility that allows tasks to be run automatically at specified intervals in the background by the cron daemon (see below).

A crontab file contains simple instructions to the daemon that mean "run this command at a specific time and on a specific date." The crontab instructions specify which commands to run, on what date, and at what time.

This utility makes it easy for users to run OpenBSD scripts or commands at specific times and intervals. It's ideal for repetitive tasks like system maintenance, backups, and updates.

## B. How to Create a Crontab File

As discussed above, to run crontab, you must enable it. In this section, we will create a crontab file and enable it on an OpenBSD system.

To create a crontab file, run the following command.

```console
ns2# touch /etc/crontab
ns2# chown root:wheel /etc/crontab
ns2# chmod 0600 /etc/crontab
```
After you create a crontab file, you can type a cron script into it. For example, below is a script from the `/etc/crontab` file.

```console
#	$OpenBSD: crontab,v 1.28 2020/04/18 17:22:43 jmc Exp $
#
# /var/cron/tabs/root - root's crontab
#
SHELL=/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin
HOME=/var/log
#
#minute	hour	mday	month	wday	[flags] command
#
# rotate log files every hour, if necessary
0	*	*	*	*	/usr/bin/newsyslog
# send log file notifications, if necessary
#1-59	*	*	*	*	/usr/bin/newsyslog -m
#
# do daily/weekly/monthly maintenance
30	1	*	*	*	/bin/sh /etc/daily
30	3	*	*	6	/bin/sh /etc/weekly
30	5	1	*	*	/bin/sh /etc/monthly
#~	*	*	*	*	/usr/libexec/spamd-setup

#~	*	*	*	*	-ns rpki-client -v && bgpctl reload
```
To further clarify how to use a crontab script, we'll provide an example. Here's an example where we want to download the `br.zone` file on the 12th of every month at 5:00 AM.

```console
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
0 5 12 * * root wget --no-check-certificate https://www.ipdeny.com/ipblocks/data/countries/br.zone -O /etc/tables/br.zone
```
To see the activity of downloading the br.zone file, you can view the log file with the following command.

```console
ns2# tail -f /var/cron/log
```


## C. What You Need to Know About the Crontab File


Before we go any further, there are a few things you need to know about configuring the `/etc/crontab` file:

- **Log files**: The crontab log files are located in `"/var/cron/log"`. These files are useful for tracking the correct execution of commands.
- **Time to fetch file changes**: cron checks the modification time in the system crontab file every minute.
- **File mode**: The crontab file will be ignored if it does not have the correct file mode. The mode must be 0600. The file must not be writable by users other than root and must not have the execute, set-user-ID, set-group-ID, or sticky bits set.
- **Restart cron**: To reload the cron file run the command `"/etc/rc.d/cron restart"`.
- **Alternatively**: we can use the `/var/cron/tabs/root` file, to set up a crontab file at the root level.


## D. Crontab File Syntax

A crontab file is a built-in automation tool for OpenBSD users to manage task scheduling. Each user can have a separate crontab that holds multiple cronjobs that will be executed periodically by the cron daemon.

Below is the crontab syntax you can use when working with a crontab file.

- crontab [-u (for user)]
- crontab [-e (edit)]
- crontab [-l (list)]
- crontab [-r (remove)]

You can see an example of its use below.

```console
ns2# crontab -u root /etc/crontab
ns2# crontab -e
ns2# crontab -l
ns2# crontab -r
```
To activate crontab, you can use the restart command.

```console
ns2# /etc/rc.d/cron restart
```

Although the crontab file is disabled by default in OpenBSD, you should enable it to automate all daemon operations, especially those that run repeatedly, such as updating the IP address of the ddclient daemon and others.