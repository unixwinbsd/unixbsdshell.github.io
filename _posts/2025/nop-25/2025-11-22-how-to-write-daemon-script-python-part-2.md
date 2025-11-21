---
title: FreeBSD and Python - How to Write Daemon Script - Part 2
date: "2025-11-22 07:30:47 +0000"
updated: "2025-11-22 07:30:47 +0000"
id: how-to-write-daemon-script-python-part-2
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-025.jpg
toc: true
comments: true
published: true
excerpt: Since the first Python daemon appeared, the Python library has introduced a daemon runner to handle daemons. The first step to using the Python Daemon is to install the Python Daemon application.
keywords: script, python, daemon, freebsd, unix, bsd, command, shell, write
---

This article is a continuation of the previous article on how to write daemons with Python on FreeBSD. This article will discuss Init, often called `rc.d` in FreeBSD.

## 1. Init

Init scripts are used to control daemons (starting and stopping them, instructing them to reload configurations, etc.). There are various init systems used in Unix-like operating systems. FreeBSD uses the standard BSD init system called rc.d. This system works with multiple shell scripts (or not too few if you need to manage a particularly complex daemon).

<img alt="FreeBSD and Python - How to Write Daemon Script - Part 2" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-025.jpg' | absolute_url }}">

Since most of the init system's functions are the same across these scripts, rc.d handles all common cases in its own shell file, which is then used in each script. In Python, this can be done by importing modules, which is what shell scripting means searching for other shell scripts (or fragments).

For example, we'll create a file named `/usr/local/etc/rc.d/bdaemon` with the following script content.

```console
root@ns1:~ # ee /usr/local/etc/rc.d/bdaemon
#!/bin/sh
. /etc/rc.subr

name=bdaemon
rcvar=bdaemon_enable

command="/usr/sbin/daemon"
command_args="-p /var/run/${name}.pid /path/to/script/bdaemon.py"

load_rc_config $name
run_rc_command "$1"
```

What is rcvar? Well, by entering `“bdaemon_enable=YES”` into `/etc/rc.conf`, you can enable this daemon to start automatically at system startup. If that line isn't there, the daemon won't start. That's why we need to use `"onestart"` to start it (try it without "one" if you haven't done it before and see what happens!).

Then the command to be executed and the arguments for that command are specified. And finally, two helper functions from rc.subr are called, which do all the complicated magic that's thankfully hidden from us.

<script type="text/javascript">
	atOptions = {
		'key' : '88e2ead0fd62d24dc3871c471a86374c',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
</script>
<script type="text/javascript" src="//www.highperformanceformat.com/88e2ead0fd62d24dc3871c471a86374c/invoke.js"></script>

Okay, but what is `/usr/sbin/daemon?` FreeBSD comes with a very useful little utility that handles daemonization processes for others. This can be helpful if we want to use something as a background service but don't want to handle the actual daemonization ourselves.

The **"-p"** argument tells the daemon utility to handle the PID file for that process as well. This is necessary for the init system to control the daemon. Even though our little example program is short-lived, we can still do something while it's running. Consider the onestatus and onestop services, for example.

If there is no PID file, the init system will declare the daemon not running, even if it is, and the init system will not be able to stop it.

## 2. Daemonization with Python

The result of Part 1 is a program that actually requires external assistance to be daemonized. We'll try using FreeBSD's built-in daemon utility, which is useful for putting programs in the background, to handle the pidfile. Now let's move on and try to achieve the same thing using only Python.

To do this, we'll need a module that isn't part of the standard Python library. So, you may need to install the python-daemon package first. In the previous section, we learned how to install the python-daemon package on FreeBSD. Read Part 1 of that article. Below is a small piece of code that can be used to create a Python daemon.

```console
root@ns1:~ # ee /tmp/gunungsemeru.py
#!/usr/local/bin/python   
 
 # Imports #
import daemon, daemon.pidfile
import logging
import signal
import time

 # Fuctions #
def handler_sigterm(signum, frame):
    logging.debug("Exiting on SIGTERM")
    exit(0)

def main_program():
    signal.signal(signal.SIGTERM, handler_sigterm)
    try:
        logging.basicConfig(filename='/var/log/bdaemon.log', format='%(levelname)s:%(message)s', level=logging.DEBUG)
    except:
        print("Error: Could not create log file! Exiting...")
        exit(1)

    logging.info("Started!")
    while True:
        time.sleep(1)

 # Main #
with daemon.DaemonContext(pidfile=daemon.pidfile.TimeoutPIDLockFile("/var/run/bdaemon.pid"), umask=0o002):
    main_program()
```

In the example script above, there are two new imports for daemonization. As you can see in the script above, it's possible to import multiple modules in a single line. The first interesting thing about this version is that the main program is moved to a function called `"main_program"`.

We could have done this earlier if we really wanted, but we'll do it now so the code doesn't distract from the main point of this example. Notice the line that starts with the keyword with . Wow, that's pretty long, isn't it? Let's break it down into sections to make it easier to understand.

## 3. Updating the Init Script

Okay, the only thing left to do here is make the necessary changes to the init script. We're no longer using the daemon utility, so we need to adjust it accordingly. Here's an example of the new init script.

```console
root@ns1:~ # ee /usr/local/etc/rc.d/bdaemon
#!/bin/sh
 
. /etc/rc.subr
 
name=bdaemon
rcvar=bdaemon_enable
 
command="/root/bdaemon.py"
command_interpreter=/usr/local/bin/python   
pidfile="/var/run/${name}.pid"
 
load_rc_config $name
run_rc_command "$1"
```

There aren't many changes in the script above, but let's discuss what's happening. The command definition is pretty straightforward. The program can now daemonize itself, so we call it directly. No arguments are required, which means we can omit command_args. However, we need to add command_interpreter, as the program will appear like this in the process list.

Without defining an interpreter, the init system won't recognize this process as a valid one. We also need to point it to a pidfile, as there could theoretically be multiple matching processes. And that's it—we now have a daemon process running on FreeBSD, written in pure Python.
