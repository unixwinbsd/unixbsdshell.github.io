---
title: Scheduling Cron Process in FreeBSD With Crontab File
date: "2025-05-20 17:02:11 +0100"
updated: "2025-05-20 17:02:11 +0100"
id: scheduling-cron-process-in-freebsd-with-crontab-file
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: A cron job is a command executed by the cron daemon at regularly scheduled intervals. It's also known as a cron schedule, as it contains specific instructions about which commands to run and when they should start.
keywords: scheduling, crontab, cron, cronjob, file, freebsd, openbsd, command, shell, process
---

Crontab is a Unix command that creates a table or list of commands, each of which will be executed by the operating system (OS) at a user-defined time and regularly according to the instructions of a user-defined script. Crontab is used to create a crontab file (list) and then modify a previously created crontab file.

A crontab, often called a cron table, is a file that contains a schedule of various cron entries to be run at predetermined times. Another way to describe crontab is as a utility that allows tasks to run automatically at regular intervals in the background by the cron daemon.

Cron is a standard utility on the FreeBSD operating system that enables task automation. It is a daemon, which is a process that typically starts at boot time and runs in the background. The Cron daemon is a time-based scheduler that can run automatically. Meanwhile, a Cron job is a task performed by Cron that occurs during the boot process, or at a user-defined time.

## 1. Crontab and Cron Jobs

A cron job is a command executed by the cron daemon at regularly scheduled intervals. It's also known as a cron schedule because it contains specific instructions about which commands to run and when they should start.

gambar

Users can submit cron jobs by specifying the crontab command with the `-e flag or the -e option`. This command invokes an editing session so users can create a crontab file and add entries for each cron job to it. All entries must be in a format acceptable to the cron daemon.

Cron is typically used by system administrators to run periodic processes. Examples of processes that can be scheduled with Cron include:

- Back up important data and files.
- Update software and packages.
- Clean and defragment disks.
- Send automatic emails on a schedule.
- Send emails by IP address at boot time.
- Clean log files, etc.

On FreeBSD systems, as on most other UNIX-type systems, scheduling is called cron. As a standalone daemon, Cron can run continuously and check its input file (crontab) every minute to see if it has been modified or contains tasks that need to be run at that time.

One advantage of using Cron is that the cron process never needs to be restarted; the Cron file will automatically read changes every minute.

## 2. Crontab File

By default, FreeBSD places the Crontab file in `/etc/crontab`. This file contains the scheduled jobs run by the system, and a dedicated /var/cron/tabs directory allows individual users to create their own crontab queue files.

If possible, it's best not to edit the `/etc/crontab` file, but to create a separate queue file. Each crontab file is placed in the /var/cron/tabs directory. This security mechanism allows users to create and edit their own files without interfering with other users' files. This mechanism is the crontab utility.

The crontab file contains entries for each cron job, with each entry separated from the next by a newline character. Additionally, each entry contains `six columns/fields` separated by spaces.

See an example of a `six-column` crontab file below.

```yml
root@ns1:~ # ee /etc/crontab
#minutes   hours    daysofthemonth    months   daysoftheweek    user     commands
```

How to fill in each column is as follows:
- Minutes: Range from 0 to 59.
- Hour: Range from 0 to 23.
- Day of the month: Range from 1 to 31.
- Months: Range from 1 to 12.
- Day of the week: Range from 0 to 6, where 0 = Sunday.
- who: root.
- Command: newsyslog.

See an example crontab file below.

```console
root@ns1:~ # ee /etc/crontab
# /etc/crontab - root's crontab for FreeBSD
#
# $FreeBSD$
#
SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
#
#minute hour    mday    month   wday    who     command
#
# Save some entropy so that /dev/random can re-seed on boot.
*/11    *       *       *       *       operator /usr/libexec/save-entropy
#
# Rotate log files every hour, if necessary.
0       *       *       *       *       root    newsyslog
#
# Perform daily/weekly/monthly maintenance.
1       3       *       *       *       root    periodic daily
15      4       *       *       6       root    periodic weekly
30      5       1       *       *       root    periodic monthly
#
# Adjust the time zone if the CMOS clock keeps local time, as opposed to
# UTC time.  See adjkerntz(8) for details.
1,31    0-5     *       *       *       root    adjkerntz -a
```

## 3. How to Use the Crontab File

To better understand the crontab command, here are some examples of writing commands in the /etc/crontab file.

### a. Running an unbound program

```console
59 12 * * * gunungrinjani /usr/local/bin/unbound
```

The script above explains that the Gunungrinjani user will run the unbound program every day at 12:59 PM.

### b. Running the redist-cli program

```console
0 21 * * * root /usr/local/bin/redis-cli
```

The script above explains that the root user will run the redis-cli program every day at 9:00 PM.

### c. Restart the apache24 program.

```yml
0 1 * * 2-7 root root /usr/local/etc/rc.d/apache24 restart
```

The script above explains that the root user will restart the Apache24 program every Tuesday through Saturday at 1:00 AM.

### d. Shut down the Apache24 program.

```yml
30 07,09,13,15 * * * /usr/local/etc/rc.d/apache24 stop
```

The script above will shut down the apach24 program at 7:30, 9:30, 1:30, and 3:30 PM.

### e. Starting unbound programs

```yml
*/10 * * * * /usr/local/etc/rc.d/unbound start
```

The script above will activate an unbound program every 10 minutes.

In conclusion, Crontab can be a powerful tool for automating repetitive tasks, but it can also cause problems if not managed effectively. By following best practices for monitoring and managing cron jobs, developers can ensure their applications continue to run smoothly and efficiently.
