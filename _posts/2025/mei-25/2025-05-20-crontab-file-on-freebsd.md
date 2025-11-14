---
title: Setting up a crontab File on OpenBSD
date: "2025-05-20 17:02:11 +0100"
updated: "2025-05-20 17:02:11 +0100"
id: crontab-file-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The active line in a crontab file is the setting of an environment variable or cron command. Setting an environment variable in a crontab file will create the environment in which any command in the crontab is run.
keywords: crontab, cron, cronjob, file, openbsd, command, shell
---

A crontab file is one of the files that contains instructions to the cron daemon. Commands in any crontab file will be executed either as the user who owns the crontab or, in the case of a system crontab, as the user specified on the command line. Although crontabs are text files, they are not intended to be edited directly. Creating, modifying, and deleting crontabs must be done using crontab.

The active lines in a crontab file are either environment variable settings or cron commands. Setting environment variables in a crontab file creates the environment in which any commands in the crontab are executed.

On OpenBSD systems, crontab files are not directly active. You must activate the crontab file in order for it to run according to the instructions you give it. By default on OpenBSD systems, the crontab file is located in `/etc/crontab`.

## 1. Overview of Crontab Files

To make it easier to understand crontab files, we will explain a little about crontab files. Crontab files are Unix commands that create a table or list of commands, each of which will be run by the operating system (OS) at a specific time and according to a schedule that you have specified. Crontab files are used to create crontab files (lists) and then used to change previously created crontab files.

Crontab, which is short for cron table, is a file that contains a schedule of various cron entries that must be run at specific times. Another way to describe crontab is as a utility that allows tasks to run automatically at specific intervals in the background by the cron daemon (see below).

A crontab file contains simple instructions for the daemon that mean "run this command at a specific time and on a specific date." Crontab instructions specify which commands will be run, on what date, and at what time.

With this utility, it will be easier for users to run OpenBSD scripts or commands at specific times and intervals. This utility is ideal for repetitive tasks such as system maintenance, backups, and updates.

## 2. How to Create a Crontab File

As we have discussed above, to run crontab you must activate it. In this section we will create a crontab file and activate it on the OpenBSD system.

To create a crontab file, you run the following command.

```
ns2# touch /etc/crontab
ns2# chown root:wheel /etc/crontab
ns2# chmod 0600 /etc/crontab
```

Once you have created a crontab file, you can type a cron script into the file. For example, below we provide a script from the /etc/crontab file.

```
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

To further clarify how to use the crontab script, we provide an example. Here is an example where we want to download the br.zone file every 12th of each month and it is done at 5:00 am.

```
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

```
ns2# tail -f /var/cron/log
```

## 3. What You Need to Know About the Crontab File

Before we go any further, there are a few things you need to know about setting up the /etc/crontab file:

- **Log file:** The log file for crontab is located in "/var/cron/log". This file is useful for tracking the correct execution of commands.
- **Time to fetch file changes:** cron checks the modification time of the system crontab file every minute.
- **File mode:** The crontab file will be ignored if it does not have the correct file mode. The mode must be 0600. The file must not be writable by users other than root and must not have the execute, set-user-ID, set-group-ID, or sticky bits set.
- **Restart cron:** To reload the cron file run the command "/etc/rc.d/cron restart".
- **Alternatively:** we can use the file /var/cron/tabs/root, to set the crontab file at the root level.

### c.1. Crontab File Syntax

A crontab file is a built-in automation tool for OpenBSD users to manage task scheduling. Each user can have a separate crontab that holds several cronjobs that will be executed periodically by the cron daemon.

Below is the crontab syntax that you can run when working with a crontab file.
- crontab [-u (for user)]
- crontab [-e (edit)]
- crontab [-l (list)]
- crontab [-r (delete)]

You can see an example of its use below.

```
ns2# crontab -u root /etc/crontab
ns2# crontab -e
ns2# crontab -l
ns2# crontab -r
```

To enable crontab, you can use the restart command.

```
ns2# /etc/rc.d/cron restart
```

Although the crontab file is not active by default in OpenBSD, you must enable the file, so that all daemons that work can be automated with the crontab file. Especially daemons that run repeatedly, such as updating the IP Address of the ddclient daemon and others.
