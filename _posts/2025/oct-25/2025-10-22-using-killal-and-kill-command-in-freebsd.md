---
title: FreeBSD How to Install Spree E-Commerce into a Ruby on Rails Application
date: "2025-10-22 15:29:38 +0100"
updated: "2025-10-22 15:29:38 +0100"
id: using-killal-and-kill-command-in-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/oct-25-131.jpg
toc: true
comments: true
published: true
excerpt: In FreeBSD, signals were originally designed to model exceptional events, such as user attempts to terminate a malfunctioning or difficult-to-terminate program. Signals were not intended to be used as a general interprocess communication mechanism, and thus no effort was made to make them reliable.
keywords: kill, killal, freebsd, mysql, command, shell, unix, bournce, cmd
---

You may have encountered a situation where you're running an application and suddenly the application or your system becomes unresponsive. The solution is to try restarting the application, but you must first close it.

However, if the application you closed fails to close or shut down completely, you won't be able to start it again. Yes, we've all encountered this situation at least once while running a computer system. To resolve this issue, you need to terminate the application's idle processes. But now the question is, how? In this article, you'll learn two different approaches to killing all processes on the FreeBSD operating system.


## 1. What are the pkill and killall commands

Before we dive into specific examples of using the kill and killal commands, it's helpful to understand the basic concepts of both commands.

When an application fails to terminate, it continues to consume memory and processing power. Fortunately, FreeBSD provides a utility or utility command that helps you terminate processes that won't terminate. Okay, now let's discuss two different Linux commands: [kill process](https://stackoverflow.com/questions/31608085/which-programs-will-the-killall-command-kill) and killall, and how they work.

<br/>

![kill and killal](/img/oct-25/oct-25-131.jpg)

<br/>

`kill` is a basic command-line utility in FreeBSD that can send a signal to a process to terminate it. In FreeBSD, kill sends a TERM signal by default. This signal tells the process to terminate itself gracefully. If a process doesn't respond to the TERM signal, it can send a KILL signal, which immediately terminates the process.

`killall` is a tool for terminating processes running on your FreeBSD system by name. Kill, on the other hand, terminates processes by their Process ID (PID). kill and killall can also send specific system signals to applications to be terminated.

Use `killall and kill` in conjunction with tools like Process Status and ps to manage and terminate stuck or unresponsive processes.


## 2. FreeBSD System Signals

In FreeBSD, signals were originally designed to model exceptional events, such as user attempts to terminate a malfunctioning or difficult-to-terminate program. Signals were not intended to be used as a general interprocess communication mechanism, and thus no effort was made to make them reliable.

In earlier systems, every time a signal was caught, the action was reset to the default. The introduction of job control led to much more frequent signal usage, creating a more severe problem that was exacerbated by faster processors.

If two signals were sent simultaneously and executed quickly, the second signal could cause the process to terminate, even though the signal handler was configured to catch the first signal. At this point, reliability became desirable, so developers designed a new framework that retained some of the old capabilities while accommodating the new mechanism.
Signals allow a process to be manipulated from outside its domain, as well as allowing a process to manipulate itself or copy itself. There are two general types of signals:

- Signals that cause a process to terminate, and
- Signals that do not cause a process to terminate.

A signal that causes a program to terminate may be caused by an unrecoverable error or may be caused by a terminal user typing an interrupt character.

Signals are used when a process is terminated because it wants to access its control terminal while in the background. Optionally, signals are generated when a process is resumed after termination, when the state of a child process changes, or when input is ready at the control terminal.

Most signals result in the termination of the receiving process if no action is taken; some signals actually cause the receiving process to terminate, or are simply discarded if the process does not request otherwise.

Except for the SIGKILL and SIGSTOP signals, the signal function allows signals to be caught, ignored, or generated interrupts. These signals are defined in the `signal.h` file.


| Num       | Name          | Default Action        |  Description        |
| ----------- | -----------   | ----------- | ----------- |
| 1          | SIGHUP           | terminate process          | terminal line hangup          |
| 2          | SIGINT      | terminate process          | interrupt program          |
| 3          | SIGQUIT          | create core image          | quit program          |
| 4          | SIGILL      | create core image          | illegal instruction          |
| 5          | SIGTRAP          | create core image          | trace trap          |
| 6          | SIGABRT      | create core image          | abort program (formerly SIGIOT)          |
| 7          | SIGEMT          | create core image          | emulate instruction executed          |


## 3. How to Use the Kill Command

[The Terminate process command](https://www.veerotech.net/kb/how-to-kill-processes-in-linux-using-kill-killall-and-pkill/) is an essential utility every FreeBSD system administrator should know. If you're unable to terminate a daemon, the FreeBSD kill process and FreeBSD killall commands will help you terminate any stubborn daemons.

The kill command can terminate any individual process as specified by its PID.

The command has the following format:

```
# kill [-s signal_name] pid
# kill -l [exit_status]
# kill -signal_name pid
# kill -signal_number pid
```

The kill utility sends a signal to the process specified by its pid number. Any user can kill a process, but only the superuser can send a signal to another user's process.

The options are as follows:

- **s signal_name** The symbolic signal name that specifies the signal to be sent, not the default TERM.
- **l [exit_status]** If no operand is given, lists the signal name; otherwise, lists the signal name corresponding to exit_status.
- **signal_name** The symbolic signal name that specifies the signal to be sent, not the default TERM.
- **signal_number** A non-negative decimal integer, specifying the signal to be sent, not the default TERM.

While PID has a special meaning:

- **1 If superuser**, broadcast the signal to all processes; otherwise, broadcast to all processes belonging to the user.

Some of the most commonly used signals:

- HUP (hang up).
- INT (interrupt).
- QUIT (quit).
- ABRT (abort).
- KILL (non-catchable, non-ignorable kill).
- ALRM (alarm clock).
- TERM (software termination signal).

Below, we provide an example of how to use the kill command. In this example, we'll attempt to stop the Redis application daemon.

```sh
root@ns7:~ # ps -auwx | grep redis
redis 3046   0.0  0.5   34604   9620  -  Ss   07:33     0:00.01 redis-server: /usr/local/bin/redis-server 127.0.0.1:6379 (redis-server)
root  3048   0.0  0.1   12812   2368  0  S+   07:33     0:00.00 grep redis
```

In the above command the Redis PID number is 3046, now we will force the Redis daemon to stop with the kill command.

```
root@ns7:~ # kill -QUIT 3046
or
root@ns7:~ # kill -s QUIT 3046
```

If your computer is not responding to Redis signals, you can use HUP to stop the Redis daemon.

```
root@ns7:~ # kill -HUP 3046
or
root@ns7:~ # kill -s HUP 3046
```

## 4. How to Use the Killall Command

On FreeBSD, the killall utility is used to terminate processes selected by name, rather than by PID as with kill. By default, killall will send the TERM signal to all processes with the same UID as the caller of killall that match the procname. Only the superuser is allowed to terminate any process.

In general, the killall command can be written as follows:

```sh
# killall procname
```

Below, we provide an example of how to stop the `mysql-server` daemon. As we know, on FreeBSD, mysql-server has the default username and group name `mysql`.

Use the `ps -auwx` command to view the PID of the running mysql-server.

```sh
root@ns7:~ # ps -auwx | grep mysql
mysql 6940  78.2 31.5 2304128 563976  -  S    08:16     0:02.67 /usr/local/libexec/mysqld --defaults-extra-file=/usr/local/etc/mysql/my.cnf --basedir=/usr/local --datadir=/var/
mysql 5785   0.0  0.2   13580   3164  -  Ss   08:16     0:00.05 /bin/sh /usr/local/bin/mysqld_safe --defaults-extra-file=/usr/local/etc/mysql/my.cnf --basedir=/usr/local --data
root  6947   0.0  0.1   12812   2356  0  S+   08:16     0:00.00 grep mysql
```

In the command above, the mysql-server daemon is named `mysqld`. Now let's try to kill the mysql-server daemon with the killall command.

```sh
root@ns7:~ # killall mysqld
```

Let's see the result with the `ps -auwx` command.

```sh
root@ns7:~ # ps -auwx | grep mysql
root  6970   0.0  0.1 12812 2364  0  S+   08:20     0:00.00 grep mysql
```

The command above successfully shuts down the `mysql-server` daemon.

We can also shut down the mysql-server daemon by combining `"username" and "procname"`.

```sh
root@ns7:~ # killall -u mysql mysqld
```

In the above command, `mysql` is the mysql-server username, and `mysqld` is the mysql-server daemon.

Understanding the kill and killall commands is extremely helpful for a system administrator. Mastering these two commands is essential if you want to learn FreeBSD.